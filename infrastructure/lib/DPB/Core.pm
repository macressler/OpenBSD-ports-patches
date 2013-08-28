# ex:ts=8 sw=4:
# $OpenBSD: Core.pm,v 1.38 2013/08/28 11:55:06 espie Exp $
#
# Copyright (c) 2010 Marc Espie <espie@openbsd.org>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
use strict;
use warnings;

# we have unique objects for hosts, so we can put properties in there.
package DPB::Host;

my $hosts = {};

sub new
{
	my ($class, $name, $prop) = @_;
#	if ($class->name_is_localhost($name)) {
#		delete $prop->{wait_timeout};
#	}
	$hosts->{$name} //= bless {host => $name, 
		prop => DPB::HostProperties->finalize($prop) }, $class;
}

sub name
{
	my $self = shift;
	return $self->{host};
}

sub fullname
{
	my $self = shift;
	my $name = $self->name;
	if (defined $self->{prop}->{jobs}) {
		$name .= "/$self->{prop}->{jobs}";
	}
	return $name;
}

sub name_is_localhost
{
	my ($class, $host) = @_;
	if ($host eq "localhost" or $host eq DPB::Core::Local->hostname) {
		return 1;
	} else {
		return 0;
	}
}

sub is_localhost
{
	my $o = shift;
	return $o->name_is_localhost($o->{host});
}


# here, a "core" is an entity responsible for scheduling cpu, such as
# running a job, which is a collection of tasks.
# the "abstract core" part only sees about registering/unregistering cores,
# and having a global event handler that gets run whenever possible.
package DPB::Core::Abstract;

use POSIX ":sys_wait_h";
use OpenBSD::Error;
use DPB::Util;
use DPB::Job;

# need to know which host are around for affinity purposes
my %allhosts;
sub matches
{
	my ($self, $hostname) = @_;

	# same host
	return 1 if $self->hostname eq $hostname;
	# ... or host isn't around
	return 1 if !defined $allhosts{$hostname};
	# okay, try to avoid this
	return 0;
}


# note that we play dangerously, e.g., we only keep cores that are running
# something in there, the code can keep some others.
my ($running, $special) = ({}, {});
sub repositories
{
	return ($running, $special);
}

my @extra_stuff = ();

sub register_event
{
	my ($class, $code) = @_;
	push(@extra_stuff, $code);
}

sub handle_events
{
	for my $code (@extra_stuff) {
		&$code;
	}
}

sub is_alive
{
	return 1;
}

sub shellclass
{
	"DPB::Shell::Abstract"
}

sub shell
{
	my $self = shift;
	return $self->{shell};
}

sub new
{
	my ($class, $host, $prop) = @_;
	my $c = bless {host => DPB::Host->new($host, $prop)}, $class;
	$c->{shell} = $class->shellclass->new($c->host);
	$allhosts{$c->hostname} = 1;
	return $c;
}

sub host
{
	my $self = shift;
	return $self->{host};
}

sub prop
{
	my $self = shift;
	return $self->host->{prop};
}

sub sf
{
	my $self = shift;
	return $self->prop->{sf};
}

sub stuck_timeout
{
	my $self = shift;
	return $self->prop->{stuck_timeout};
}

sub fetch_timeout
{
	my $self = shift;
	return $self->prop->{fetch_timeout};
}

sub memory
{
	my $self = shift;
	return $self->prop->{memory};
}

sub parallel
{
	my $self = shift;
	return $self->prop->{parallel};
}

sub hostname
{
	my $self = shift;
	return $self->host->name;
}

sub lockname
{
	my $self = shift;
	return "host:".$self->hostname;
}

sub logname
{
	&hostname;
}

sub print_parent
{
	# Nothing to do
}

sub fullhostname
{
	my $self = shift;
	return $self->host->fullname;
}

sub register
{
	my ($self, $pid) = @_;
	$self->{pid} = $pid;
	$self->repository->{$self->{pid}} = $self;
}

sub unregister
{
	my ($self, $status) = @_;
	delete $self->repository->{$self->{pid}};
	delete $self->{pid};
	$self->{status} = $status;
	return $self;
}

sub terminate
{
	my $self = shift;
	if (defined $self->{pid}) {
		waitpid($self->{pid}, 0);
		$self->unregister($?);
		return $self;
    	} else {
		return undef;
	}
}

sub reap_kid
{
	my ($class, $kid) = @_;
	if (defined $kid && $kid > 0) {
		for my $repo ($class->repositories) {
			if (defined $repo->{$kid}) {
				$repo->{$kid}->unregister($?)->continue;
				last;
			}
		}
	}
	return $kid;
}

sub reap
{
	my ($class, $all) = @_;
	my $reaped = 0;
	$class->handle_events;
	$reaped++ while $class->reap_kid(waitpid(-1, WNOHANG)) > 0;
	return $reaped;
}

sub reap_wait
{
	my ($class, $reporter) = @_;

	return $class->reap_kid(waitpid(-1, 0));
}

