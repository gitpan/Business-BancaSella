package Business::BancaSella::Gateway;

$VERSION = "0.09";
sub Version { $VERSION; }
require 5.004;
use strict;
use warnings;

use Class::MethodMaker
	new				=> 'new',
	get_set			=> [ qw/shopping otp amount id tid
							uri form
							result authcode
							/],
	new_hash_init	=> 'hnew';

	

# Preloaded methods go here.

1;
__END__
