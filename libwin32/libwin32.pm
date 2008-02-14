package Bundle::libwin32;

$VERSION = 0.28;

1;

__END__

=head1 NAME

Bundle::libwin32 - install all modules that make up the libwin32 bundle

=head1 SYNOPSIS

 perl -MCPAN -e 'install Bundle::libwin32'

=head1 CONTENTS

Win32              - CORE module in 5.8.7 and 5.10

Win32API::File     - CORE module in 5.8.9 and 5.10

Win32API::Registry - maintained separately on CPAN

Win32::TieRegistry - maintained separately on CPAN

libwin32           - remaining modules not available separately

=head1 DESCRIPTION

The libwin32 package on CPAN contains a bundle of Win32-specific modules
that provide access to core Windows functionality.  Over time several
modules have been removed from libwin32 because they became part of
core Perl, or because they are maintained separately on CPAN.

The Bundle::libwin32 module provides an easy mechanism to install all
the modules that originally were part of the libwin32 package with a
single command. When you install the Bundle::libwin32, all modules
mentioned in L</CONTENTS> above will be installed instead.

=head1 SEE ALSO

L<CPAN/Bundles>
