use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32API::Net',
    'VERSION_FROM'	=> 'Net.pm', # finds $VERSION
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Bret Giddings <bret@essex.ac.uk>',
	'ABSTRACT_FROM'	=> 'Net.pm',
      )),
);
