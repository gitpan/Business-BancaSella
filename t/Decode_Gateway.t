# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..2\n"; }
END {print "not ok 1\n" unless $loaded;}
use Business::BancaSella::Decode::Gateway;

my $query_string =<<EOF;
a=KO&b=12345&c=abcdef
EOF

$gpe	= new Business::BancaSella::Decode::Gateway('query_string' => $query_string);
print $gpe->result . "\n";
print $gpe->authcode . "\n";
print $gpe->id . "\n";
print $gpe->otp . "\n";

$loaded = 1;
print "ok 1\n";

$query_string =<<EOF;
a=987&b=12345&c=abcdef
EOF

$gpe	= new Business::BancaSella::Decode::Gateway('query_string' => $query_string);
print $gpe->result . "\n";
print $gpe->authcode . "\n";
print $gpe->id . "\n";
print $gpe->otp . "\n";

print "ok 2\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

