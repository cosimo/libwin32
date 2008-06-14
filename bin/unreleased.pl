# This script prints a list of all packages that have changes
# in trunk/ that are not in the latest tagged release.

use strict;
use warnings;

$|++;

my $svn = "http://libwin32.googlecode.com/svn";
sub svn { split /\n/, qx(svn $_[0] 2>nul) }

# Get a list of all subdirectories in trunk/
for my $pkg (grep m[/$], svn("ls $svn/trunk/")) {
    my @tag = svn("ls $svn/tags/$pkg");
    # Ignore directories that don't have any tags at all
    next unless @tag;

    # Get highest tag *number* (note: some old versions are not numbers)
    my $latest = (sort @tag)[-1];
    my @diff = svn("diff $svn/trunk/$pkg $svn/tags/$pkg$latest");
    next unless @diff;

    print "$pkg contains changes not in tags/$pkg$latest\n";
}
