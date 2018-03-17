#!/usr/bin/perl

use strict;

use lib 'lib/perl5';
use Data::Dumper;
use Request;

use JSON;
my $j = JSON->new->allow_nonref;

printf "%s\n", $j->decode('null');

my $req = new Request;
my $res1 = $req->json('GET', 'https://datahub.io/core/country-list/r/data.json');
print Dumper $res1;
