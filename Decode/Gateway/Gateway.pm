package Business::BancaSella::Decode::Gateway;

push @ISA,'Business::BancaSella::Gateway';
use Business::BancaSella::Gateway;
use URI;


$VERSION = "0.09";
sub Version { $VERSION; }
require 5.004;
use strict;

use Class::MethodMaker
	new_with_init 		=> 'new'
	,get_set				=> [qw/base_url query_string/];
								

sub init {
	my ($self,%options) = @_;
	if (defined $options{'query_string'}) {
		$self->query_string($options{'query_string'});
	} else {
		die "You must declare 'query_string' in " . ref($self) . "::new";
	}
	$self->_split_uri;
}


sub result {
	my $self = shift;
	if (@_) { $self->SUPER::result(shift) };
	return $self->SUPER::result ne 'KO';
}


sub _split_uri {
	my $self = shift;
	my $qs	= '?' . $self->query_string;
	my %qs = URI->new($qs)->query_form;
	die "Malformed uri definition: " . $self->uri 
							if (!(exists $qs{a} && exists $qs{b}));
	$self->result($qs{a});
	$self->id($qs{b});
	$self->otp($qs{c});
	if ($self->result ne 'KO') {
		$self->authcode($qs{a});
	}
	
}





# Preloaded methods go here.

1;
__END__
