package Business::BancaSella::Decode::Gestpay;

push @ISA,'Business::BancaSella::Gestpay';
use Business::BancaSella::Gestpay;
use URI;


$VERSION = "0.07";
sub Version { $VERSION; }
require 5.004;
use strict;

my $bKeys = {
				currency					=> 'PAY1_UICCODE',
				amount						=> 'PAY1_AMOUNT',
				id							=> 'PAY1_SHOPTRANSACTIONID',
				otp							=> 'PAY1_OTP',
				language					=> 'PAY1_IDLANGUAGE',
				result 						=> 'PAY1_TRANSACTIONRESULT',
				authcode 					=> 'PAY1_AUTHORIZATIONCODE',
				bankid 						=> 'PAY1_BANKTRANSACTIONID',
				errcode 					=> 'PAY1_ERRORCODE',
				errstr						=> 'PAY1_ERRORDESCRIPTION'
			};

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
	return $self->SUPER::result eq 'OK';
}


sub _split_uri {
	my $self = shift;
	my %lbKeys = %{$bKeys};
	my $qs	= '?' . $self->query_string;
	my %qs = URI->new($qs)->query_form;
	die "Malformed uri definition: " . $self->uri 
							if (!(exists $qs{a} && exists $qs{b}));
	$self->shopping($qs{a});
	my @b				= split(/\*P1\*/,$qs{b});
	my %b;
	foreach (@b) {
		my ($key,$value) 	= split(/=/,$_);
		$b{$key}			= $value;
	}
	foreach (keys %lbKeys) {
		if (exists $b{$lbKeys{$_}}) {
			$self->$_($b{$lbKeys{$_}});
		}
	}
	
}





# Preloaded methods go here.

1;
__END__
