perl-request
======

Perl request API, inspired by python's request api

```perl
#!/usr/bin/perl

use strict;

use Request;
use Data::Dumper;

my $req = new Request;
my $res1 = $req->json('GET', 'https://datahub.io/core/country-list/r/data.json');

print Dumper $res1;
```

