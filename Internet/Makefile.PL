use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Internet',
    'VERSION_FROM' => 'Internet.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'dynamic_lib' => { 'OTHERLDFLAGS' => q[wininet.lib advapi32.lib version.lib] },
#    'INC'	=> '-I.\\include',
);
