use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32::Clipboard',
    'VERSION_FROM'	=> 'Clipboard.pm',
    'dist'		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'XS'		=> { 'Clipboard.xs' => 'Clipboard.cpp' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Aldo Calpini <dada@perl.it>',
	'ABSTRACT'	=> 'Interaction with the Windows clipboard',
      )),
);


sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
