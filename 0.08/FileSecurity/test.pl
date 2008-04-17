
BEGIN { $| = 1; print "1..1\n"; }
END {print "not ok 1\n" unless $loaded;}

use Win32::FileSecurity;

$loaded = 1;
print "ok 1\n";

print STDERR "##### This will work only when files are in NTFS #####\n";

foreach (<*>) {
    next unless -e $_;
    my(%hash) = ();
    if ( Win32::FileSecurity::Get( $_, \%hash ) ) {
        print STDERR "----- File: $_ -----\n";
	while( ($name, $mask) = each %hash ) {
	    print STDERR "$name:\n\t"; 
	    Win32::FileSecurity::EnumerateRights( $mask, \@happy ) ;
	    print STDERR join( "\n\t", @happy ), "\n";
	}
    } else {
	print( "Error #", int( $! ), ": $!" ) ;
    }
}


