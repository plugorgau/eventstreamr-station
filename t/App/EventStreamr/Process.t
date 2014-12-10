#!/usr/bin/perl -w

use strict;
use Test::More;
use Test::Warnings;


done_testing();

package App::EventStreamr::Test;
use Moo;
use Method::Signatures;

has 'state' => ( is => 'rw' );
has 'config' => ( is => 'rw' );
has 'command' => ( is => 'ro', default  => sub { "ping 127.0.0.1" });
has 'id' => ( is => 'ro', default  => sub { "ping" });

with('App::EventStreamr::Process');


1;
