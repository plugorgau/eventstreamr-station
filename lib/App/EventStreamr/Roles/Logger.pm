package App::EventStreamr::Roles::Logger;

use Log::Log4perl;
use Method::Signatures;
use Moo::Role;

# From here -> http://stackoverflow.com/questions/3018528/making-self-logging-modules-with-loglog4perl

my @methods = qw(
  log trace debug info warn error fatal
  is_trace is_debug is_info is_warn is_error is_fatal
  logexit logwarn error_warn logdie error_die
  logcarp logcluck logcroak logconfess
);

has _logger => (
  is => 'ro',
  isa => sub { 'Log::Log4perl::Logger' },
  lazy => 1,
  builder => 1,
  handles => \@methods,
);

around $_ => sub {
  my $orig = shift;
  my $this = shift;

  # one level for this method itself
  # two levels for Class:;MOP::Method::Wrapped (the "around" wrapper)
  # one level for Moose::Meta::Method::Delegation (the "handles" wrapper)
  local $Log::Log4perl::caller_depth;
  $Log::Log4perl::caller_depth += 4;

  my $return = $this->$orig(@_);

  $Log::Log4perl::caller_depth -= 4;
  return $return;

} foreach @methods;

method _build__logger() {
  my $this = shift;

  my $loggerName = ref($this);
  Log::Log4perl->easy_init() if not Log::Log4perl::initialized();
  return Log::Log4perl->get_logger($loggerName)
}

1;
