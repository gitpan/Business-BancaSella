package Business::BancaSella::Encode::Gateway;

push @ISA,'Business::BancaSella::Gateway';
use Business::BancaSella::Gateway;
use URI::Escape;
use HTML::Entities;

$VERSION = "0.09";

my $reqKeys = {	
				shopping					=> 1,
				amount						=> 1,
				id							=> 1,
				otp							=> 1,
				tid							=> 1
			};



sub Version { $VERSION; }
require 5.004;
use strict;
use warnings;

use Class::MethodMaker
	new_with_init 		=> 'new'
	,get_set				=> [qw/base_url/];
								

sub init {
	my $self = shift;
	$self->SUPER::hnew(@_);
	foreach (keys %{$reqKeys}) {
		die "You must declare '$_' in " . ref($self) . "::new" 
												if (!defined $self->$_);
	}
	$self->base_url('https://ecomm.sella.it/gestpay/pagam.asp');
}


sub uri {
	my $self 	= shift;
	my $uri 	= 'a=' . uri_escape($self->shopping) . '&b=' . 
					uri_escape($self->getB) . '&c=' . uri_escape($self->otp) . 
					'&d=' . uri_escape($self->id);
	return  	$self->base_url . '?' . $uri;
}

sub form {
	my $self	= shift;
	my $frmName = shift || '';
	my $ret 	= '<FORM NAME="' . $frmName . '" METHOD="POST" ACTION="' . 
					$self->base_url . '">' . "\n";
	$ret		.= '<input type="hidden" name="a" value="' . 
					encode_entities($self->shopping) .
					'">' . "\n";
	$ret		.= '<input type="hidden" name="b" value="' . 
					encode_entities($self->getB) .	'">' . "\n";
	$ret		.= '<input type="hidden" name="c" value="' . 
					encode_entities($self->otp) .
					'">' . "\n";
	$ret		.= '<input type="hidden" name="d" value="' . 
					encode_entities($self->id) .
					'">' . "\n";
	$ret		.= "</FORM>\n";
}

sub getB {
	my $self 	= shift;
	return int($self->amount * $self->tid);
}

1;
