package Business::BancaSella::Ris::File;


$VERSION = "0.09";
sub Version { $VERSION; }
require 5.004;
use strict;
use warnings;

use Class::MethodMaker
	new_with_init	=> 'new',
	get_set			=> [ qw/file/];



# Preloaded methods go here.

sub init {
	my ($self,%options) = @_;
	if (exists($options{file})) { $self->{file} = $options{file}};
	die "You must declare file in " . ref($self) . "::new" 
												if (!defined $self->file);
}

sub check {
	my $self = shift;
	my $ris = shift;
	open(F,$self->{file}) || die "Unable to open " . $self->file;
	my @hris =  <F>;
	close(F);
	chomp(@hris);
	my %hris = map { $_ => 1} @hris;
	return exists($hris{$ris});
}

sub remove {
	my $self = shift;
	my $ris = shift;
	open(F,$self->{file}) || die "Unable to open " . $self->file;
	my @hris =  <F>;
	close(F);
	chomp(@hris);
	my %hris = map { $_ => 1} @hris;
	if (exists($hris{$ris})) {
		delete $hris{$ris};
	} else {
		die "Unable to find $ris in " . $self->file;
	}
	@hris = map {$_ . "\n"} keys(%hris);
	open(F,">$self->{file}") || die "Unable to open " . $self->file;
	print F @hris;
	close(F)
}


1;
__END__
