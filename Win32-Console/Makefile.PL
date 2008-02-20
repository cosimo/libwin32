use ExtUtils::MakeMaker;

my %param = (
    NAME         => 'Win32::Console',
    VERSION_FROM => 'Console.pm',
);
$param{NO_META} = 1 if $ExtUtils::MakeMaker::VERSION >= 6.10_03;

WriteMakefile(%param);
