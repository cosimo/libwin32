#! /usr/bin/perl
#---------------------------------------------------------------------
# $Id$
#---------------------------------------------------------------------

use Test::More tests => 1;

BEGIN {
    use_ok('Win32::ChangeNotify');
}

diag("Testing Win32::ChangeNotify $Win32::ChangeNotify::VERSION");
