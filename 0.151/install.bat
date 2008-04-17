@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %1 %2 %3
goto endofperl
@rem ';
#!perl
#line 8

use lib 'instsup';
use Config;
use File::Copy;
use ExtUtils::Install 'install', 'install_default';

if (defined &Win32::BuildNumber) {
    if (Win32::BuildNumber() >= 509) {
	if (Win32::BuildNumber() >= 520) {
	die <<EOT;

You already have ActivePerl build 520 or better.

ActivePerl builds 520 and later already include this version
of libwin32, so there isn't much point in proceeding further.

Goodbye.

EOT
	}
	else {
	warn <<EOT;

You have a compatible version of ActivePerl.

I'm going to run "ppm.bat install .\\libwin32.ppd" for you, hang on...

EOT
	    system("ppm.bat install .\\libwin32.ppd") == 0
	       or die "`ppm.bat install .\\libwin32.ppd` failed: $?\n";
	}
    }
    else {
	die <<EOT;

You don't have a compatible version of ActivePerl installed.

Go and get the latest from http://www.activestate.com/.

ActivePerl builds 520 and later already include this version
of libwin32, so you won't need to install this is you get
a sufficiently recent version of ActivePerl.

EOT
    }
    exit(0);
}

if ($] ne '5.00402' or not -e "$Config{bin}/cw3230mt.dll") {
    die <<EOT;

You can only use this install.bat with a compatible binary
distribution of perl from the CPAN.  I can't find

    $Config{bin}/cw3230mt.dll

in your installation, which would seem to indicate that
you don't have a compatible installation.  If you have a
C compiler that is supported for building perl extensions,
use:

    perl Makefile.PL
    $Config{make}
    $Config{make} install

to install this package.  Please see the README file for
more specific information.

EOT
}

print STDERR "Installing into `$Config{installsitelib}'\n\nProceed? [y] ";

exit(0) unless <STDIN> !~ /^n/i;

install_default('Win32');

# now copy OLE browser files
install({ 'blib/html' => "$Config{installbin}/../html" }, 1);

my $instpm = "$Config{installprivlib}\\ExtUtils\\Install.pm";
if (-e $instpm) {
    if (11884 == -s _) {  # buggy version that came with bindist04
	warn "Updating buggy $instpm\n";
	chmod 0666, $instpm;
	copy(".\\instsup\\ExtUtils\\Install.pm", $instpm);
    }
}

# Win95 needs a different Process.dll due to unsupported
# SetProcessAffinityMask()
unless (Win32::IsWinNT()) {
    my $dll = "$Config{installsitearch}\\auto\\Win32\\Process\\Process.dll";
    warn "Suffering Windows95 or worse, dumbing down $dll\n";
    chmod 0666, $dll;
    copy(".\\instsup\\Process.dll", $dll);
}

END {
    warn "All done (press ENTER when ready).\n";
    $_ = <STDIN>;	# hang around in case they ran it from Exploder
}
__END__
:endofperl
