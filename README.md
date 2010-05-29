
## TinWhistle

TinWhistle is a simple URL shortener that uses the NewBase60 code as an essential part of the shortening algorithm. [This blog post](http://www.monkinetic.com/2010/05/tantek-celik-diso-20-brass-tacks.html) explains the algorithm in detail.

### Usage

    use TinWhistle;

    my $short = make_short_from_url ("2010/05/26/t2"); # t45v2
    
    # or, Tantek ordinal-days style:
    
    my $short = make_short_from_url ("2010/146/t2"); # t45v2
    
    # now expand to format of your choice
    
    my $long_as_ord = short_to_long_as_ord ($short); # 2010/146/t2
    
    my $long_as_ymd = short_to_long_as_ymd ($short); $ 2010/05/26/t2

## NewBase60.pm

NewBase60.pm is a perl implementation
[Tantek Celik](http://tantek.com)'s [new base 60](http://tantek.pbworks.com/NewBase60), a "a base 60 numbering system using only ASCII numbers and letters", part of his [cassis project](http://cassisproject.org). From the wiki page:

>"I needed a way to compress numbers for a URL shortener I am building so I looked at existing work, decided I could do better with a better design methodology, and ended up deriving a base 60 numbering system from ASCII characters."

(How this technique is used in Tantek's URL shortener is described in [this blog post](http://www.monkinetic.com/2010/05/tantek-celik-diso-20-brass-tacks.html)).

### Usage

    use TinWhistle::NewBase60;

    my $date = '1971-06-29';
    my ( $y, $m, $d ) = split /-/, $date;
    
    my $test_date = DateTime->new(
        year  => $y,
        month => $m,
        day   => $d,
    );
    
    # days *since* the epoch (1970-01-01)
    my $epoch_days = date_to_num ($date); # 544

    # that value encoded as sexagesimal
    my $sxg_days = num_to_sxg ($epoch_days); # 94
    
    # ordinal date per ISO8601 - YYYY-DDD
    my $ord_date = date_to_ord ($date); # 2010-146
    
   
    
