use ExtUtils::MakeMaker;
use Config;
my $inetlib = 'wininet';
$inetlib = 'inet' if $Config{'cc'} =~ /^bcc32/i;
WriteMakefile(
    'NAME'	=> 'Win32::Internet',
    'VERSION_FROM' => 'Internet.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'LIBS'	=> [ "-l$inetlib" ],
    'INC'	=> '-I.',
);
