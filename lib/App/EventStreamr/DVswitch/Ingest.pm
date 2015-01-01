package App::EventStreamr::DVswitch::Ingest;
use Method::Signatures;
use Moo;
use namespace::clean;

# ABSTRACT: Ingest

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

Manage Ingest processes.

=head1 DESCRIPTION

Manage all the configured devices designated to be 
running as ingest roles.

=cut

extends 'App::EventStreamr::Ingest';

has 'backend' => ( is => 'ro', default => sub { 'DVswitch' } );

1;