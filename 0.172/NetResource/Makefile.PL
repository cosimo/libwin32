use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32::NetResource',
    'VERSION_FROM'	=> 'NetResource.pm',
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'}, 
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Jesse Dougherty',
	'ABSTRACT_FROM'	=> 'NetResource.pm',
      )),
);