sub cleanup
{
	my $class = shift;
	for my $repo ($class->repositories) {
		for my $pid (keys %$repo) {
			kill INT => $pid;
		}
	}
}

sub debug_dump
{
	my $self = shift;
	return $self->hostname;
}

OpenBSD::Handler->register( sub { __PACKAGE__->cleanup });

# this is a core that can run jobs
package DPB::Core::WithJobs;
our @ISA = qw(DPB::Core::Abstract);

sub fh
{
	my $self = shift;
	return $self->task->{fh};
}

sub job
{
	my $self = shift;
	return $self->{job};
}

sub debug_dump
{
	my $self = shift;
	return join(':',$self->hostname, $self->job->debug_dump);
}

sub task
{
	my $self = shift;
	return $self->job->{task};
}

sub terminate
{
	my $self = shift;
	$self->task->end  if $self->task;
	if ($self->SUPER::terminate) {
		$self->job->finalize($self);
	}
}

sub run_task
{
	my $core = shift;
	my $pid = $core->task->fork($core);
	if (!defined $pid) {
		die "Oops: task ".$core->task->name." couldn't start\n";
	} elsif ($pid == 0) {
		$DB::inhibit_exit = 0;
		for my $sig (keys %SIG) {
			$SIG{$sig} = 'DEFAULT';
		}
		if (!$core->task->run($core)) {
			exit(1);
		}
		exit(0);
	} else {
		$core->task->process($core);
		$core->register($pid);
	}
}

sub continue
{
	my $core = shift;
	if ($core->task->finalize($core)) {
		return $core->start_task;
	} else {
		return $core->job->finalize($core);
	}
}

sub start_task
{
	my $core = shift;
	my $task = $core->job->next_task($core);
	$core->job->{task} = $task;
	if (defined $task) {
		return $core->run_task;
	} else {
		return $core->job->finalize($core);
	}
}

sub mark_ready
{
	my $self = shift;
	delete $self->{job};
	return $self;
}

use Time::HiRes qw(time);
sub start_job
{
	my ($core, $job) = @_;
	$core->{job} = $job;
	$core->{started} = time;
	$core->{status} = 0;
	$core->start_task;
}

sub success
{
	my $self = shift;
	$self->host->{consecutive_failures} = 0;
}

sub failure
{
	my $self = shift;
	$self->host->{consecutive_failures}++;
}

sub start_clock
{
	my ($class, $tm) = @_;
	DPB::Core::Clock->start($tm);
}

package DPB::Core;
our @ISA = qw(DPB::Core::WithJobs);

my $available = [];

# used to remove cores from the build
my %stopped = ();

my $logdir;
my $lastcount = 0;

sub log_concurrency
{
	my ($class, $time, $fh) = @_;
	my $j = 0;
	while (my ($k, $c) = each %{$class->repository}) {
		$j++;
		if (defined $c->{swallow}) {
			$j += $c->{swallow};
		}
		if (defined $c->{swallowed}) {
			$j += scalar(@{$c->{swallowed}});
		}
	}
	if ($j != $lastcount) {
		print $fh "$$ $time $j\n";
		$lastcount = $j;
	}
}

sub set_logdir
{
	my $class = shift;
	$logdir = shift;
}

sub is_local
{
	return 0;
}

my @extra_report = ();
my @extra_important = ();
sub register_report
{
	my ($self, $code, $important) = @_;
	push (@extra_report, $code);
	push (@extra_important, $important);
}

sub repository
{
	return $running;
}

sub same_host_jobs
{
	my $self = shift;
	my @jobs = ();
	for my $core (values %{$self->repository}) {
		next if $core->hostname ne $self->hostname;
		push(@jobs, $core->job);
	}
	return @jobs;
}

sub one_core
{
	my ($core, $time) = @_;
	my $hostname = $core->hostname;
		
	my $s = $core->job->name." [$core->{pid}]".
	    (DPB::Host->name_is_localhost($hostname) ? "" : " on ".$hostname).
	    $core->job->watched($time, $core);
	if (defined $core->{swallowed}) {
		$s = (scalar(@{$core->{swallowed}})+1).'*'.$s;
	}
    	return $s;
}

sub report
{
	my $current = time();

	my $s = join("\n", map {one_core($_, $current)} sort {$a->{started} <=> $b->{started}} values %$running). "\n";
	for my $a (@extra_report) {
		$s .= &$a;
	}
	return $s;
}

sub important
{
	my $current = time();
	my $s = '';
	for my $j (values %$running) {
		if ($j->job->really_watch($current)) {
			$s .= one_core($j, $current)."\n";
		}
	}

	for my $a (@extra_important) {
		$s .= &$a;
	}
	return $s;
}

sub mark_ready
{
	my $self = shift;
	$self->SUPER::mark_ready;
	my $hostname = $self->hostname;
	if (-e "$logdir/stop-$hostname") {
		push(@{$stopped{$hostname}}, $self);
	} else {
		$self->mark_available($self);
	}
	return $self;
}

