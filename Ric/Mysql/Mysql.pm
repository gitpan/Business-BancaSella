package Business::BancaSella::Ric::Mysql;

$VERSION = "0.09";
sub Version { $VERSION; }
require 5.004;
use strict;

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
	die "You must declare tableName in " . ref($self) . "::new as table where are stored Ric password" 
												if (!defined $self->tableName);
	die "You must declare fieldName in " . ref($self) . "::new as field where are stored Ric password"  
												if (!defined $self->fieldName);
}

sub extract {
	my $self 	= shift;
	# get first Ric password
	my $sql 	= 'select ' . $self->fieldName . ' from ' . $self->tableName .  
					' limit 1';
	my @ret		= $self->dbh->selectrow_array($sql) or 
					die "Unable to execute $sql";
	if (@ret) {
		# remove Ric password from Ric Table.
		$sql 	= 'delete from ' . $self->tableName . ' where ' . 
					$self->fieldName . " = '" . $ret[0] . "'";
		$self->dbh->do($sql) or die "Unable to execute $sql";
		return $ret[0];
	} else {
		return undef;
	}
}

1;
__END__
