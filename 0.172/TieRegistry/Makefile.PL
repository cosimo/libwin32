use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32::TieRegistry',
    'VERSION_FROM'	=> 'TieRegistry.pm',	# finds $VERSION
    'PREREQ_PM'		=> { 'Win32API::Registry' => 0 },
    ($] < 5.005 ? () :
      (
	'ABSTRACT'	=> 'Powerful and easy ways to manipulate a registry',
	'AUTHOR'	=> 'Tye McQueen <tye@metronet.com>',
      )),
);
