use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32::Shortcut',
    'VERSION_FROM'	=> 'Shortcut.pm', # finds $VERSION
    'XS'		=> { 'Shortcut.xs' => 'Shortcut.cpp' },
    'dist'		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Aldo Calpini <dada@divinf.it>',
	'ABSTRACT'	=> 'An object oriented interface to the Win32 IShellLink Interface.',
      )),
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
