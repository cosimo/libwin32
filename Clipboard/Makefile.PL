use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Clipboard',
    'VERSION_FROM' => 'Clipboard.pm',
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
#    'INC'	=> '-I.\\include',
);
