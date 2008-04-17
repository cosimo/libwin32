use strict;
use Config;
use ExtUtils::MakeMaker;

my $inc = '';
if ($Config{'cc'} =~ /^cl/i) {
    $inc = '-GX';
}
elsif ($Config{'cc'} =~ /^bcc32/i) {
    $inc = '-I$Config{incpath}\\mfc';
}


WriteMakefile(
    'INC'		=> $inc,
    'OBJECT'		=> 'CMom$(OBJ_EXT) Constant$(OBJ_EXT) CResults$(OBJ_EXT) ODBC$(OBJ_EXT)',
    'NAME'		=> 'Win32::ODBC',
    'VERSION_FROM'	=> 'ODBC.pm',
    'XS'	=> { 'ODBC.xs' => 'ODBC.cpp' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Dave Roth <rothd@roth.net>',
	'ABSTRACT'	=> 'ODBC implementation',
      )),
);

package MY;
use Config;

sub const_loadlibs {
    my ($self) = @_;
    if ($^O eq "MSWin32" && $Config{cc} =~ /^gcc/i) {
	$self->{LDLOADLIBS} .= " -lodbccp32";

    }
    return $self->SUPER::const_loadlibs;
}

sub xs_c {
    '
.xs.cpp:
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs >xstmp.c && $(MV) xstmp.c $*.cpp
';
}
