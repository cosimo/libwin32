use strict;
use Config qw(%Config);
use ExtUtils::MakeMaker;

my $inetlib = "";
if ($^O eq "cygwin") {
    $inetlib = "-L/lib/w32api -lwininet -lversion";
}
elsif ($Config{cc} =~ /^cl/i) {
    $inetlib = "wininet.lib";
}

WriteMakefile(
    NAME		=> 'Win32::Internet',
    VERSION_FROM	=> 'Internet.pm',
    dist		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    LIBS		=> [ $inetlib ],
    INC			=> '-I.',
    ($] < 5.005 ? () :
      (
	AUTHOR		=> 'Aldo Calpini <dada@divinf.it>',
	ABSTRACT	=> 'An object oriented interface to the Win32 '
			 . 'Internet Functions (WININET.DLL)',
      )),
);

package MY;
use Config qw(%Config);
sub const_loadlibs {
    my ($self) = @_;
    if ($^O eq "MSWin32") {
	if ($Config{cc} =~ /^gcc/i) {
	    $self->{LDLOADLIBS} .= " -lwininet";
	}
	elsif ($Config{cc} =~ /^bcc/i) {
	    $self->{LDLOADLIBS} .= " inet.lib";
	}
	elsif ($] == 5.006 && $Config{cc} =~ /^cl/i) {
	    $self->{LDLOADLIBS} .= " wininet.lib";
	}
    }
    return $self->SUPER::const_loadlibs;
}
