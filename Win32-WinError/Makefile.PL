use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    'NAME'		=> 'Win32::WinError',
    'VERSION_FROM'	=> 'WinError.pm', # finds $VERSION
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Unknown',
	'ABSTRACT'	=> 'Windows error constants.',
      )),
);
