#test for Perl NetResource Module Extension.
#Written by Jesse Dougherty for hip communications.
#Subsequently hacked by Gurusamy Sarathy <gsar@umich.edu>
#NOTE:
#this test will only work if a username and password are supplied in the 
#$user and $passwd vars.

$user = "";
$passwd = "";

use Win32::NetResource;
#use Data::Dumper;
#use Win32;
$debug = 0;
sub ErrorCheck
{
	my $err;
	if( $debug ){
		Win32::NetResource::GetError($err);
		print "# |$err| => ", Win32::FormatMessage($err), "\n";
	}
}

sub deb
{
	print STDERR $_[0] if $debug;
}

print "1..7\n";


$ShareInfo = {	'path' => 'c:\\',
		'netname' => "myshare",
		'remark' => "This mine, leave it alone",
		'passwd' => "soundgarden",
		'current-users' =>0,
		'permissions' => 0,
		'maxusers' => 10,
		'type'  => 10,
	     };


#test the hash conversion.

deb( "#testing the hash conversion routines\n");

$this = Win32::NetResource::_hash2SHARE( $ShareInfo );
$that = Win32::NetResource::_SHARE2hash( $this );

foreach( keys %$ShareInfo ){
	if($ShareInfo->{$_} ne $that->{$_} ){
		print "\n#$_ |$ShareInfo->{$_}| vs |$that->{$_}|\nnot";
	}
}
print "ok 1\n";

ErrorCheck();

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



deb("#Testing NetShareAdd\n");
$parm = "";
Win32::NetResource::NetShareAdd( $ShareInfo,$parm ) || print"not ";
print "ok 2\n";


ErrorCheck();

deb("#testing NetShareGetInfo\n");
$NewShare = {};
Win32::NetResource::NetShareGetInfo("PerlTempShare", $NewShare) || print "not ";
print "ok 3\n";
ErrorCheck();

if( $debug ){
	foreach( keys %$NewShare ){
		print"# $_ => $NewShare->{ $_ }\n";
	}
	print "\n";
}



#test the GetSharedResources function call.

$Aref=[];

deb("#testing GetSharedResources\n");

Win32::NetResource::GetSharedResources($Aref,0);
print "ok 4\n";
ErrorCheck();

if( $debug == 2 ){
	print "-----\n";
	foreach $href (@$Aref){
		foreach( keys %$href ){
			print "$_: $href->{$_}\n";
		}
		print "-----\n";
	}

}

# try to connect to the Temp share.

# Find the NETRESOURCE information for the Temp share.
$myRef = {};
foreach $href (@$Aref ){
		$myRef = $href if( $href->{'RemoteName'} =~ /PerlTempShare/ );
}

$drive = Win32::GetNextAvailDrive();
#$drive = 'I:';
$myRef->{'LocalName'} = $drive;
#print STDERR "mapping to |$drive|\n", Dumper($myRef), "\n";
Win32::NetResource::AddConnection($myRef,$passwd,$user,0);
ErrorCheck();


Win32::NetResource::GetUNCName( $UNCName, $drive ) || print "not ";
print "ok 5\n";
ErrorCheck();
deb( "#uncname is $UNCName\n");

Win32::NetResource::CancelConnection($drive,0,1) || print "not ";
print "ok 6\n";
ErrorCheck();


Win32::NetResource::NetShareDel("PerlTempShare") || print "not ";
print "ok 7\n";
ErrorCheck();




