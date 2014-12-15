#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More tests => 4;
#TODO: Add 'no_end_test' due to Double END Block issue
use Test::Warnings ':no_end_test';
use Test::App::EventStreamr::ProcessControl;
use Proc::ProcessTable; # libproc-processtable-perl
use Data::Dumper;

my $command = 'ping 127.0.0.1';
my $id = 'ping';

my $proc = Test::App::EventStreamr::ProcessControl->new(
  command => $command,
  id => $id,
);

my $pt = Proc::ProcessTable->new;

subtest 'Instantiation' => sub {
  isa_ok($proc, "Test::App::EventStreamr::ProcessControl");
  can_ok($proc, qw(start running stop));
};

subtest 'method: start' => sub {
  $proc->start();

  my @procs = grep { $_->cmndline =~ /$command/ } @{ $pt->table };

  my $pid = $procs[0]->pid;
  my $cmdline = $procs[0]->cmndline;

  is($proc->pid, $pid, "Pids Match for $cmdline");
};


subtest 'method: stop' => sub {
  $proc->stop();

  my @procs = grep { $_->cmndline =~ /$command/ } @{ $pt->table };
  isnt(@procs, defined, "Process Stopped");
};

subtest 'method: running' => sub {
  $proc->pid;
  is($proc->running, 0, "Process not running");
  $proc->start();
  is($proc->running, 1, "Process running");
  $proc->stop();
  is($proc->pid, 0, "Pid Cleared");
}

__END__
