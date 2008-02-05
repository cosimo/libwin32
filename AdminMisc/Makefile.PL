use ExtUtils::MakeMaker;
WriteMakefile(
    'INC'	=> '-GX',
    'OBJECT'	=> 'Dns$(OBJ_EXT) AdminMisc$(OBJ_EXT)',
    'NAME'	=> 'Win32::AdminMisc',
    'VERSION_FROM' => 'AdminMisc.pm',
    'XS'	=> { 'AdminMisc.xs' => 'AdminMisc.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    'dynamic_lib' => { 'OTHERLDFLAGS' => q[wsock32.lib netapi32.lib advapi32.lib] },
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}

sub MY::c_o {
    '
.cpp$(OBJ_EXT):
	$(CCCMD) $(CCCDLFLAGS) -I$(PERL_INC) $(DEFINE) -Tp$*.cpp
';
}
