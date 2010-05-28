## NewBase60.pm

NewBase60.pm is a perl implementation [Tantek Celik](http://tantek.com)'s [new base 60](http://tantek.pbworks.com/NewBase60), a "a base 60 numbering system using only ASCII numbers and letters". From the wiki page about it:

>"I needed a way to compress numbers for a URL shortener I am building so I looked at existing work, decided I could do better with a better design methodology, and ended up deriving a base 60 numbering system from ASCII characters."

## Usage

    use NewBase60 qw(date_to_num num_to_date
        date_to_ord ord_to_date
        num_to_ord ord_to_num
        num_to_sxg sxg_to_num
        sxg_to_ord ord_to_sxg
        date_to_sxg sxg_to_date
    );

    my $date = '1971-06-29';
    my ( $y, $m, $d ) = split /-/, $date;
    
    my $test_date = DateTime->new(
        year  => $y,
        month => $m,
        day   => $d,
    );
    
    # days *since* the epoch (1970-01-01)
    my $epoch_days = date_to_num ($date); # 544

    # that value encoded as sexigesimal
    my $sxg_days = num_to_sxg ($epoch_days); # 94
    
    # ordinal date per ISO8601 - YYYY-DDD
    my $ord_date = date_to_ord ($date); # 2010-146
    
    