use ExtUtils::MakeMaker;
use Config;
$BORLAND = 1 if $Config{'cc'} =~ /^bcc32/i;
WriteMakefile(
    'NAME'	=> 'Win32::Internet',
    'VERSION_FROM' => 'Internet.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'LDLOADLIBS' => ($BORLAND ? 'import32.lib cw32mti.lib inet.lib'
			: 'wininet.lib advapi32.lib version.lib'),
    'INC'	=> '-I.',
);
