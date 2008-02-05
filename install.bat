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

warn "Installing into `$Config{installsitelib}'\n";
install_default('Win32');
my $instpm = "$Config{installprivlib}\\ExtUtils\\Install.pm";
if (-e $instpm) {
    if (11884 == -s _) {  # buggy version that came with bindist04
	warn "Updating buggy $instpm\n";
	copy(".\\instsup\\ExtUtils\\Install.pm",$instpm);
    }
}

warn "All done.\n";
__END__
:endofperl
