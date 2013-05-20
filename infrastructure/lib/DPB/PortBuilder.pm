# ex:ts=8 sw=4:
# $OpenBSD: PortBuilder.pm,v 1.45 2013/05/18 17:24:46 espie Exp $
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

# this object is responsible for launching the build of ports
# which mostly includes starting the right jobs
package DPB::PortBuilder;
use File::Path;
use DPB::Util;
use DPB::Job::Port;

sub new
{
	my ($class, $state) = @_;
	if ($state->opt('R')) {
		$class = $class->rebuild_class;
	}
	my $self = bless {
	    state => $state,
	    clean => $state->opt('c'),
	    dontclean => $state->{dontclean},
	    fetch => $state->opt('f'),
	    size => $state->opt('s'),
	    fullrepo => $state->fullrepo,
	    heuristics => $state->heuristics}, $class;
	if ($state->opt('u') || $state->opt('U')) {
		$self->{update} = 1;
	}
	if ($state->opt('U')) {
		$self->{forceupdate} = 1;
	}
	$self->init;
	return $self;
}

sub want_size
{
	my ($self, $v) = @_;
	if (!$self->{size}) {
		return 0;
	}
	if ($self->{heuristics}->match_pkgname($v)) {
		return rand(10) < 1;
	} else {
		return 1;
	}
}

sub rebuild_class
{ 'DPB::PortBuilder::Rebuild' }

sub ports
{
	my $self = shift;
	return $self->{state}->ports;
}

sub logger
{
	my $self = shift;
	return $self->{state}->logger;
}

sub locker
{
	my $self = shift;
	return $self->{state}->locker;
}

sub dontjunk
{
	my ($self, $v) = @_;
	$self->{dontjunk}{$v->fullpkgname} = 1;
}

sub make
{
	my $self = shift;
	return $self->{state}->make;
}

sub make_args
{
	my $self = shift;
	return $self->{state}->make_args;
}

sub init
{
	my $self = shift;
	File::Path::make_path($self->{fullrepo});
	$self->{global} = $self->logger->open("build");
	$self->{lockperf} = 
	    DPB::Util->make_hot($self->logger->open("awaiting-locks"));
	if ($self->{size}) {
		$self->{logsize} = 
		    DPB::Util->make_hot($self->logger->open("size"));
	}
	if ($self->{state}->defines("WRAP_MAKE")) {
		$self->{rsslog} = $self->logger->logfile("rss");
		$self->{wrapper} = $self->{state}->defines("WRAP_MAKE");
	}
}

sub pkgfile
{
	my ($self, $v) = @_;
	my $name = $v->fullpkgname;
	return "$self->{fullrepo}/$name.tgz";
}

sub check
{
	my ($self, $v) = @_;
	return -f $self->pkgfile($v);
}

sub checks_rebuild
{
}

sub register_package
{
}

sub report
{
	my ($self, $v, $job, $core) = @_;
	return if $job->{signature_only};
	my $pkgpath = $v->fullpkgpath;
	my $host = $core->fullhostname;
	if ($core->{realjobs}) {
		$host .= '*'.$core->{realjobs};
	}
	my $log = $self->{global};
	my $sz = (stat $self->logger->log_pkgpath($v))[7];
	if (defined $job->{offset}) {
		$sz -= $job->{offset};
	}
	print $log "$pkgpath $host ", $job->totaltime, " ", $sz, " ",
	    $job->timings;
	if ($self->check($v)) {
		print $log  "\n";
		open my $fh, '>>', $self->{state}{permanent_log};
		print $fh join(' ', $pkgpath, $host, $job->totaltime, $sz),
		    "\n";
	} else {
		open my $fh, '>>', $job->{log};
		print $fh "Error: ", $self->pkgfile($v), " does not exist\n";
		print $log  "!\n";
	}
}

sub get
{
	my $self = shift;
	return DPB::Core->get;
}

sub end_lock
{
	my ($self, $lock, $core, $job) = @_;
	my $end = time();
	print $lock "status=$core->{status}\n";
	print $lock "todo=", $job->current_task, "\n";
	print $lock "end=$end (", DPB::Util->time2string($end), ")\n";
	close $lock;
}

sub build
{
	my ($self, $v, $core, $lock, $final_sub) = @_;
	my $start = time();
	my $log = $self->logger->make_logs($v);
	my $special = $self->{heuristics}->special_parameters($core, $v);

	open my $fh, ">>", $log;
	if ($special) {
		print $lock "mfs\n";
		print $fh ">>> Building in memory under ";
	} else {
		print $fh ">>> Building under ";
	}
	$v->quick_dump($fh);

	my $job;
	$job = DPB::Job::Port->new($log, $fh, $v, $lock, $self, $special, $core,
	    sub {
	    	close($fh); 
		$self->end_lock($lock, $core, $job); 
		$self->report($v, $job, $core); 
		&$final_sub;
	    });
	$core->start_job($job, $v);
	if ($job->{parallel}) {
		$core->can_swallow($job->{parallel}-1);
	}
	print $lock "host=", $core->hostname, "\n",
	    "pid=$core->{pid}\n",
	    "start=$start (", DPB::Util->time2string($start), ")\n";
	$job->set_watch($self->logger, $v);
}

sub install
{
	my ($self, $v, $core) = @_;
	my $log = $self->logger->make_logs($v);
	open my $fh, ">>", $log;
	print $fh ">>> Installing under ";
	$v->quick_dump($fh);
	my $job = DPB::Job::Port::Install->new($log, $fh, $v, $self,
	    sub {
	    	close($fh);
	    	$core->mark_ready; 
	    });
	$core->start_job($job, $v);
	return $core;
}

package DPB::PortBuilder::Rebuild;
our @ISA = qw(DPB::PortBuilder);

sub init
{
	my $self = shift;
	$self->SUPER::init;

	require OpenBSD::PackageRepository;
	$self->{repository} = OpenBSD::PackageRepository->new(
	    "file:/$self->{fullrepo}");
	# this is just a dummy core, for running quick pipes
	$self->{core} = DPB::Core->new_noreg('localhost');
}

my $uptodate = {};

sub equal_signatures
{
	my ($self, $core, $v) = @_;
	my $p = $self->{repository}->find($v->fullpkgname.".tgz");
	my $plist = $p->plist(\&OpenBSD::PackingList::UpdateInfoOnly);
	my $pkgsig = $plist->signature->string;
	# and the port
	my $portsig = $self->{state}->grabber->grab_signature($core,
	    $v->fullpkgpath);
	return $portsig eq $pkgsig;
}

sub check_signature
{
	my ($self, $core, $v) = @_;
	my $okay = 1;
	for my $w ($v->build_path_list) {
		my $name = $w->fullpkgname;
		if (!-f "$self->{fullrepo}/$name.tgz") {
			print "$name: absent\n";
			$okay = 0;
			next;
		}
		next if $uptodate->{$name};
		if ($self->equal_signatures($core, $w)) {
			$uptodate->{$name} = 1;
			print "$name: uptodate\n";
			next;
		}
		print "$name: rebuild\n";
		$self->{state}->grabber->clean_packages($core,
		    $w->fullpkgpath);
	    	$okay = 0;
	}
	return $okay;
}

# this is due to the fact check_signature is within a child
sub register_package
{
	my ($self, $v) = @_;
	$uptodate->{$v->fullpkgname} = 1;
}

sub check
{
	my ($self, $v) = @_;
	return 0 unless $self->SUPER::check($v);
	return $uptodate->{$v->fullpkgname};
}

sub checks_rebuild
{
	my ($self, $v) = @_;
	return 1 unless $uptodate->{$v->fullpkgname};
}

