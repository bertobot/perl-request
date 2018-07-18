#!/usr/bin/perl

use strict;

use lib 'lib/perl5';
use Data::Dumper;
use Request;
use Getopt::Long;

my $opt_cacert;
my $opt_cert;
my $opt_key;

GetOptions(
    "cacert=s"  => \$opt_cacert,
    "cert=s"    => \$opt_cert,
    "key=s"     => \$opt_key,
);

my $req = new Request({
    cacert  => $opt_cacert,
    cert    => $opt_cert,
    key     => $opt_key,
});

my $res3 = $req->get('https://fairfaxsmartware.com')->body;
print Dumper $res3;

