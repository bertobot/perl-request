package Response;

use strict;
use JSON;

use Class::MethodMaker [
    scalar  => [ qw( res ) ],
    new => [ qw(-init new ) ],
];

sub init {
    my ($self, $args) = @_;
    $self->res($args);
}

sub ok {
    my ($self) = @_;
    return $self->res->is_success || $self->res->code < 400;
}

sub json {
    my ($self) = @_;
    return decode_json($self->res->decoded_content);
}

sub body {
    my ($self) = @_;
    return $self->res->decoded_content;
}

sub toString {
    my ($self) = @_;
    return sprintf("%s %s %s", $self->res->code, $self->res->message, $self->body);
}

1;
