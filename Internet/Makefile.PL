use ExtUtils::MakeMaker;
use Config;
my $inetlib = 'wininet';
$inetlib = 'inet' if $Config{'cc'} =~ /^bcc32/i;
WriteMakefile(
    'NAME'		=> 'Win32::Internet',
    'VERSION_FROM'	=> 'Internet.pm', # finds $VERSION
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'LIBS'		=> [ ":nosearch ${inetlib}.lib" ],
    'INC'	=> '-I.',
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Aldo Calpini <dada@divinf.it>',
	'ABSTRACT'	=> 'An object oriented interface to the Win32 '
			 . 'Internet Functions (WININET.DLL)',
      )),
);
