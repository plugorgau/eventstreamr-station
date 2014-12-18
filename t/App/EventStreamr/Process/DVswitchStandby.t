#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More;
use App::EventStreamr::Process::DVswitch;
use App::EventStreamr::Process::DVswitchStandby;
use App::EventStreamr::Status;
use Test::App::EventStreamr::ProcessTest;

# Added 'no_end_test' due to Double END Block issue
use Test::Warnings ':no_end_test';

my $status = App::EventStreamr::Status->new();

my $config = {
  run => 1, 
  control => {
    dvfile => {
      run => 1,
    },
  },
  mixer => {
    host => '127.0.0.1',
    port => 1234,
    loop => 't/data/Test.dv',
  },
};
bless $config, "App::EventStreamr::Config";

my $dvswitch = App::EventStreamr::Process::DVswitch->new(
  config => $config,
  status => $status,
);

my $proc = App::EventStreamr::Process::DVswitchStandby->new(
  config => $config,
  status => $status,
);


SKIP: {
  skip "DVswitch||DVsource not installed", 5, unless ( -e "/usr/bin/dvswitch" && -e "/usr/bin/dvsource-file" );
  
  $dvswitch->start();

  Test::App::EventStreamr::ProcessTest->new(
    process => $proc,
    config => $config,
    id => 'dvfile',
  )->run_tests();

  $dvswitch->stop();
}

done_testing();
