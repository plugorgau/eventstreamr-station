package App::EventStreamr;
use v5.010;
use strict;
use warnings;
use Method::Signatures;
use experimental 'switch';
use Module::Load;
use App::EventStreamr::Internal::API;
use Moo;
use namespace::clean;

# ABSTRACT: Conference Mixing/Streaming Orchestrator

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

  use App::EventStreamr;

  my $eventstreamr = App::EventStreamr->new();

=head1 DESCRIPTION

Born due to the instability of DVswitch, EventStreamr attempts to 
remove the time consuming process that is connecting up all the 
devices and ensuring they stay connected.

First you should configure the system, although if using in 
conjunction with the frontend it will provide a number of useful
defaults.

  eventstreamr --configure

Once configured you can add 'eventstreamr' as a startup process
or launch from the cli.

  eventstreamr

=cut

use App::EventStreamr::Config;

has 'config' => (
  is => 'rw',
  isa => sub { "App::EventStreamr::Config" },
  lazy => 1,
  builder => 1,
  handles => [ qw( configure write_config ) ],
);

method _build_config() {
  return App::EventStreamr::Config->new();
}

use App::EventStreamr::Status;

has 'status' => (
  is => 'rw',
  isa => sub { "App::EventStreamr::Status" },
  lazy => 1,
  builder => 1,
  handles => [ qw( starting stopping restarting set_state threshold post_status ) ],
);

method _build_status() {
  return App::EventStreamr::Status->new(
    config => $self->config,
  );
}

has '_processes'    => ( is => 'ro', default => sub { { } } );

method _load_package($type,$package) {
  my $pkg = "App::EventStreamr::".$type."::".$package;
  load $pkg;
  $self->_processes->{$package} = $pkg->new(
    config => $self->config,
    status => $self->status,
  );
}

method start() {
  # Load API
  $self->_load_package("Internal","API");
  $self->_processes->{API}->run_stop();
  $self->config->post_config();

  foreach my $role (@{$self->config->roles}) {
    $self->_load_package($self->config->backend,ucfirst($role));
  }
}

method run() {
  $self->start();
  while (1 == 1) {
    foreach my $key (keys %{$self->_processes}) {
      $self->_processes->{$key}->run_stop();
    }
    sleep 1;
    print "Running!!\n";
  }
}

method stop() {

}

=head1 ACKNOWLEDGEMENTS

Jason Nicholls for finding all the bugs and writing the status display.

Luke John for all the help with the frontend code. 

=head1 BUGS/Feature Requests

Please submit any bugs, feature requests to
L<https://github.com/plugorgau/eventstreamr-station/issues> .

Contributions are more than welcome! I am aware that Dist::Zilla 
comes with quite a dependency chain, so feel free to submit pull 
request with code + explanation of what you are trying to achieve 
and I will test and likely implement them.

=cut

1;