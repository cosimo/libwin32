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
use ExtUtils::Install 'install_default';

unless (-e "$Config{bin}/cw3230mt.dll") {
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

warn "Installing into `$Config{installsitelib}'\n";
install_default('Win32');
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

warn "All done (press ENTER when ready).\n";
$_ = <STDIN>;	# hang around in case they ran it from Exploder
__END__
:endofperl
