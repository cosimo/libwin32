use ExtUtils::MakeMaker;
WriteMakefile(
    'INC'	=> '-GX',
    'OBJECT'	=> 'CMom$(OBJ_EXT) Constant$(OBJ_EXT) CResults$(OBJ_EXT) ODBC$(OBJ_EXT)',
    'NAME'	=> 'Win32::ODBC',
    'VERSION_FROM' => 'ODBC.pm',
    'XS'	=> { 'ODBC.xs' => 'ODBC.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    'dynamic_lib' => { 'OTHERLDFLAGS' => q[advapi32.lib odbc32.lib odbccp32.lib user32.lib] },
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
