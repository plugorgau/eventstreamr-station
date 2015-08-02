package App::EventStreamr::DVswitch::Ingest::ALSA;
use Method::Signatures;
use Moo;
use namespace::clean;

# ABSTRACT: A DVswitch V4l Process

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

This Provides an ALSA ingest process.

=head1 DESCRIPTION

This largely extends L<App::EventStreamr::Process>, provides
default cmds that can be overridden in the configuration.

=cut

extends 'App::EventStreamr::Process';

has 'cmd'         => ( is => 'ro', lazy => 1, builder => 1 );
has 'id'          => ( is => 'ro', required => 1 );
has 'device'      => ( is => 'rw', required => 1 );
has 'card'        => ( is => 'rw', lazy => 1, builder => 1, clearer => 'clear_card' );
has 'type'        => ( is => 'ro', default => sub { 'ingest' } );

method _build_card() {
  $self->config->update_devices();
  return $self->config->{available_devices}{alsa}{$self->id}{alsa};
}

method _build_cmd() {
  my $command = $self->{config}{commands}{alsa} ? $self->{config}{commands}{alsa} : 'dvsource-alsa -h $host -p $port hw:$device';
  
  my %cmd_vars =  (
    device  => $self->card,
    host    => $self->{config}{mixer}{host},
    port    => $self->{config}{mixer}{port},
  );

  $command =~ s/\$(\w+)/$cmd_vars{$1}/g;
  return $command;
}

around [qw(stop start run_stop)] => sub {
  my $orig = shift;
  my $self = shift;
  
  # We don't want to hand over an unitialised variable
  # If the alsa device isn't present.
  if ( $self->card ) {
    $orig->($self);
  } else {
    $self->clear_card;
    return;
  }
};

with('App::EventStreamr::DVswitch::Roles::MixerWait');

1;
