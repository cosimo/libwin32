use ExtUtils::MakeMaker;
WriteMakefile(
    'INC'	=> '-GX',
    'OBJECT'	=> 'Cpipe$(OBJ_EXT) Pipe$(OBJ_EXT)',
    'NAME'	=> 'Win32::Pipe',
    'VERSION_FROM' => 'Pipe.pm',
    'XS'	=> { 'Pipe.xs' => 'Pipe.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    'dynamic_lib' => { 'OTHERLDFLAGS' => q[] },
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
