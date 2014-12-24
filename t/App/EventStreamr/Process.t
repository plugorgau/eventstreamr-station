#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More tests => 7;
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
  write_config => sub { },
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

subtest 'State Changes' => sub {
  is($status->set_state($proc->running,$proc->{id}), 0, "State not changed");
  $proc->start();
  is($status->set_state($proc->running,$proc->{id}), 1, "State changed");
  $proc->stop();
};

$proc = Test::App::EventStreamr::Process->new(
  cmd => 'ls -lah',
  id => 'ls',
  config => $config,
  status => $status,
);

my $count = 0;
while (! $status->threshold('ls') && $count < 20) {
  $proc->run_stop;
  $count++;
  sleep 1;
}

is($count < 20, 1, "Threshold reached correctly in $count iterations");