sub avail
{
	my $self = shift;
	for my $h (keys %stopped) {
		if (!-e "$logdir/stop-$h") {
			for my $c (@{$stopped{$h}}) {
				$self->mark_available($c);
			}
			delete $stopped{$h};
		}
	}
	return scalar(@{$self->available});
}

sub available
{
	return $available;
}

sub can_swallow
{
	my ($core, $n) = @_;
	$core->{swallow} = $n;
	$core->{swallowed} = [];
	$core->{realjobs} = $n+1;
	$core->host->{swallow}{$core} = $core;

	# try to reswallow freed things right away.
	if (@$available > 0) {
		my @l = @$available;
		$available = [];
		$core->mark_available(@l);
	}
}

sub mark_available
{
	my $self = shift;
	LOOP: for my $core (@_) {
		# okay, if this core swallowed stuff, then we release 
		# the swallowed stuff first
		if (defined $core->{swallowed}) {
			my $l = $core->{swallowed};

			# first prevent the recursive call from taking us into
			# account
			delete $core->{swallowed};
			delete $core->host->{swallow}{$core};
			delete $core->{swallow};
			delete $core->{realjobs};

			# then free up our swallowed jobs
			$self->mark_available(@$l);
		}

		# if this host has cores that swallow things, let us 
		# be swallowed
		if (defined $core->host->{swallow}) {
			for my $c (values %{$core->host->{swallow}}) {
				push(@{$c->{swallowed}}, $core);
				if (--$c->{swallow} == 0) {
					delete $core->host->{swallow}{$c};
				}
				next LOOP;
			}
		}
		push(@{$self->available}, $core);
	}
}

sub running
{
	return scalar(%$running);
}

sub get
{
	my $self = shift;
	$a = $self->available;
	if (@$a > 1) {
		@$a = sort {$b->sf <=> $a->sf} @$a;
	}
	return shift @$a;
}

sub get_affinity
{
	my ($self, $host) = @_;
	my $l = [];
	while (@$available > 0) {
		my $core = shift @$available;
		if ($core->hostname eq $host) {
			push(@$available, @$l);
			return $core;
		}
		push(@$l, $core);
	}
	$available = $l;
	return undef
}

my @all_cores = ();

sub all_sf
{
	my $l = [];
	for my $j (@all_cores) {
		next unless $j->is_alive;
		push(@$l, $j->sf);
	}
	return [sort {$a <=> $b} @$l];
}

sub new
{
	my ($class, $host, $prop) = @_;
	my $o = $class->SUPER::new($host, $prop);
	push(@all_cores, $o);
	return $o;
}

sub new_noreg
{
	my ($class, $host, $prop) = @_;
	$class->SUPER::new($host, $prop);
}

sub start_pipe
{
	my ($self, $code, $name) = @_;
	$self->start_job(DPB::Job::Pipe->new($code, $name));
}

package DPB::Core::Special;
our @ISA = qw(DPB::Core::WithJobs);
sub repository
{
	return $special;
}

package DPB::Core::Local;
our @ISA = qw(DPB::Core);

my $host;
sub hostname
{
	if (!defined $host) {
		chomp($host = `hostname`);
	}
	return $host;
}

sub is_local
{
	return 1;
}

sub shellclass
{
	"DPB::Shell::Local"
}

package DPB::Core::Fetcher;
our @ISA = qw(DPB::Core::Local);

my $fetchcores = [];

sub available
{
	return $fetchcores;
}

package DPB::Core::Clock;
our @ISA = qw(DPB::Core::Special);

sub start
{
	my ($class, $timeout) = @_;
	my $core = $class->new('localhost');
	$timeout //= 10;
	$core->start_job(DPB::Job::Infinite->new(DPB::Task::Fork->new(sub {
		sleep($timeout);
		exit(0);
		}), 'clock'));
}

# the shell package is used to exec commands.
# note that we're dealing with exec, so we can modify the object/context
# itself with abandon
package DPB::Shell::Abstract;

sub new
{
	my ($class, $host) = @_;
	bless {}, $class;
}

sub chdir
{
	my ($self, $dir) = @_;
	$self->{dir} = $dir;
	return $self;
}

sub env
{
	my ($self, %h) = @_;
	while (my ($k, $v) = each %h) {
		$self->{env}{$k} = $v;
	}
	return $self;
}

package DPB::Shell::Local;
our @ISA = qw(DPB::Shell::Abstract);

sub chdir
{
	my ($self, $dir) = @_;
	CORE::chdir($dir) or die "Can't chdir to $dir\n";
	return $self;
}

sub env
{
	my ($self, %h) = @_;
	while (my ($k, $v) = each %h) {
		$ENV{$k} = $v;
	}
	return $self;
}

sub exec
{
	my ($self, @argv) = @_;
	exec {$argv[0]} @argv;
}

1;
