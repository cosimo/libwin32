use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Clipboard',
    'VERSION_FROM' => 'Clipboard.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'dynamic_lib' => { 'OTHERLDFLAGS' => q[advapi32.lib user32.lib] },
#    'INC'	=> '-I.\\include',
);
