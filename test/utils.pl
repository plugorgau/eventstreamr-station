#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib";

# EventStremr Modules
use App::EventStreamr::Utils;
my $utils = App::EventStreamr::Utils->new();

# Dev
use Data::Dumper;

$utils->test();
print Dumper($utils);
