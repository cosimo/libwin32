#! /usr/bin/perl
#---------------------------------------------------------------------
# $Id$
#---------------------------------------------------------------------

use Test::More tests => 1;

BEGIN {
    use_ok('Win32::Mutex');
}

diag("Testing Win32::Mutex $Win32::Mutex::VERSION");
