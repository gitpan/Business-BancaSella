package Business::BancaSella::Encode::Gestpay;

push @ISA,'Business::BancaSella::Gestpay';
use Business::BancaSella::Gestpay;
use URI::Escape;
use HTML::Entities;

$VERSION = "0.09";

my $reqKeys = {	
				amount						=> 'PAY1_AMOUNT',
				id							=> 'PAY1_SHOPTRANSACTIONID',
				otp							=> 'PAY1_OTP',
			};

my $bKeys = {
				currency					=> 'PAY1_UICCODE',
				amount						=> 'PAY1_AMOUNT',
				id							=> 'PAY1_SHOPTRANSACTIONID',
				otp							=> 'PAY1_OTP',
				cardnumber 					=> 'PAY1_CARDNUMBER',
				expmonth 					=> 'PAY1_EXPMONTH',
				expyear  					=> 'PAY1_EXPYEAR',
				name  						=> 'PAY1_CHNAME',
				mail	 					=> 'PAY1_CHMAIL',
				language					=> 'PAY1_IDLANGUAGE',
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
	$self->currency('eur') if (!defined $self->currency);
	foreach (keys %{$reqKeys},'shopping') {
		die "You must declare '$_' in " . ref($self) . "::new" 
												if (!defined $self->$_);
	}
	$self->base_url('https://ecomm.sella.it/gestpay/pagam.asp');
}


sub uri {
	my $self 	= shift;
	my $uri 	= 'a=' . $self->shopping . '&b=' . $self->getB;
	$uri		= uri_escape($uri);
	return  	$self->base_url . '?' . $uri;
}

sub form {
	my $self	= shift;
	my $frmName = shift || '';
	my $ret 	= '<FORM NAME="' . $frmName . '" METHOD="POST" ACTION="' . 
					$self->base_url . '">' . "\n";
	$ret		.= '<input type="hidden" name="a" value="' . $self->shopping .
					'">' . "\n";
	$ret		.= '<input type="hidden" name="b" value="' . 
					encode_entities($self->getB) .	'">' . "\n";
	$ret		.= "</FORM>\n";
}

sub getB {
	my $self 	= shift;
	my @b;
	foreach (keys(%{$bKeys})) {
		my $addValue;
		if (exists($self->{$_})) {
			$addValue = $self->$_;
			$addValue = valuta_encode($addValue) if ($_ eq 'currency');
			$addValue = lingua_encode($addValue) if ($_ eq 'language');
			push @b,$bKeys->{$_} . '=' . $addValue;
		}
	}
	return join('*P1*',@b);
}

sub valuta_encode {
	my $valuta	= lc(shift);
	my %vd		= (
					'eur'	=> 242,
					'itl'	=> 18
				);
	die "Unable to encode you currency '$valuta'" if (!exists $vd{$valuta});
	return $vd{$valuta};
}

sub lingua_encode {
	my $lingua	= lc(shift);
	my %ld		= (
					'italian'		=> 1,
					'english'		=> 2,
					'spanish'		=> 3,
					'french'		=> 4
				);
	return $ld{'english'} if (!exists $ld{$lingua});
	return $ld{$lingua};
}


1;
