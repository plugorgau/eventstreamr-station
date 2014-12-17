#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More tests => 5;
use Test::App::EventStreamr::Process;
use App::EventStreamr::Status;

#TODO: Add 'no_end_test' due to Double END Block issue
use Test::Warnings ':no_end_test';

my $command = 'ping 127.0.0.1';
my $id = 'ping';
my $status = App::EventStreamr::Status->new();

# TODO: Instantiate proper object once config is completed
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

subtest 'Instantiation' => sub {
  can_ok($proc, qw(start running stop run_stop));
};

subtest 'Run Stop Starting' => sub {
  $proc->run_stop();

  is($proc->running, 1, "Process was Started");
};

$config->{control}{ping}{run} = 2;

subtest 'Run Stop Process Restarting' => sub {
  is($proc->_restart, 1, "Process Expected to Restart");
  $proc->run_stop();

  is($proc->running, 0, "Process was Stopped");
  
  $proc->run_stop();
  $proc->run_stop();

  is($proc->running, 1, "Process was Started");
};

$config->{run} = 2;

subtest 'Run Stop System Restarting' => sub {
  is($proc->_restart, 1, "Process Expected to Restart");
  $proc->run_stop();

  is($proc->running, 0, "Process was Stopped");
  
  $proc->run_stop();
  
  $config->{run} = 1;
  
  $proc->run_stop();

  is($proc->running, 1, "Process was Started");
};

$config->{control}{ping}{run} = 0;

subtest 'Run Stop Stopping' => sub {
  $proc->run_stop();

  is($proc->running, 0, "Process was Stopped");
};

