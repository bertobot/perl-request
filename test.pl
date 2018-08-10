#!/usr/bin/perl

use strict;

use lib 'lib/perl5';
use Data::Dumper;
use Request;

use JSON;
my $j = JSON->new->allow_nonref;

printf "%s\n", $j->decode('null');

my $req = new Request;

my $res = $req->get('https://datahub.io/core/country-list/r/data.json');
my $res2 = $res->json;
print Dumper $res2;

my $res3 = $req->get('https://datahub.io/core/country-list/r/data.json')->body;
print Dumper $res3;

