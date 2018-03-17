package Request;

use strict;
use LWP::UserAgent;
use HTTP::Request;
use JSON;

use Class::MethodMaker [
    scalar  => [ qw( ua ) ],
    new => [ qw(-init new ) ],
];

sub init {
    my ($self, $args) = @_;
    $self->ua(new LWP::UserAgent);
}

sub request {
    my ($self, $method, $url, $data, $headers) = @_;

    $headers = [] if ! $headers;

    my $res = $self->ua->request(new HTTP::Request($method, $url, $headers, $data));
    
    return $res->decoded_content;
}

sub json {
    my ($self, $method, $url, $data, $headers) = @_;
    
    my $jheader = { 'Content-Type' => 'application/json' };

    if (! $headers) {
        $headers = [ $jheader ];
    }
    else {
        push @$headers, $jheader;
    }

    return decode_json($self->request($method, $url, $data, $headers));
}

1;
