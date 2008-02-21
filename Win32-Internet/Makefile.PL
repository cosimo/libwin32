use strict;
use warnings;
use Config qw(%Config);
use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

my $inetlib = "";
if ($^O eq "cygwin") {
    $inetlib = "-L/lib/w32api -lwininet -lversion";
}
elsif ($Config{cc} =~ /^cl/i) {
    $inetlib = "wininet.lib";
}

my %param = (
    NAME         => 'Win32::Internet',
    VERSION_FROM => 'Internet.pm',
    LIBS         => [ $inetlib ],
    INC          => '-I.',
);
$param{NO_META} = 1 if $ExtUtils::MakeMaker::VERSION >= 6.10_03;
WriteMakefile(%param);

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
