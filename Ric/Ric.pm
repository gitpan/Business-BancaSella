package Business::BancaSella::Ric;

$VERSION = "0.09";
sub Version { $VERSION; }

require 5.004;
use strict;
use warnings;

use Business::BancaSella::Ric::File;
use Business::BancaSella::Ric::Mysql;
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
												
	if ($self->type eq 'file') {
		no strict 'vars';
		unshift @ISA,'Business::BancaSella::Ric::File';
	} elsif ($self->type eq 'mysql') {
		no strict 'vars';
		unshift @ISA,'Business::BancaSella::Ric::Mysql';
	} else {
		die "Unsupported type " . $self->type . "in " . ref($self) . "::new";
	}
	$self->SUPER::init(@_);
}


1;
__END__
