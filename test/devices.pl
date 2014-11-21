#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib";

# EventStremr Modules
use App::EventStreamr::Devices;
my $devices = App::EventStreamr::Devices->new();

# Dev
use Data::Dumper;

$devices->all();
print Dumper($devices);
