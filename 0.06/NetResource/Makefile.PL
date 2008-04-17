use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Win32::NetResource',
    'VERSION_FROM' => 'NetResource.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'}, 
    'dynamic_lib' => {OTHERLDFLAGS => 'mpr.lib netapi32.lib'}, 
);
