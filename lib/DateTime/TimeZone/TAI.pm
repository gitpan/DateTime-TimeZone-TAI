package DateTime::TimeZone::TAI;

use strict;

use vars qw ($VERSION);
$VERSION = '0.00_01';

use base 'DateTime::TimeZone';

use DateTime::LeapSecond;

# TAI-UTC on 1972-01-01
use constant TAI_OFFSET => 10;

sub new
{
    my $class = shift;

    return bless { name => 'TAI' }, $class;
}

sub is_dst_for_datetime { 0 }

sub offset_for_datetime {
    my $self = shift;

    my $offset = TAI_OFFSET + $_[0]->leap_seconds;

    return $offset;
}

sub offset_for_local_datetime {
    my $self = shift;

    my $rd_as_seconds = $_[0]->local_rd_as_seconds;
    my $rd = int($rd_as_seconds/86_400);
    my $seconds = $rd_as_seconds % 86_400;

    my $offset = TAI_OFFSET + DateTime::LeapSecond::leap_seconds($rd);

    # We assume that TAI - UTC is positive (and that the total offset is
    # smaller than 86_400...)
    if ($seconds < $offset) {
        $offset = TAI_OFFSET + DateTime::LeapSecond::leap_seconds($rd - 1);
    }

    return $offset;
}

sub short_name_for_datetime { 'TAI' }

sub category { undef }

sub is_utc { 0 }

1;
__END__

=head1 NAME

DateTime::TimeZone::TAI - Implements the TAI time scale for DateTime objects

=head1 SYNOPSIS

  use DateTime::TimeZone::TAI;

  my $tz_tai = DateTime::TimeZone::TAI->new();

  my $date = DateTime->now( time_zone => $tz_tai );

=head1 DESCRIPTION

This module implements the TAI (International Atomic Time) time scale.
Although TAI is not technically a time zone, it can be implemented as
such. The time zone offset is equal to (TAI - UTC), which increases by 1
second whenever a leap second occurs.

=head1 METHODS

DateTime::TimeZone::TAI implements the same methods as other TimeZone
modules. See L<DateTime::TimeZone>.

=head1 BUGS

When you try to define a DateTime that is exactly on a leap second, with
timezone TAI, the resulting time will be one second off. This is because
of a bug in the DateTime leap second handling (as of version 0.24).

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

=head1 AUTHOR

Eugene van der Pijll C<< <pijll@cpan.org> >>

=head1 COPYRIGHT

Copyright (c) 2004 Eugene van der Pijll.  All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

http://datetime.perl.org/

=cut
