package Business::BancaSella::Encode;

$VERSION = "0.09";
sub Version { $VERSION; }

require 5.004;
use strict;
use warnings;

use Business::BancaSella::Encode::Gestpay;
use Business::BancaSella::Encode::Gateway;
use Class::MethodMaker
	new_with_init 		=> 'new',
	get_set				=> [qw/type/];
								

sub init {
	my $self = shift;
	my (%options) = @_;
	if (defined $options{type}) {
		$self->type(lc($options{type}));
		delete $options{type};
	} else {
		die "You must declare 'type' in " . ref($self) . "::new";
	}
												
	if ($self->type eq 'gestpay') {
		no strict 'vars';
		unshift @ISA,'Business::BancaSella::Encode::Gestpay';
	} elsif ($self->type eq 'gateway') {
		no strict 'vars';
		unshift @ISA,'Business::BancaSella::Encode::Gateway';
	} else {
		die "Unsupported type " . $self->type . "in " . ref($self) . "::new";
	}
	$self->SUPER::init(@_);
}

# Preloaded methods go here.

1;
__END__
