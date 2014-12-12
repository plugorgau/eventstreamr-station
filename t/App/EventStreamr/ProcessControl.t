#!/usr/bin/perl -w

use strict;
use Test::More;
use Test::Warnings;
use Data::Dumper;

my $proc = Test::EventStreamr::ProcessControl->new();

$proc->start();

print Dumper($proc);

$proc->stop();

done_testing();

package Test::EventStreamr::ProcessControl;
use Method::Signatures;
use Moo;
use namespace::clean;

has 'status' => ( is => 'rw' );
has 'config' => ( is => 'rw' );
has 'command' => ( is => 'ro', default  => sub { "ping 127.0.0.1" });
has 'id' => ( is => 'ro', default  => sub { "ping" });

with('App::EventStreamr::ProcessControl');

1;
