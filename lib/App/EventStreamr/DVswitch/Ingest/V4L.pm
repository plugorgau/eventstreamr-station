package App::EventStreamr::DVswitch::Ingest::V4L;
use Method::Signatures;
use Moo;
use namespace::clean;

# ABSTRACT: A DVswitch V4l Process

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

This Provides a V4L ingest process.

=head1 DESCRIPTION

This largely extends L<App::EventStreamr::Process>, provides
default cmds that can be overridden in the configuration.

=cut

extends 'App::EventStreamr::Process';

has 'cmd'         => ( is => 'ro', lazy => 1, builder => 1 );
has 'cmd_regex'   => ( is => 'ro', lazy => 1, builder => 1 );
has 'id'          => ( is => 'ro', required => 1 );
has 'device'      => ( is => 'ro', required => 1 );
has 'type'        => ( is => 'ro', default => sub { 'ingest' } );

method _build_cmd() {
  my $command;
  if ( -e '/usr/bin/avconv' ) {
    $command = $self->{config}{commands}{file} ? $self->{config}{commands}{file} : 'avconv -f video4linux2 -s vga -r 25 -i $device -target pal-dv - | dvsource-file /dev/stdin -h $host -p $port';
  } else {
    $command = $self->{config}{commands}{file} ? $self->{config}{commands}{file} : 'ffmpeg -f video4linux2 -s vga -r 25 -i $device -target pal-dv - | dvsource-file /dev/stdin -h $host -p $port';
  }
  
  my %cmd_vars =  (
    device  => $self->device,
    host    => $self->{config}{mixer}{host},
    port    => $self->{config}{mixer}{port},
  );

  $command =~ s/\$(\w+)/$cmd_vars{$1}/g;
  return $command;
}

method _build_cmd_regex() {
  return qr:^[ffmpeg|avconv].+/dev/$self->{id}.*:;
}

with('App::EventStreamr::DVswitch::Roles::MixerWait');

1;
