package Business::BancaSella::Ric::File;

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

sub extract {
	my $self = shift;
	open(F,$self->{file}) || die "Unable to open " . $self->file;
	my @ric = <F>;
	my $ric = pop(@ric);
	die $self->file . " is empty" if (!defined $ric);
	chomp($ric);
	close(F);
	open(F,">$self->{file}") || die "Unable to open " . $self->file;
	print F @ric;
	close(F);
	return $ric;
}

1;
__END__