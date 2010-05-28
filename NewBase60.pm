package NewBase60;

use strict;
use warnings;
use DateTime;
use POSIX qw(ceil floor);

our (@EXPORT);

BEGIN {
    use Exporter qw(import);
    @EXPORT = qw(date_to_num num_to_date
        date_to_ord ord_to_date
        num_to_ord ord_to_num
        num_to_sxg sxg_to_num num_to_sxgf
        sxg_to_ord ord_to_sxg
        date_to_sxg sxg_to_date
    );
}

=pod
NewBase60 is the start of a port from Tantek Celik's cassis implementation.

=cut

=pod
date_to_num - convert date to number of days since the epoch (1970-01-01)

=cut

sub date_to_num {
    my $dt = shift;
    $dt = new DateTime() unless defined $dt;
    my $ts = $dt->epoch;

    my $ets = DateTime->new(
        year  => 1970,
        month => 1,
        day   => 1,
    )->epoch;
    return floor( ( $ts - $ets ) / 86400 );    # 86400 == ( 60*60*24 ) == 1 day in seconds
}

# convert epoch days to a DateTime
sub num_to_date {
    my $d   = shift;
    my $ets = DateTime->new(
        year  => 1970,
        month => 1,
        day   => 1,
    )->epoch;
    my $epoch = $ets + ( $d * 86400 );         #days to seconds
    return DateTime->from_epoch( epoch => $epoch );
}

=pod
date_to_ord - convert datetime to an ordinal date (%YYYY-%DDD where
%DDD is the day of the year)

=cut

sub date_to_ord {
    my $dt = shift;
    $dt = DateTime->now() unless defined $dt;
    return $dt->year . "-" . sprintf( "%03d", $dt->doy );
}

sub ord_to_date {
    my $o = shift;
    my $n = ord_to_num($o);
    return num_to_date($n);
}

=pod
num_to_ord - convert number of epoch days to ordinal date

=cut

sub num_to_ord {
    my $n  = shift;
    my $dt = num_to_date($n);
    return date_to_ord($dt);
}

sub ord_to_num {
    my $o = shift;
    my ( $y, $days ) = split '-', $o;
    my $year_days = date_to_num( new DateTime( year => $y, month => '01', day => '01' ) );
    return $year_days + --$days;
}

=pod
num_to_sxg - convert number of epoch days to sexigesimal value

=cut

sub num_to_sxg {
    my ($n) = @_;
    my $s   = '';
    my $p   = '';
    my @m = split //, "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ_abcdefghijkmnopqrstuvwxyz";
    if ( !$n ) {
        return "0";
    }
    if ( $n < 0 ) {
        $n = 0 - $n;
        $p = "-";
    }
    while ( $n > 0 ) {
        my $d = $n % 60;
        $s = $m[$d] . $s;
        $n = ( $n - $d ) / 60;
    }
    return $p . $s;
}

sub num_to_sxgf {
    my ( $n, $f ) = @_;
    if ( !$f ) { $f = 1; }
    return sprintf( "%0${f}s", num_to_sxg($n) );
}

=pod
sxg_to_num - convert sexigesimal value to number of epoch days

=cut

sub sxg_to_num {
    my ($s) = @_;
    my @s = split //, $s;
    my $n = 0;
    my $m = 1;
    my $j = length($s);

    if ( $s[0] eq "-" ) {
        $m = -1;
        $j--;
        shift @s;
    }

    for ( my $i = 0; $i < $j; ++$i ) {
        my $c = ord( $s[$i] );
        if ( $c >= 48 && $c <= 57 ) { $c -= 48; }
        elsif ( $c >= 65 && $c <= 72 ) {
            $c -= 55;
        }

        # typo capital I, lowercase l to 1
        elsif ( $c == 73 || $c == 108 ) {
            $c = 1;
        }
        elsif ( $c >= 74 && $c <= 78 ) {
            $c -= 56;
        }

        # error correct typo capital O to 0
        elsif ( $c == 79 ) {
            $c = 0;
        }
        elsif ( $c >= 80 && $c <= 90 ) {
            $c -= 57;
        }

        # _ underscore and correct dash - to _
        elsif ( $c == 95 || $c == 45 ) {
            $c = 34;
        }

        elsif ( $c >= 97 && $c <= 107 ) {
            $c -= 62;
        }
        elsif ( $c >= 109 && $c <= 122 ) {
            $c -= 63;
        }

        # treat all other noise as 0
        else { $c = 0; }

        $n = 60 * $n + $c;
    }
    return $n * $m;
}

sub sxg_to_ord {
    my $s = shift;
    my $n = sxg_to_num($s);
    return num_to_ord($n);
}

sub ord_to_sxg {
    my $o = shift;
    my $n = ord_to_num($o);
    return num_to_sxg($n);
}

sub date_to_sxg {
    my $dt = shift;
    my $n  = date_to_num($dt);
    return num_to_sxg($n);
}

sub sxg_to_date {
    my $s = shift;
    my $n = sxg_to_num($s);
    return num_to_date($n);
}

1;
