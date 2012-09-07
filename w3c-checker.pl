#!/usr/bin/perl
# w3c-checker - a program to download a web page and run it through the w3c-validator
# Copyright (C) 2012 David Kerschner docgnome@docgno.me

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
