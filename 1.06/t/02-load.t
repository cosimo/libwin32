#! /usr/bin/perl
#---------------------------------------------------------------------
# $Id$
#---------------------------------------------------------------------

use Test::More tests => 1;

BEGIN {
    use_ok('Win32::Event');
}

diag("Testing Win32::Event $Win32::Event::VERSION");
