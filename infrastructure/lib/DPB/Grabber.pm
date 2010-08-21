# ex:ts=8 sw=4:
# $OpenBSD: Grabber.pm,v 1.1.1.1 2010/08/20 13:40:13 espie Exp $
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


use DPB::Vars;
use DPB::Util;

package DPB::Grabber;
sub new
{
	my ($class, $ports, $make, $logger, $engine, $dpb, $endcode) = @_;
	bless { ports => $ports, make => $make,
		loglist => DPB::Util->make_hot($logger->open("vars")),
		engine => $engine,
		dpb => $dpb,
		keep_going => 1,
		endcode => $endcode
	    }, $class;
}

sub finish
{
	my ($self, $h) = @_;
	for my $v (values %$h) {
		if ($v->{broken}) {
			delete $v->{info};
			$self->{engine}->add_fatal($v);
		} else {
			$self->{engine}->new_path($v);
		}
	}
	$self->{keepgoing} = &{$self->{endcode}};
}

sub grab_subdirs
{
	my ($self, $core, $list) = @_;
	DPB::Vars->grab_list($core, $self->{ports}, $self->{make}, $list,
	    $self->{loglist}, $self->{dpb},
	    sub {
		$self->finish(shift);
	});
}


sub complete_subdirs
{
	my ($self, $core) = @_;
	# more passes if necessary
	while ($self->{keep_going}) {
		my @subdirlist = ();
		for my $v (DPB::PkgPath->seen) {
			next if defined $v->{info};
			if (defined $v->{tried}) {
				$self->{engine}->add_fatal($v);
			}
			$v->add_to_subdirlist(\@subdirlist);
			$v->{tried} = 1;
		}
		last if @subdirlist == 0;

		$self->grab_subdirs($core, \@subdirlist);
	}
}

1;