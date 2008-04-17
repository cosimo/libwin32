package Win32::FileSecurity;

#
# FileSecurity.pm
# By Monte Mitzelfelt, monte@conchas.nm.org
# Larry Wall's Artistic License applies to all related Perl
#  and C code for this module
# Thanks to the guys at ActiveWare!
# ver 0.65 ALPHA 1997.02.25
#

require Exporter;
require DynaLoader;
use Carp ;

$VERSION = '1.01';

croak "The Win32::FileSecurity module works only on Windows NT" if (!Win32::IsWinNT()) ;

@ISA= qw( Exporter DynaLoader );
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

require Exporter ;
require DynaLoader ;

@ISA = qw(Exporter DynaLoader) ;
@EXPORT_OK = qw( Get Set EnumerateRights MakeMask ) ;

sub AUTOLOAD
{
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    local($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    #reset $! to zero to reset any current errors.
    $!=0;
    $val = constant($constname);
    if($! != 0)
	{
		if($! =~ /Invalid/)
		{
			$AutoLoader::AUTOLOAD = $AUTOLOAD;
			goto &AutoLoader::AUTOLOAD;
		}
		else
		{
			($pack,$file,$line) = caller;
			die "Your vendor has not defined Win32::FileSecurity macro $constname, used in $file at line $line.";
		}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap Win32::FileSecurity;

# Preloaded methods go here.

# Autoload methods go after __END__, and are processed by the autosplit program.

1;

__END__

=head1 NAME

Win32::FileSecurity - manage FileSecurity Discretionary Access Control Lists in perl

=head1 SYNOPSIS

	use Win32::FileSecurity;

=head1 DESCRIPTION

This module offers control over the administration of system FileSecurity DACLs.  
You may want to use Get and EnumerateRights to get an idea of what mask values
correspond to what rights as viewed from File Manager.

=head1 CONSTANTS

  DELETE, READ_CONTROL, WRITE_DAC, WRITE_OWNER,
  SYNCHRONIZE, STANDARD_RIGHTS_REQUIRED, 
  STANDARD_RIGHTS_READ, STANDARD_RIGHTS_WRITE,
  STANDARD_RIGHTS_EXECUTE, STANDARD_RIGHTS_ALL,
  SPECIFIC_RIGHTS_ALL, ACCESS_SYSTEM_SECURITY, 
  MAXIMUM_ALLOWED, GENERIC_READ, GENERIC_WRITE,
  GENERIC_EXECUTE, GENERIC_ALL, F, FULL, R, READ,
  C, CHANGE

=head1 FUNCTIONS

=head2 NOTE:

All of the functions return FALSE (0) if they fail, unless otherwise noted.  Errors returned
via $! containing both Win32 GetLastError() and a text message indicating Win32 function that 
failed.

=over 10

=item constant( $name, $set )
	Stores the value of named constant $name into $set.
	Alternatively, $set = Win32::FileSecurity::NAME_OF_CONSTANT() ;

=item Get( $filename, \%permisshash )
	Gets the DACLs of a file or directory

=item Set( $filename, \%permisshash )
	Sets the DACL for a file or directory

=item EnumerateRights( $mask, \@rightslist )
	Turns the bitmask in $mask into a list of strings in @rightslist

=item MakeMask( qw( DELETE READ_CONTROL ) )
	Takes a list of strings representing constants and returns a bitmasked integer value.

=back

=head2 %permisshash

Entries take the form $permisshash{USERNAME} = $mask ;

=head1 EXAMPLE1

# Gets the rights for all files listed on the command line.
use Win32::FileSecurity ;

foreach( @ARGV ) {
	next unless -e $_ ;
	
	if ( Win32::FileSecurity::Get( $_, \%hash ) ) {
		while( ($name, $mask) = each %hash ) {
			print "$name:\n\t"; 
			Win32::FileSecurity::EnumerateRights( $mask, \@happy ) ;
			print join( "\n\t", @happy ), "\n";
		}
	} else {
		print( "Error #", int( $! ), ": $!" ) ;
	}
}

=head1 EXAMPLE2

# Gets existing DACL and modifies Administrator rights
use Win32::FileSecurity ;

# These masks show up as Full Control in File Manager
$file = Win32::FileSecurity::MakeMask( qw( FULL ) );

$dir = Win32::FileSecurity::MakeMask( qw(
	FULL
    GENERIC_ALL
) );


foreach( @ARGV ) {
	s/\\$//;
	next unless -e;
	
	Win32::FileSecurity::Get( $_, \%hash ) ;
	$hash{Administrator} = ( -d ) ? $dir : $file ;
	Win32::FileSecurity::Set( $_, \%hash ) ;
}

=head1 VERSION

1.01 ALPHA 97-04-25

=head1 REVISION NOTES

=over 10

=item 1.01 ALPHA 1997.04.25
	CORE Win32 version imported from 0.66 <gsar@umich.edu>

=item 0.66 ALPHA 1997.03.13
	Fixed bug in memory allocation check

=item 0.65 ALPHA 1997.02.25
	Tested with 5.003 build 303
	Added ISA exporter, and @EXPORT_OK
	Added F, FULL, R, READ, C, CHANGE as composite pre-built mask names.
	Added server\ to keys returned in hash from Get
	Made constants and MakeMask case insensitive (I don't know why I did that)
	Fixed mask comparison in ListDacl and Enumerate Rights from simple & mask
		to exact bit match ! ( ( x & y ) ^ x ) makes sure all bits in x
		are set in y
	Fixed some "wild" pointers

=item 0.60 ALPHA 1996.07.31
	Now suitable for file and directory permissions
	Included ListDacl.exe in bundle for debugging
	Added "intuitive" inheritance for directories, basically functions like FM
		triggered by presence of GENERIC_ rights this may need to change
		see EXAMPLE2
	Changed from AddAccessAllowedAce to AddAce for control over inheritance
	
=item 0.51 ALPHA 1996.07.20
	Fixed memory allocation bug

=item 0.50 ALPHA 1996.07.29
	Base functionality
	Using AddAccessAllowedAce
	Suitable for file permissions
=back

=head1 KNOWN ISSUES / BUGS

=over 10

=item 1
	May not work on remote drives.

=item 2
	Errors croak, don't return via $! as documented.

=cut
