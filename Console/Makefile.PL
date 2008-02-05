use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Console',
    'VERSION_FROM' => 'Console.pm',
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
#    'INC'	=> '-I.\\include',
);
