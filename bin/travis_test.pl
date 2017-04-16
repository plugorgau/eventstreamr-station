#!/usr/bin/env perl

use strict;
use warnings;

use Proc::Daemon; # libproc-daemon-perl
use Proc::ProcessTable; # libproc-processtable-perl
use Data::Dumper;

my %proc_opts = ( exec_command => "ping 127.0.0.1" );

# Proc::Daemon will exit parent when started  in Void
my $state = Proc::Daemon::Init( \%proc_opts );
print Dumper($state);

sleep 1;

my $pt = Proc::ProcessTable->new;
my @procs = grep { $_->cmndline =~ /ping 127.0.0.1/ } @{ $pt->table };

print Dumper(@procs);

my $pid;

if (@procs) {
  print "Process found with pid=".$procs[0]->pid."\n";
  $pid = $procs[0]->pid;
} else {
  $pid = 0;
}

sleep 5;

my $running = kill 0, $pid;

print "State of process is $running\n";
  
kill 9, $pid;

sleep 1;

$running = kill 0, $pid;

print "State of process is $running\n";
