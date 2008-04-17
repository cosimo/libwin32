use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Shortcut',
    'VERSION_FROM' => 'Shortcut.pm', # finds $VERSION
    'XS'	=> { 'Shortcut.xs' => 'Shortcut.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    'dynamic_lib' => { 'OTHERLDFLAGS' => q[shell32.lib ole32.lib oleaut32.lib uuid.lib user32.lib] },
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
