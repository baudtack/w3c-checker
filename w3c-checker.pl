#!/usr/bin/perl
use Modern::Perl;
use LWP::UserAgent;
use WebService::Validator::HTML::W3C;



my $ua = LWP::UserAgent->new;

$ua->timeout(10);
$ua->env_proxy;

my $response = $ua->get($ARGV[0]);

# Looking at the results...
if ($response->is_success) {
  my $v = WebService::Validator::HTML::W3C->new(detailed => 1);
  if($v->validate_markup($response->content)) {
    if($v->is_valid) {
      printf ("%s is valid\n", $ARGV[0]);
    } else {
       printf ("%s is not valid\n", $v->uri);
       foreach my $error ( @{$v->errors} ) {
         printf("%s at line %d\n", $error->msg,
                                   $error->line);
       }
    }
  } else {
    printf ("Failed to validate the website: %s\n", $v->validator_error);
  }
} else {
  # Error code, type of error, error message
  die $response->status_line;
}
