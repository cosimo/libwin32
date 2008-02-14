use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Console',
    'VERSION_FROM' => 'Console.pm',
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Aldo Calpini <dada@divinf.it>',
	'ABSTRACT'	=> 'Perl implementation of the Win32 Console '
			 . 'and Character mode functions',
      )),
);
