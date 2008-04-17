use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Shortcut',
    'VERSION_FROM' => 'Shortcut.pm', # finds $VERSION
    'XS'	=> { 'Shortcut.xs' => 'Shortcut.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
