package Business::BancaSella::Gestpay;

$VERSION = "0.09";
sub Version { $VERSION; }
require 5.004;
use strict;
use warnings;

use Class::MethodMaker
	new				=> 'new',
	get_set			=> [ qw/shopping otp amount id currency language 
							cardnumber expmonth expyear name mail
							uri form
							result authcode bankid errcode errstr
							/],
	new_hash_init	=> 'hnew';

	

# Preloaded methods go here.

1;
__END__
