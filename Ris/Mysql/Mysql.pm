package Business::BancaSella::Ris::Mysql;

$VERSION = "0.07";
sub Version { $VERSION; }
require 5.004;
use strict;
#use warnings;

use Class::MethodMaker
	new_with_init	=> 'new',
	get_set			=> [ qw/dbh tableName fieldName/];



# Preloaded methods go here.

sub init {
	my ($self,%options) = @_;
	if (exists($options{dbh})) { $self->{dbh} = $options{dbh}};
	if (exists($options{tableName})) { $self->{tableName} = $options{tableName}};
	if (exists($options{fieldName})) { $self->{fieldName} = $options{fieldName}};
	die "You must declare dbh in " . ref($self) . "::new as a DBI istead of " . ref($self->dbh)
												if (!defined $self->dbh
													|| ref($self->dbh) ne 'DBI::db');
	die "You must declare tableName in " . ref($self) . "::new as table where are stored Ris password" 
												if (!defined $self->tableName);
	die "You must declare fieldName in " . ref($self) . "::new as field where are stored Ris password"  
												if (!defined $self->fieldName);
}

sub check {
	my $self = shift;
	my $ris = shift;
	# get Ris password
	my $sql 	= 'select ' . $self->fieldName . ' from ' . $self->tableName .  
					' where ' . $self->fieldName . "='" . $ris . "'";
	my @ret		= $self->dbh->selectrow_array($sql) or 
					die "Unable to execute $sql";
	if (@ret) {
		return $ret[0] eq $ris;
	} else {
		return 0;
	}
}

sub remove {
	my $self = shift;
	my $ris = shift;
	# remove Ris password from Ris Table.
	my $sql 	= 'delete from ' . $self->tableName . ' where ' . 
				$self->fieldName . " = '" . $ris . "'";
	$self->dbh->do($sql) or die "Unable to execute $sql";
}


1;
__END__
