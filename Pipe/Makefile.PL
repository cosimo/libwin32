use ExtUtils::MakeMaker;
use Config;
$BORLAND = 1 if $Config{'cc'} =~ /^bcc32/i;
WriteMakefile(
    'INC'	=> ($BORLAND ? '' : '-GX'),
    'OBJECT'	=> 'Cpipe$(OBJ_EXT) Pipe$(OBJ_EXT)',
    'NAME'	=> 'Win32::Pipe',
    'VERSION_FROM' => 'Pipe.pm',
    'XS'	=> { 'Pipe.xs' => 'Pipe.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
