#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More;
use App::EventStreamr::Process::DVswitch;
use App::EventStreamr::Status;
use Test::App::EventStreamr::ProcessTest;

# Added 'no_end_test' due to Double END Block issue
use Test::Warnings ':no_end_test';

my $status = App::EventStreamr::Status->new();

my $config = {
  run => 1, 
  control => {
    dvswitch => {
      run => 1,
    },
  },
  mixer => {
    port => 1234,
  },
};
bless $config, "App::EventStreamr::Config";

my $proc = App::EventStreamr::Process::DVswitch->new(
  config => $config,
  status => $status,
);

SKIP: {
  skip "DVswitch not installed", 5, unless ( -e "/usr/bin/dvswitch" );
  Test::App::EventStreamr::ProcessTest->new(
    process => $proc,
    config => $config,
    id => 'dvswitch',
  )->run_tests();
}

done_testing();
