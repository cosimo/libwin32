# Create tag for specified package.
# Assumes that all changes have been checked in and that
# META.yml is up-to-date.
# Should be run after `svn up` so that all files in the
# tag are copied from the same revision number.

use strict;
use warnings;

use FindBin qw($Bin);
use File::Spec::Functions qw(canonpath);
use YAML::XS qw(LoadFile);

my $pkg = shift;

my $trunk = canonpath("$Bin/..");
my $tags = canonpath("$trunk/../tags");

my $meta = LoadFile("$trunk/$pkg/META.yml") or die;
my $cmd = "svn cp $trunk/$pkg $tags/$pkg/$meta->{version}\n";

print "$cmd\n";
system($cmd);
