use ExtUtils::MakeMaker;
use Config;
$BORLAND = 1 if $Config{'cc'} =~ /^bcc32/i;
WriteMakefile(
    'INC'	=> ($BORLAND ? '' : '-GX'),
    'OBJECT'	=> 'Dns$(OBJ_EXT) AdminMisc$(OBJ_EXT)',
    'NAME'	=> 'Win32::AdminMisc',
    'VERSION_FROM' => 'AdminMisc.pm',
    'XS'	=> { 'AdminMisc.xs' => 'AdminMisc.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}

