# ex:ts=8 sw=4:
# $OpenBSD: PkgPath.pm,v 1.20 2011/11/08 10:26:38 espie Exp $
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

# Handles PkgPath;
# all this code is *seriously* dependent on unique objects
# everything is done to normalize PkgPaths, so that we have
# one pkgpath object for each distinct flavor/subpackage combination

package DPB::PkgPath;
my $cache = {};

sub create
{
	my ($class, $fullpkgpath) = @_;
	# subdivide into flavors/multi
	# XXX we want to preserve empty fields
	my @list = split /,/, $fullpkgpath, -1;
	my $pkgpath = shift @list;
	my $o = bless { p => $pkgpath,
		# XXX
		has => 5, 
		new => 1}, $class;
	for my $v (@list) {
		if ($v =~ m/^\-/) {
			die "$fullpkgpath has >1 multi\n" 
			    if exists $o->{m};
			if ($v eq '-main') {
				$o->{m} = undef;
			} else {
				$o->{m} = $v;
			}
		} else {
			# XXX rely on stuff existing, no need to spring
			# an empty hash into existence
			if ($v eq '') {
				$o->{f} = undef if !exists $o->{f};
			} else {
				$o->{f}{$v} = 1;
			}
		}
	}

	return $o;
}

# cache just once, put into standard order, so that we don't
# create different objects for path,f1,f2 and path,f2,f1
sub normalize
{
	my $o = shift;

	my $fullpkgpath = $o->fullpkgpath;
	return $cache->{$fullpkgpath} //= $o;
}

# actual constructor
sub new
{
	my ($class, $fullpkgpath) = @_;
	if (defined $cache->{$fullpkgpath}) {
		return $cache->{$fullpkgpath};
	} else {
		return $class->create($fullpkgpath)->normalize;
	}
}

sub seen
{
	return values %$cache;
}

sub basic_list
{
	my $self = shift;
	my @list = ($self->{p});
	if (exists $self->{f}) {
		if (keys %{$self->{f}}) {
			push(@list, sort keys %{$self->{f}});
		} else {
			push(@list, '');
		}
	}
	return @list;
}
# string version, with everything in a standard order
sub fullpkgpath
{
	my $self = shift;
	my @list = $self->basic_list;
	if (defined $self->{m}) {
		push(@list, $self->{m});
	} elsif (exists $self->{m}) {
		push(@list, '-main');
	}
	return join (',', @list);
}

sub pkgpath
{
	my $self = shift;
	return $self->{p};
}

sub multi
{
	my $self = shift;
	if (defined $self->{m}) {
		return $self->{m};
	} elsif (exists $self->{m}) {
		return '-main';
	} else {
		return undef;
	}
}

sub logname
{
	&fullpkgpath;
}

sub lockname
{
	&logname;
}

sub simple_lockname
{
	&pkgpath;
}

sub print_parent
{
	my ($self, $fh) = @_;
	if (defined $self->{parent}) {
		print $fh "parent=", $self->{parent}->lockname, "\n";
	}
}

sub unlock_conditions
{
	my ($v, $engine) = @_;
	return $v->{info} && $engine->{buildable}{builder}->check($v);
}

sub requeue
{
	my ($v, $engine) = @_;
	$engine->requeue($v);
}

# without multi. Used by the SUBDIRs code to make sure we get the right
# value for default subpackage.

sub pkgpath_and_flavors
{
	my $self = shift;
	return join (',', $self->basic_list);
}

sub add_to_subdirlist
{
	my ($self, $list) = @_;
	$list->{$self->pkgpath_and_flavors} = 1;
}

# XXX
# in the ports tree, when you build with SUBDIR=n/value, you'll
# get all the -multi packages, but with the default flavor.
# we have to strip the flavor part to match the SUBDIR we asked for.

sub compose
{
	my ($class, $fullpkgpath, $pseudo) = @_;
	my $o = $class->create($fullpkgpath);
	if (defined $pseudo->{f}) {
		$o->{f} = $pseudo->{f};
	} else {
		delete $o->{f};
	}
	return $o->normalize;
}

# XXX All this code knows too much about PortInfo for proper OO

sub fullpkgname
{
	my $self = shift;
	return (defined $self->{info}) ?  $self->{info}->fullpkgname : undef;
}

