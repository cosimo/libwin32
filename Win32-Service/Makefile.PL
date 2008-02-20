use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    'NAME'		=> 'Win32::Service',
    'VERSION_FROM'	=> 'Service.pm', # finds $VERSION
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Douglas Lankshear <dougl@ActiveState.com>',
	'ABSTRACT_FROM'	=> 'Service.pm',
      )),
);
