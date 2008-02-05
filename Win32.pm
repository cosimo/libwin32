package Win32;

#
#  Documentation for all Win32:: functions are in Win32.pod, which is a
#  standard part of Perl 5.6, and later.
#

BEGIN {
    use strict;
    use vars qw|$VERSION @ISA @EXPORT @EXPORT_OK|;

    require Exporter;
    require DynaLoader;

    @ISA = qw|Exporter DynaLoader|;
    $VERSION = '0.191';

    @EXPORT = qw(
	NULL
	WIN31_CLASS
	OWNER_SECURITY_INFORMATION
	GROUP_SECURITY_INFORMATION
	DACL_SECURITY_INFORMATION
	SACL_SECURITY_INFORMATION
	MB_ICONHAND
	MB_ICONQUESTION
	MB_ICONEXCLAMATION
	MB_ICONASTERISK
	MB_ICONWARNING
	MB_ICONERROR
	MB_ICONINFORMATION
	MB_ICONSTOP
    );
    @EXPORT_OK = qw(
        GetOSName
        SW_HIDE
        SW_SHOWNORMAL
        SW_SHOWMINIMIZED
        SW_SHOWMAXIMIZED
        SW_SHOWNOACTIVATE
    );
}

# Routines available in core:
# Win32::GetLastError
# Win32::LoginName
# Win32::NodeName
# Win32::DomainName
# Win32::FsType
# Win32::GetCwd
# Win32::GetOSVersion
# Win32::FormatMessage ERRORCODE
# Win32::Spawn COMMAND, ARGS, PID
# Win32::GetTickCount
# Win32::IsWinNT
# Win32::IsWin95

# We won't bother with the constant stuff, too much of a hassle. Just hard
# code it here.

sub NULL ()				{ 0 }
sub WIN31_CLASS ()			{ &NULL }

sub OWNER_SECURITY_INFORMATION ()	{ 0x00000001 }
sub GROUP_SECURITY_INFORMATION ()	{ 0x00000002 }
sub DACL_SECURITY_INFORMATION  ()	{ 0x00000004 }
sub SACL_SECURITY_INFORMATION  ()	{ 0x00000008 }

sub MB_ICONHAND		()		{ 0x00000010 }
sub MB_ICONQUESTION	()		{ 0x00000020 }
sub MB_ICONEXCLAMATION	()		{ 0x00000030 }
sub MB_ICONASTERISK	()		{ 0x00000040 }
sub MB_ICONWARNING	()		{ 0x00000030 }
sub MB_ICONERROR	()		{ 0x00000010 }
sub MB_ICONINFORMATION	()		{ 0x00000040 }
sub MB_ICONSTOP		()		{ 0x00000010 }

sub SW_HIDE           ()		{ 0 }
sub SW_SHOWNORMAL     ()		{ 1 }
sub SW_SHOWMINIMIZED  ()		{ 2 }
sub SW_SHOWMAXIMIZED  ()		{ 3 }
sub SW_SHOWNOACTIVATE ()		{ 4 }


### This method is just a simple interface into GetOSVersion().  More
### specific or demanding situations should use that instead.

my ($found_os, $found_desc);

sub GetOSName {
    my ($os,$desc,$major, $minor, $build, $id)=("","");
    unless (defined $found_os) {
        # If we have a run this already, we have the results cached
        # If so, return them

        # Use the standard API call to determine the version
        ($desc, $major, $minor, $build, $id) = Win32::GetOSVersion();

        # If id==0 then its a win32s box -- Meaning Win3.11
        #  http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/sysinfo_49iw.asp
        unless($id) {
            $os = 'Win32s';
        }
	else {
	    # Magic numbers from MSDN documentation of OSVERSIONINFO
	    # Here is some mickeysoft code that tells the story as well:
	    # http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/sysinfo_92jy.asp
	    # Caution with the above code as it uses functions unavailable
	    # to us in Perl.
	    # Most version names can be parsed from just the id and minor
	    # version
	    $os = {
		1 => {
		    0  => "95",
		    10 => "98",
		    90 => "Me"
		},
		2 => {
		    0  => "2000",
		    1  => "XP/.Net",
		    51 => "NT3.51"
		}
	    }->{$id}->{$minor};
	}

        # This _really_ shouldnt happen. At least not for quite a while
        # Politely warn and return undef
        unless (defined $os) {
            warn qq[Windows version [$id:$major:$minor] unknown!];
            return undef;
        }

        my $tag = "";

        # But distinguising W2k from NT4 requires looking at the major version
        if ($os eq "2000" && $major != 5) {
            $os = "NT4";
        }

        # For the rest we take a look at the build numbers and try to deduce
	# the exact release name, but we put that in the $desc
        elsif ($os eq "95") {
            if ($build eq '67109814') {
                    $tag = '(a)';
            }
	    elsif ($build eq '67306684') {
                    $tag = '(b1)';
            }
	    elsif ($build eq '67109975') {
                    $tag = '(b2)';
            }
        }
	elsif ($os eq "98" && $build eq '67766446') {
            $tag = '(2nd ed)';
        }

	if (length $tag) {
	    if (length $desc) {
	        $desc = "$tag $desc";
	    }
	    else {
	        $desc = $tag;
	    }
	}

        # cache the results, so we dont have to do this again
        $found_os      = "Win$os";
        $found_desc    = $desc;
    }

    return wantarray ? ($found_os, $found_desc) : $found_os;
}

bootstrap Win32;

1;
