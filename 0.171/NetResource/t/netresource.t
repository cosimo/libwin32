#test for Perl NetResource Module Extension.
#Written by Jesse Dougherty for hip communications.
#Subsequently hacked by Gurusamy Sarathy <gsar@activestate.com>

#NOTE:
#this test will only work if a username and password are supplied in the 
#$user and $passwd vars.

$user = "";
$passwd = "";

use Win32::NetResource;
#use Data::Dumper;
#use Win32;
$debug = 2;

sub deb {
    if ($debug) {
	print "# @_\n"
    }
}

sub err {
    my $err;
    Win32::NetResource::GetError($err);
    deb("|$err| => ", Win32::FormatMessage($err));
}

print "1..7\n";

$ShareInfo = {
		'path' => 'c:\\',
		'netname' => "myshare",
		'remark' => "This mine, leave it alone",
		'passwd' => "soundgarden",
		'current-users' =>0,
		'permissions' => 0,
		'maxusers' => 10,
		'type'  => 10,
	     };

#
# test the hash conversion

deb("testing the hash conversion routines");

$this = Win32::NetResource::_hash2SHARE( $ShareInfo );
$that = Win32::NetResource::_SHARE2hash( $this );

foreach (keys %$ShareInfo) {
    if ($ShareInfo->{$_} ne $that->{$_}) {
	deb("$_ |$ShareInfo->{$_}| vs |$that->{$_}|");
	print "not ";
    }
}
print "ok 1\n";

err();

#
# Make a share of the current directory.

$ShareInfo = {
		'path' => "c:\\",
		'netname' => "PerlTempShare",
		'remark' => "This mine, leave it alone",
		'passwd' => "",
		'current-users' =>0,
		'permissions' => 0,
		'maxusers' => -1,
		'type'  => 0,
	     };



deb("Testing NetShareAdd");
$parm = "";
Win32::NetResource::NetShareAdd( $ShareInfo,$parm ) or print "not ";
print "ok 2\n";

err();

deb("testing NetShareGetInfo");
$NewShare = {};
Win32::NetResource::NetShareGetInfo("PerlTempShare", $NewShare) or print "not ";
print "ok 3\n";
err();

foreach (keys %$NewShare) {
    deb("# $_ => $NewShare->{ $_ }");
}

#
# test the GetSharedResources function call

$Aref=[];

deb("testing GetSharedResources");

Win32::NetResource::GetSharedResources($Aref,0);
print "ok 4\n";
err();

deb("-----");
foreach $href (@$Aref){
    foreach( keys %$href ){
	    deb(" $_: $href->{$_}");
    }
    deb("-----");
}

#
# try to connect to the Temp share

# Find the NETRESOURCE information for the Temp share.
$myRef = {};
foreach $href (@$Aref) {
    $myRef = $href if $href->{'RemoteName'} =~ /PerlTempShare/;
}

$drive = Win32::GetNextAvailDrive();
#$drive = 'I:';
$myRef->{'LocalName'} = $drive;
#print STDERR "mapping to |$drive|\n", Dumper($myRef), "\n";
Win32::NetResource::AddConnection($myRef,$passwd,$user,0);
err();

Win32::NetResource::GetUNCName( $UNCName, $drive ) or print "not ";
print "ok 5\n";
err();
deb("uncname is $UNCName");

Win32::NetResource::CancelConnection($drive,0,1) or print "not ";
print "ok 6\n";
err();

Win32::NetResource::NetShareDel("PerlTempShare") or print "not ";
print "ok 7\n";
err();




