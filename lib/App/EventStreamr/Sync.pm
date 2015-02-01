package App::EventStreamr::Sync;
use Method::Signatures;
use POSIX 'strftime';
use Moo;
use namespace::clean;

# ABSTRACT: An EventStreamr Sync Process

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

This manages the internal EventStreamr API

=head1 DESCRIPTION

This largely extends L<App::EventStreamr::Process>, provides
default cmds that can be overridden in the configuration.

=cut

extends 'App::EventStreamr::Process';

has 'cmd'         => ( is => 'ro', lazy => 1, builder => 1 );
has 'id'          => ( is => 'ro', default => sub { 'sync' } );
has 'type'        => ( is => 'ro', default => sub { 'sync' } );

# TODO: This is horrible, we handle date stuff in a terrible way.
method _build_cmd() {
  $self->{status}{$self->{id}}{date} = strftime "%Y-%m-%d", localtime;

  $self->{status}{$self->{id}}{record_path} = $self->{config}{record_path};

  my %cmd_vars =  (
    room    => $self->{config}{room}, 
    date    => $self->{status}{$self->{id}}{date},
  );

  $self->{status}{$self->{id}}{record_path} =~ s/\$(\w+)/$cmd_vars{$1}/g;

  # TODO: ... yucky. Improve this
  return "eventstreamr-sync.sh $self->{status}{$self->{id}}{record_path} $self->{config}{sync}{host} $self->{config}{sync}{path} $self->{config}{room} $self->{status}{$self->{id}}{date}";
}

1;