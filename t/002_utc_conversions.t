#!perl -T

use strict;
BEGIN { $^W = 1 }

use Test::More qw(no_plan);
use DateTime;
use DateTime::TimeZone::TAI;

my $tz;

SKIP: {
    skip "Can't create a timezone without a category yet", 2;

    $tz = DateTime::TimeZone->new( name => 'TAI' );
    isa_ok( $tz, 'DateTime::TimeZone' );
    is( $tz->name, 'TAI', 'timezone name is TAI' );
}

$tz = DateTime::TimeZone::TAI->new;

for (
      ['1997-06-01T00:00:00 UTC' => '1997-06-01T00:00:30 TAI'],
      ['1997-06-30T23:59:59 UTC' => '1997-07-01T00:00:29 TAI'],
#      ['1997-06-30T23:59:60 UTC' => '1997-07-01T00:00:30 TAI'],
      ['1997-07-01T00:00:00 UTC' => '1997-07-01T00:00:31 TAI'],
      ['1997-07-01T00:00:01 UTC' => '1997-07-01T00:00:32 TAI'],
      ['1997-07-01T10:00:00 UTC' => '1997-07-01T10:00:31 TAI'],
      ['1997-07-01T23:59:59 UTC' => '1997-07-02T00:00:30 TAI'],
      ['1997-08-01T00:00:00 UTC' => '1997-08-01T00:00:31 TAI'],
                                                                ) {

    my ($y, $m, $d, $h, $min, $s, $frac) =
        $_->[1] =~ /(\d+)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)(?:(\.\d+))? TAI/
            or die;

    my $tai = DateTime->new( year => $y, month => $m, day => $d,
                             hour => $h, minute => $min, second => $s,
                             nanosecond => ($frac||0) * 1e9,
                             time_zone  => $tz );

    is( $tai->iso8601() . ' TAI', $_->[1], "correct TAI date $_->[1]" );

    my $dt = $tai->clone;
    $dt->set_time_zone( 'UTC' );
    is( $dt->iso8601() . ' UTC', $_->[0], "correct TAI => UTC date $_->[1]" );

    $dt->set_time_zone( $tz );
    is( $dt->iso8601() . ' TAI', $_->[1], "correct UTC => TAI date $_->[1]" );
}
