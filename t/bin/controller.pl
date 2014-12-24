#!/usr/bin/env perl
use strict;
use Dancer;

set serializer => 'JSON';

post '/api/station' => sub {
  return {
    settings => {
      nickname => "controller_test",
      room => "control_room",
      record_path => "/tmp/control",
      run => "1",
    },
  };
};

post '/api/station/:macaddress' => sub {
  status 201;
};

dance;

