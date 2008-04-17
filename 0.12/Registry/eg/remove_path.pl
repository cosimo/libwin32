#
# An example that shows how to remove a part of a Registry entry.
# 
# Gurusamy Sarathy
# gsar@umich.edu
#

use Win32;
use Win32::Registry;
use strict;
use vars qw($HKEY_LOCAL_MACHINE);

die <<EOT unless @ARGV;
This tool removes a particular component from any ';' delimited string in
the registry.  As the boundary case, it will set a key to the empty string
value iff the value to be removed matches the single original component.

Usage:  $0 registry_setting keyname string_to_remove

Example:
    $0 "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" CodeBaseSearchPath CODEBASE

will disable remote download of ActiveX objects.  Do *NOT* run this example
if you don't fully understand what that means.
EOT

my $cfg = shift;
my $keyname = shift;
my $remove = shift;
my $regkey;
my %values;

$HKEY_LOCAL_MACHINE->Open($cfg, $regkey) or die "failed to open $cfg\n";

$regkey->GetValues(\%values) or die "failed to get values from $cfg\n";

if (exists $values{$keyname}) {
    my $curtype = $values{$keyname}[1];
    if ($curtype == REG_SZ) {
	my $cur = $values{$keyname}[2];
	print "$cfg\\$keyname is `$cur'\n";
	my @cur = split /;/, $cur;
	my @new = grep { $_ ne $remove } @cur;
	if (@new < @cur) {
	    $cur = join ';', @new;
	    $regkey->SetValueEx($keyname, NULL, REG_SZ, $cur)
		or die "Failed to modify $cfg\\$keyname.\n"
		      ."You probably have insufficient rights to do that.\n";
	    print "$cfg\\$keyname has been set to `$cur'\n";
	}
	else {
	    warn "$cfg\\$keyname doesn't have `$remove', leaving it as is\n";
	}
    }
    else {
	warn "$cfg\\$keyname is not a string (REG_SZ) type\n";
    }
}
else {
    warn "$cfg\\$keyname doesn't even exist\n";
}

$regkey->Close;
