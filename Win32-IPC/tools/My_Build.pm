#---------------------------------------------------------------------
package My_Build;
#
# Copyright 2008 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 29 Feb 2008
# $Id$
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# Customize Module::Build for Win32::IPC
#---------------------------------------------------------------------

use strict;
use warnings;
use File::Spec ();
use Module::Build ();

# Use Module::Build::DistVersion if we can get it:
BEGIN {
  eval q{ use base 'Module::Build::DistVersion'; };
  eval q{ use base 'Module::Build'; } if $@;
  die $@ if $@;
}

#=====================================================================
# Package Global Variables:

our $VERSION = '0.02';

#=====================================================================
sub ACTION_distdir
{
  my $self = shift @_;

  print STDERR <<"END" unless $self->isa('Module::Build::DistVersion');
\a\a\a\n
Win32-IPC uses Module::Build::DistVersion to automatically copy
version numbers to the appropriate places.  You might want to install
that and re-run Build.PL if you intend to create a distribution.
\n
END

  $self->SUPER::ACTION_distdir(@_);
} # end ACTION_distdir

#---------------------------------------------------------------------
# Compile an XS file, but use the version number from the module
# instead of the distribution's version number

sub process_xs
{
  my $self = shift @_;
  my $pm_file = $_[0];

  # Get the version number from the corresponding .pm file:
  $pm_file =~ s/\.xs$/.pm/i or die "$pm_file: Not an .xs file";
  my $pm_info = Module::Build::ModuleInfo->new_from_file($pm_file)
      or die "Can't find file $pm_file to determine version";

  # Tell dist_version to use it:
  local $self->{My_Build__pm_version} = $pm_info->version
      or die "Can't find version in $pm_file";

  # Now that dist_version is lying, process the XS file:
  $self->SUPER::process_xs(@_);
} # end process_xs

#---------------------------------------------------------------------
# Lie about the version number when necessary (for process_xs):

sub dist_version
{
  my $self = shift @_;

  return $self->{My_Build__pm_version}
      if defined $self->{My_Build__pm_version};

  $self->SUPER::dist_version(@_);
} # end dist_version

#=====================================================================
# Package Return Value:

1;
