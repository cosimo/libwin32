use strict;
use Config;
use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

my $is_msvc = $Config{'cc'} =~ /^cl/i;

WriteMakefile(
    'INC'		=> ($is_msvc ? '-GX' : ''),
    'OBJECT'		=> 'Cpipe$(OBJ_EXT) Pipe$(OBJ_EXT)',
    'NAME'		=> 'Win32::Pipe',
    'VERSION_FROM'	=> 'Pipe.pm',
    'XS'		=> { 'Pipe.xs' => 'Pipe.cpp' },
    'dist'		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Dave Roth <rothd@roth.net>',
	'ABSTRACT'	=> 'Pipe extension for Win32 Perl',
      )),
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
