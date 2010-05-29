package TinWhistle;

use strict;
use warnings;
use DateTime;

our (@EXPORT);

BEGIN {
    use Exporter qw(import);
    @EXPORT = qw(
        parse_short_url
        short_to_long_as_ord short_to_long_as_ymd
        make_short_from_data make_short_from_url
    );
}

use TinWhistle::NewBase60;

# structure

# content types
# - b blog post
# - t text or tweet
# - p photo

# sexigesimal days value
# - SSS

# post number
# - n

=pod
parse_short_url - takes a TinWhistle short URL and returns a data structure containing its components:

* post_type: a single letter signifying what kind of post this is referring to
* sss: a sexagesimal number representing the post date as days since the epoch
* post_num: number of the post on this day (first, second, third, etc)

=cut

sub parse_short_url {
    my $short_url = shift;
    if ( $short_url =~ /(\w)([\w\d]{3})([\w\d]+)/ ) {
        return { post_type => $1, sss => $2, post_num => $3 };
    }
}

=pod
short_to_long_as_ord - takes a TinWhistle short URL and returns an ordinal-style long URL

Example:

short_to_long_as_ord ("t45v2"); # returns "2010/146/t2"

=cut

sub short_to_long_as_ord {
    my $s   = shift;
    my $d   = parse_short_url($s);
    my $ord = sxg_to_ord( $d->{sss} );
    my ( $y, $days ) = split /-/, $ord;
    return "$y/$days/" . $d->{post_type} . $d->{post_num};
}

=pod
short_to_long_as_ymd - takes a TinWhistle short URL and returns an year-month-day-style long URL

Example:

short_to_long_as_ymd ("t45v2"); # returns "2010/05/26/t2"

=cut

sub short_to_long_as_ymd {
    my $s  = shift;
    my $d  = parse_short_url($s);
    my $dt = sxg_to_date( $d->{sss} );
    return join "/",
        (
        $dt->year,
        sprintf( "%02d", $dt->month ),
        sprintf( "%02d", $dt->day ),
        ( $d->{post_type} . $d->{post_num} )
        );
}

=pod
make_sort_from_data - takes a DateTime, post_type, and post_num and generates a shortlink from it.

=cut

sub make_short_from_data {
    my ( $dt, $post_type, $post_num ) = @_;
    my $s = date_to_sxgf($dt);
    return $post_type . $s . $post_num;
}

=pod
make_short_from_url - takes a url following one of two styles and generates a shortlink from it

* 2010/146/t2 - ordinal year and days, Tantek-style
* 2010/05/26/t2 - year/month/day

=cut

sub make_short_from_url {
    my $u = shift;

    # YMD
    my $dt;
    my ( $year, $month, $day, $ord, $post_type, $post_num );
    if ( $u =~ /([\d]{4})\/([\d]{2})\/([\d]{2})\/(\w)(\d+)/ ) {
        ( $year, $month, $day, $post_type, $post_num ) = ( $1, $2, $3, $4, $5 );
        $dt = DateTime->new( year => $year, month => $month, day => $day );
    }
    elsif ( $u =~ /([\d]{4})\/([\d]{3})\/(\w)(\d+)/ ) {
        ( $year, $ord, $post_type, $post_num ) = ( $1, $2, $3, $4 );
        $dt = ord_to_date("$year-$ord");
    }
    return make_short_from_data( $dt, $post_type, $post_num );
}
