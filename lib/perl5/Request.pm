package Request;

use strict;
use warnings;
use Response;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Cookies;
use IO::Socket::SSL;
use JSON;

use Class::MethodMaker [
    scalar  => [ qw( ua ) ],
    new => [ qw(-init new ) ],
];

sub init {
    my ($self, $args) = @_;
    
    if ($args->{cacert} || $args->{cert} || $args->{key}) {
        $self->ua(new LWP::UserAgent( ssl_opts => {
            SSL_use_cert    => 1,
            SSL_version     => $args->{SSL_version} || 'TLSv12',
            SSL_verify_mode => $args->{SSL_VERIFY_PEER} || IO::Socket::SSL::SSL_VERIFY_PEER,
            SSL_ca_file     => $args->{cacert},
            SSL_cert_file   => $args->{cert},
            SSL_key_file    => $args->{key}
        }));
    }
    else {
        $self->ua(new LWP::UserAgent);
    }

    # set timeout
    $self->ua->timeout($args->{timeout} || 180);

    $self->ua->cookie_jar(new HTTP::Cookies);
}

sub raw {
    my ($self, $method, $url, $args) = @_;

    my $headers = $args->{headers} || [];

    my $data = $args->{data};
    $data = undef if defined $data && length($data) == 0;

    if ($args->{tofile}) {
        #return $self->ua->request(new HTTP::Request($method, $url, $headers, $data), ':content_file' => $args->{tofile}, ':read_size_hint' => 8192);
        return $self->ua->request(new HTTP::Request($method, $url, $headers, $data), $args->{tofile});
    }

    return $self->ua->request(new HTTP::Request($method, $url, $headers, $data));
}    

sub request {
    my ($self, $method, $url, $args) = @_;
    return new Response($self->raw($method, $url, $args));
}

# convenience 
sub get {
    my ($self, $url, $args) = @_;
    return $self->request('GET', $url, $args);
}

sub post {
    my ($self, $url, $args) = @_;
    return $self->request('POST', $url, $args);
}

sub put {
    my ($self, $url, $args) = @_;
    return $self->request('PUT', $url, $args);
}

sub delete {
    my ($self, $url, $args) = @_;
    return $self->request('DELETE', $url, $args);
}

sub head {
    my ($self, $url, $args) = @_;
    return $self->request('HEAD', $url, $args);
}

sub json {
    my ($self, $url, $args) = @_;
    
    my $method = $args->{method} || 'POST';

    $args->{data} = encode_json($args->{data});

    $args->{headers} = [] if ! $args->{headers};
    push @{$args->{headers}}, 'Content-Type' => 'application/json';

    return $self->request($method, $url, $args)->json;
}

1;

