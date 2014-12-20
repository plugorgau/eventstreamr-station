#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More tests => 1;
#TODO: Add 'no_end_test' due to Double END Block issue
use Test::Warnings ':no_end_test';

use Test::App::EventStreamr::Record;
use App::EventStreamr::Status;

my $command = 'ping 127.0.0.1';
my $id = 'ping';
my $status = App::EventStreamr::Status->new();

my $config = {
  run => 1, 
  control => {
    ping => {
      run => 1,
    },
  },
  record_path => '/tmp/$room/$data',
  room => 'eventstreamr',
};
bless $config, "App::EventStreamr::Config";

my $proc = Test::App::EventStreamr::Record->new(
  cmd => $command,
  id => $id,
  config => $config,
  status => $status,
);

$proc->run_stop();

is( (-d $status->{$id}{record_path}),1 ,"Record Path Created" );

$proc->stop();

