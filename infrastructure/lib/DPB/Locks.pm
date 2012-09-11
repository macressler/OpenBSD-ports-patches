# ex:ts=8 sw=4:
# $OpenBSD: Locks.pm,v 1.15 2012/03/02 17:14:41 espie Exp $
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

package DPB::Locks;

use File::Path;
use Fcntl;

sub new
{
	my ($class, $state, $lockdir) = @_;

	File::Path::make_path($lockdir);
	my $o = bless {lockdir => $lockdir, 
		dpb_pid => $$, 
		dpb_host => DPB::Core::Local->hostname}, $class;
	if (!$state->defines("DONT_CLEAN_LOCKS")) {
		$o->clean_old_locks($state);
	}
	return $o;
}

sub clean_old_locks
{
	my $self = shift;
	my $locks = {};
	opendir(my $dir, $self->{lockdir});
	DIR: while (my $e = readdir($dir)) {
		my $f = "$self->{lockdir}/$e";
		next if -d $f;
		open my $fh, '<', $f or next;
		my ($pid, $host);
		while(<$fh>) {
			if (m/^dpb\=(\d+)\s+on\s+(\S+)$/) {
				($pid, $host) = ($1, $2);
				next DIR unless $host eq $self->{dpb_host};
			}
			if (m/^(?:error|status|todo)\=/) {
				next DIR;
			}
		}
		push(@{$locks->{$pid}}, $f) if defined $pid;
	}
	return if keys %$locks == 0;

	open(my $ps, "-|", "ps", "-axww", "-o", "pid args");
	my $junk = <$ps>;
	while (<$ps>) {
		if (m/^(\d+)\s+(.*)$/) {
			my ($pid, $cmd) = ($1, $2);
			if ($locks->{$pid} && $cmd =~ m/\bdpb\b/) {
				delete $locks->{$pid};
			}
		}
	}
	for my $list (values %$locks) {
		for my $l (@$list) {
			unlink($l);
		}
	}
}

sub build_lockname
{
	my ($self, $f) = @_;
	$f =~ tr|/|.|;
	return "$self->{lockdir}/$f";
}

sub lockname
{
	my ($self, $v) = @_;
	return $self->build_lockname($v->lockname);
}

sub dolock
{
	my ($self, $name, $v) = @_;
	if (sysopen my $fh, $name, O_CREAT|O_EXCL|O_WRONLY, 0666) {
		DPB::Util->make_hot($fh);
		print $fh "locked=", $v->logname, "\n";
		print $fh "dpb=", $self->{dpb_pid}, " on ", 
		    $self->{dpb_host}, "\n";
		$v->print_parent($fh);
		return $fh;
	} else {
		return 0;
	}
}

sub lock
{
	my ($self, $v) = @_;
	my $lock = $self->lockname($v);
	my $fh = $self->dolock($lock, $v);
	if ($fh) {
		return $fh;
	}
	return undef;
}

sub unlock
{
	my ($self, $v) = @_;
	unlink($self->lockname($v));
}

sub locked
{
	my ($self, $v) = @_;
	return -e $self->lockname($v);
}

sub recheck_errors
{
	my ($self, $engine) = (@_);

	for my $name (qw(errors locks)) {
		my $e = $engine->{$name};
		$engine->{$name} = [];
		while (my $v = shift @$e) {
			if ($v->unlock_conditions($engine)) {
				$self->unlock($v);
				$v->requeue($engine);
				next;
			}
			if ($self->locked($v)) {
				push(@{$engine->{$name}}, $v);
			} else {
				if ($name eq 'errors') {
					$engine->rescan($v);
				} else {
					$v->requeue($engine);
				}
			}
		}
	}
}

sub find_dependencies
{
	my ($self, $hostname) = @_;
	opendir(my $dir, $self->{lockdir});
	my $h = {};
	while (my $name = readdir($dir)) {
		my $fullname = $self->{lockdir}."/".$name;
		next if -d $fullname;
		next if $name =~ m/^host:/;
		open(my $f, '<', $fullname);
		my $host;
		my @d;
		while (<$f>) {
			if (m/^host=(.*)/) {
				$host = $1;
			} elsif (m/^needed=(.*)/) {
				@d = split(/\s/, $1);
			}
		}
		if (defined $host && $host eq $hostname) {
			for my $k (@d) {
				$h->{$k} = 1;
			}
		}
	}
	return sort keys %$h;
}

1;
