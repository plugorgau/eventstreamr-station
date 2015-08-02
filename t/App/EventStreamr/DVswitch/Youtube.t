#!/usr/bin/env perl -w

use strict;
use lib "t/lib";
use Test::More;
use File::Temp;
use App::EventStreamr::DVswitch::Youtube;
use App::EventStreamr::Status;
use App::EventStreamr::Config;

# Added 'no_end_test' due to Double END Block issue
use Test::Warnings ':no_end_test';

my $status = App::EventStreamr::Status->new();
my $tmp_config = File::Temp->new( UNLINK => 0, SUFFIX => '.json' );

open(my $fh, '>', $tmp_config );
print $fh '{"run" : "1", "control" : { "dvswitch" : { "run" : "1" } }, "mixer" : { "host" : "127.0.0.1", "port" : "1234" }, "youtube" : { "preset" : "medium", "fps" : "25", "bitrate" : "2500k", "url" : "rtmp://a.rtmp.youtube.com/live2", "key" : "streaming.key" }}';
close $fh;

my $config = App::EventStreamr::Config->new(
  config_file => "$tmp_config",
);

my $proc = App::EventStreamr::DVswitch::Youtube->new(
  config => $config,
  status => $status,
);

is(
  $proc->cmd, 
  'dvsink-command -h 127.0.0.1 -p 1234 -- '.$proc->avlib.' -i - -deinterlace -vcodec libx264 -pix_fmt yuv420p -vf scale=-1:480 -preset medium -r 25 -g 50 -b:v 2500k -acodec libmp3lame -ar 44100 -threads 6 -qscale 3 -b:a 256000 -bufsize 512k -f flv "rtmp://a.rtmp.youtube.com/live2/streaming.key"', 
  "Stream Command built"
);

like($proc->cmd, $proc->cmd_regex, "Command Regex Correct" );

unlink($tmp_config);

done_testing();
