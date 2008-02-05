use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32::Clipboard',
    'VERSION_FROM'	=> 'Clipboard.pm',
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Aldo Calpini <dada@divinf.it>',
	'ABSTRACT'	=> 'Perl Module for Windows Clipboard Interaction'
      )),
);
