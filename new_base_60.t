### tantek's new base 60

use Test::More qw(no_plan);

use DateTime;
use POSIX qw(ceil floor);

unshift @INC, ".";

use NewBase60;

my @dates = (
    { date => '1970-01-01', days => '0',     sxg => '0',   ord => '1970-001' },
    { date => '1970-01-02', days => '1',     sxg => '1',   ord => '1970-002' },
    { date => '1971-06-29', days => '544',   sxg => '94',  ord => '1971-180' },
    { date => '2010-05-26', days => '14755', sxg => '45v', ord => '2010-146' },
);

for my $dd (@dates) {
    my ( $y, $m, $d ) = split /-/, $dd->{date};
    my $test_date = DateTime->new(
        year  => $y,
        month => $m,
        day   => $d,
    );
    my $ds = $dd->{date};

    my $epoch_days = date_to_num($test_date);
    is( $epoch_days, $dd->{days}, 'date_to_num returns correct value (' . $dd->{days} . ') for ' . $ds );

    my $dt = num_to_date( $dd->{days} );
    is( $dt->epoch, $test_date->epoch,
        'num_to_date returns correct date for value (' . $dd->{days} . ') for ' . $ds );

    my $ord_value = date_to_ord($test_date);
    is( $ord_value, $dd->{ord}, 'date_to_ord returns correct value (' . $dd->{ord} . ') for ' . $ds );

    $dt = ord_to_date( $dd->{ord} );
    is( $dt->epoch, $test_date->epoch, 'ord_to_date returns correct value (' . $test_date . ') for ' . $ds );

    $ord_value = num_to_ord( $dd->{days} );
    is( $ord_value, $dd->{ord}, 'num_to_ord returns correct value (' . $dd->{ord} . ') for ' . $ds );

    my $days = ord_to_num( $dd->{ord} );
    is( $days, $dd->{days}, 'ord_to_num returns correct value (' . $dd->{days} . ') for ' . $ds );

    $ord_value = sxg_to_ord( $dd->{sxg} );
    is( $ord_value, $dd->{ord}, 'sxg_to_ord returns correct value (' . $dd->{ord} . ') for ' . $ds );

    my $sxg_value = ord_to_sxg( $dd->{ord} );
    is( $sxg_value, $dd->{sxg}, 'num_to_sxg returns correct value (' . $dd->{sxg} . ') for ' . $ds );

    $sxg_value = num_to_sxg( $dd->{days} );
    is( $sxg_value, $dd->{sxg}, 'num_to_sxg returns correct value (' . $dd->{sxg} . ') for ' . $ds );

    my $dec_value = sxg_to_num( $dd->{sxg} );
    is( $dec_value, $dd->{days}, 'sxg_to_num returns correct value (' . $dd->{days} . ') for ' . $ds );

    $sxg_value = date_to_sxg($test_date);
    is( $sxg_value, $dd->{sxg}, 'date_to_sxg returns correct value (' . $dd->{sxg} . ') for ' . $ds );

    my $dt = sxg_to_date( $dd->{sxg} );
    is( $dt->epoch, $test_date->epoch,
        'sxg_to_date returns correct date for value (' . $dd->{sxg} . ') for ' . $ds );

}
