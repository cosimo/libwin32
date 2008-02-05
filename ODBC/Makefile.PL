use ExtUtils::MakeMaker;
use Config;
$BORLAND = 1 if $Config{'cc'} =~ /^bcc32/i;
my $incpath = $Config{incpath};
WriteMakefile(
    'INC'	=> ($BORLAND ? "-I$incpath\\mfc" : '-GX'),
    'OBJECT'	=> 'CMom$(OBJ_EXT) Constant$(OBJ_EXT) CResults$(OBJ_EXT) ODBC$(OBJ_EXT)',
    'NAME'	=> 'Win32::ODBC',
    'VERSION_FROM' => 'ODBC.pm',
    'XS'	=> { 'ODBC.xs' => 'ODBC.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);

sub MY::xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