sub may_create
{
	my ($n, $o, $h) = @_;
	my $k = $n->fullpkgpath;
	if (defined $cache->{$k}) {
		$n = $cache->{$k};
	} else {
		$cache->{$k} = $n;
	}
	$n->{has} //= $o->{has};
	$n->{new} //= $o->{new};
	$n->{info} //= $o->{info};
	$h->{$n} = $n;
	return $n;
}

sub simplifies_to
{
	my ($self, $simpler, $state) = @_;
	open my $quicklog, '>>', $state->logger->logfile('equiv');
	print $quicklog $self->fullpkgpath, " -> ", $simpler->fullpkgpath, "\n";
}

sub handle_equivalences
{
	my ($class, $state, $todo) = @_;
	my $h = {};
	for my $v (values %$todo) {
		$h->{$v} = $v;
		$v->handle_default_flavor($h, $state);
		$v->handle_default_subpackage($h, $state);
	}
	DPB::Job::Port->equates($h);
	DPB::Heuristics->equates($h);
}

sub zap_default
{
	my ($self, $subpackage) = @_;
	return $self unless defined $subpackage and defined $self->multi;
	if ($subpackage->string eq $self->multi) {
		my $o = bless {p => $self->{p}}, ref($self);
		if (defined $self->{f}) {
			$o->{f} = $self->{f};
		}
		return $o->normalize;
	} else {
		return $self;
	}
}

sub handle_default_flavor
{
	my ($self, $h, $state) = @_;

	if (!defined $self->{f}) {
		my $m = bless { p => $self->{p},
		    f => $self->{info}{FLAVOR}}, ref($self);
	    	if (exists $self->{m}) {
			$m->{m} = $self->{m};
		}
		$m = $m->may_create($self, $h);
		$m->simplifies_to($self, $state);
		$m->handle_default_subpackage($h, $state);
	}
}

# default subpackage leads to pkgpath,-default = pkgpath
sub handle_default_subpackage
{
	my ($self, $h, $state) = @_;
	my $m = $self->zap_default($self->{info}{SUBPACKAGE});
	if ($m ne $self) {
		$m = $m->may_create($self, $h);
		$self->simplifies_to($m, $state);
		$m->handle_default_flavor($h, $state);
	}
}

sub dump
{
	my ($self, $fh) = @_;
	print $fh $self->fullpkgpath, "\n";
	if (defined $self->{info}) {
		$self->{info}->dump($fh);
	}
}

sub quick_dump
{
	my ($self, $fh) = @_;
	print $fh $self->fullpkgpath, "\n";
	if (defined $self->{info}) {
		$self->{info}->quick_dump($fh);
	}
}

# we're always called from values corresponding to the same subdir.
sub merge_depends
{
	my ($class, $h) = @_;
	my $global = bless {}, "AddDepends";
	my $global2 = bless {}, "AddDepends";
	my $multi;
	for my $v (values %$h) {
		my $info = $v->{info};
		if (defined $info->{DIST}) {
			for my $f (values %{$info->{DIST}}) {
				$info->{FDEPENDS}{$f} = $f;
				bless $info->{FDEPENDS}, "AddDepends";
			}
		}
		# share !
		if (defined $info->{MULTI_PACKAGES}) {
			$multi = $info->{MULTI_PACKAGES};
		}
		# XXX don't grab dependencies for IGNOREd stuff
		next if defined $info->{IGNORE};

		for my $k (qw(LIB_DEPENDS BUILD_DEPENDS)) {
			if (defined $info->{$k}) {
				for my $d (values %{$info->{$k}}) {
					$global->{$d} = $d;
				}
			}
		}
		for my $k (qw(LIB_DEPENDS RUN_DEPENDS)) {
			if (defined $info->{$k}) {
				for my $d (values %{$info->{$k}}) {
					$info->{RDEPENDS}{$d} = $d;
					bless $info->{RDEPENDS}, "AddDepends";
				}
			}
		}
		for my $k (qw(DIST LIB_DEPENDS BUILD_DEPENDS RUN_DEPENDS 
		    SUBPACKAGE FLAVOR)) {
			delete $info->{$k};
		}
	}
	if (values %$global > 0) {
		for my $v (values %$h) {
			# remove stuff that depends on itself
			delete $global->{$v};
			$v->{info}{DEPENDS} = $global;
			$v->{info}{BDEPENDS} = $global2;
		}
	}
	if (defined $multi) {
		for my $v (values %$h) {
			$v->{info}{MULTI_PACKAGES} = $multi;
		}
	}
}

1;
