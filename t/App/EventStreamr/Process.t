#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More;
use Test::App::EventStreamr::Process;
use App::EventStreamr::Status;
use Test::App::EventStreamr::ProcessTest;

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
};
bless $config, "App::EventStreamr::Config";

my $proc = Test::App::EventStreamr::Process->new(
  cmd => $command,
  id => $id,
  config => $config,
  status => $status,
);

Test::App::EventStreamr::ProcessTest->new(
  process => $proc,
  config => $config,
  id => $id,
)->run_tests();

done_testing();
