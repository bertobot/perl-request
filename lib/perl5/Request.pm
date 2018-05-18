package Request;

use strict;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Cookies;
use JSON;

use Class::MethodMaker [
    scalar  => [ qw( ua ) ],
    new => [ qw(-init new ) ],
];

sub init {
    my ($self, $args) = @_;
    $self->ua(new LWP::UserAgent);
    $self->ua->cookie_jar(new HTTP::Cookies);
}

sub raw {
    my ($self, $method, $url, $data, $headers) = @_;

    $headers = [] if ! $headers;

    my $res = $self->ua->request(new HTTP::Request($method, $url, $headers, $data));
    
    return $res;
}

sub request {
    my ($self, $method, $url, $data, $headers) = @_;
    return $self->raw($method, $url, $data, $headers)->decoded_content;
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
