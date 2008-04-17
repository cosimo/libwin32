#!/usr/bin/perl -w
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..216\n"; }
END {print "not ok 1\n" unless $loaded;}
use Win32API::Registry qw(:ALL);
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

BEGIN { eval "use Win32API::Registry qw(:SE_);" }

$zero= 0;	# Change to 0 when RegEnumKeyExA() and RegEnumValueA()
		# handle ERROR_MORE_DATA better!

$ok= RegQueryInfoKey( HKEY_LOCAL_MACHINE, $class, $clen=0, [],
  $nkeys, $xkey, $xclass, $nvals, $xval, $xdata, $xsec, $time );
$ok or print "# ",regLastError(),"\n";
print "# LMach key:  Class=$class <=$xclass, ",
  "$nkeys subkeys <=$xkey, $nvals vals <=($xval,$xdata), sec<=$xsec.\n";
print $ok ? "" : "not ", "ok 2\n";

$ok= RegEnumKeyEx( HKEY_LOCAL_MACHINE, 0, $key, $klen=$zero,
		   [], $class, $clen=0, [] );
$ok or print "# ",regLastError(),"\n";
print "# First LMach subkey:  Name=$key, Class=$class.\n";
print $ok ? "" : "not ", "ok 3\n";

$ok= (  $klen == length($key)  &&  $clen == length($class)  );
print $ok ? "" : "not ", "ok 4\n";

$ok= RegEnumKeyEx( HKEY_LOCAL_MACHINE, $nkeys-1, $key, $klen=0,
		   [], $class, $clen=0, $time );
$ok or print "# ",regLastError(),"\n";
print "# Last LMach subkey:  Name=$key, Class=$class.\n";
print $ok ? "" : "not ", "ok 5\n";

$ok= RegEnumKeyExW( HKEY_LOCAL_MACHINE, $nkeys-1, $wkey, $wklen=0,
		    [], $wclass, $wclen=0, $wtime );
$ok or print "# ",regLastError(),"\n";
if(  $Debug  ) {
    $_= "Last LMach subkey:  Wide name=$wkey, Wide class=$wclass.";
    s#([^ -~])#sprintf "\\x%02X",unpack("C",$1)#ge;
    print "# $_\n";
}
print $ok ? "" : "not ", "ok 6\n";

$ok= (  $wklen == $klen  &&  2*$wklen == length($wkey)
    &&  $wclen == $clen  &&  2*$wclen == length($wclass)
    &&  $time eq $wtime  );
print $ok ? "" : "not ", "ok 7\n";

$ok= RegOpenKeyEx( HKEY_LOCAL_MACHINE, $key, 0, KEY_READ, $hkey );
$ok or print "# ",regLastError(),"\n";
print "# LMach\\$key handle is $hkey.\n";
print $ok ? "" : "not ", "ok 8\n";

$ok= RegQueryInfoKey( $hkey, $kclass, $clen=0, [],
  $nkeys, [], [], $nvals, $xval, $xdata, $xsec, $time );
print "# LMach\\$key:  Class=$kclass <=?, ",
  "$nkeys subkeys <=?, $nvals vals <=($xval,$xdata), sec<=$xsec.\n";
print $ok ? "" : "not ", "ok 9\n";

$ok= (  $class eq $kclass  );
print $ok ? "" : "not ", "ok 10\n";

$path= $key;
while(  0 == $nvals  ) {

    $ok= RegEnumKeyEx( $hkey, $nkeys-1, $key2, $klen2=2*$zero,
		       [], $class2, $clen2=1*$zero, $time );
    $ok  or  die "Can't find key with values:  ",regLastError(),"\n";
    print "# Last LMach\\$path subkey:  Name=$key2, Class=$class2.\n";
    $path .= "\\$key2";
    $clen2= $klen2;	# Don't warn about these vars being used but once.

    $ok= RegOpenKeyEx( $hkey, $key2, 0, KEY_READ, $hkey2 );
    $ok or print "# ",regLastError(),"\n";
    print "# LMach\\$path handle is $hkey2.\n";

    $ok= RegCloseKey( $hkey );
    $ok or print "# RegCloseKey: ",regLastError(),"\n";

    $hkey= $hkey2;

    $ok= RegQueryInfoKey( $hkey, $kclass, [],
      $nkeys, $xkey, $xclass, $nvals, $xval, $xdata, [], $time );
    $ok or print "# ",regLastError(),"\n";
    print "# LMach\\$path:  Class=$kclass <=$xclass, ",
      "$nkeys subkeys <=$xkey, $nvals vals <=($xval,$xdata).\n";

}

$ok= RegOpenKeyEx( HKEY_LOCAL_MACHINE, $path, 0, KEY_READ, $hkey2 );
$ok or print "# ",regLastError(),"\n";
print "# LMach\\$path new handle is $hkey2.\n";
print $ok ? "" : "not ", "ok 11\n";

$ok= RegEnumValue( $hkey, 0, $name, $nlen=0, [], $type, $data, $dlen=0 );
$ok or print "# ",regLastError(),"\n";
if(  $Debug  ) {
    $_= "First LMach\\$path val:  Name=$name, Type=$type, Data=$data.";
    s#([^ -~])#sprintf "\\x%02X",unpack("C",$1)#ge;
    print "# $_\n";
}
print $ok ? "" : "not ", "ok 12\n";
@valnames= ($name);

$ok= RegEnumValueA( $hkey, $nvals-1, $name, $nlen=$zero,
		    [], $type, $data, $dlen=0 );
$ok or print "# ",regLastError(),"\n";
if(  $Debug  ) {
    $_= "Last LMach\\$path val:  Name=$name, Type=$type, Data=$data.";
    s#([^ -~])#sprintf "\\x%02X",unpack("C",$1)#ge;
    print "# $_\n";
}
print $ok ? "" : "not ", "ok 13\n";
push( @valnames, $name );

$ok= (  $nlen == length($name)  &&  $dlen == length($data)  );
print $ok ? "" : "not ", "ok 14\n";

$ok= RegQueryValueEx( $hkey, $name, [], $vtype, $vdata, $vdlen=0 );
if(  $Debug  ) {
    $_= "LMach\\$key\\$key2\\$name:  Type=$vtype, Data=$vdata.";
    s#([^ -~])#sprintf "\\x%02X",unpack("C",$1)#ge;
    print "# $_\n";
}
print $ok ? "" : "not ", "ok 15\n";

$ok= (  $type == $vtype  &&  $data eq $vdata  &&  $dlen == $vdlen  );
print "# length(data)=",length($data)," length(vdata)=",
  length($vdata), " dlen=$dlen, vdlen=$vdlen.\n";
print $ok ? "" : "not ", "ok 16\n";

$pValueEnts= pack( " p x4 x4 x4 " x @valnames, @valnames );
$ok= RegQueryMultipleValues( $hkey, $pValueEnts, 0+@valnames, $buffer, 1 );
print $ok ? "" : "not ", "ok 17\n";

@lens=  unpack( " x4 L x4 x4 " x @valnames, $pValueEnts );
@types= unpack( " x4 x4 x4 L " x @valnames, $pValueEnts );
@dat1=  unpack(  join( "", map(" x4 x4 P$_ x4 ",@lens) ), $pValueEnts  );
@dat2=  unpack( join("",map("a$_",@lens)), $buffer );
if(  $ok= ( @dat1==@dat2 && @dat1==@types )  ) {
    for(0..$#dat1) { if( $dat1[$_] ne $dat2[$_] ) { $ok= 0; last; } }
}
print $ok ? "" : "not ", "ok 18\n";


$ok= RegCloseKey( $hkey );
$ok or print "# ",regLastError(),"\n";
print $ok ? "" : "not ", "ok 19\n";

$ok= ! RegEnumValue( $hkey, 0, $name, $nlen=0, [], $type, $data, $dlen=0 );
print $ok ? "" : "not ", "ok 20\n";
print "# Using closed key gives:  `",regLastError(),"'.\n";

$ok= (  regLastError() =~ /handle/i  &&  regLastError() =~ /invali/i  );
print $ok ? "" : "# ".regLastError()."\nnot ", "ok 21\n";

$ok= (  $type == $vtype  &&  $data eq $vdata  );
print $ok ? "" : "not ", "ok 22\n";

$ok=	HKEY_CLASSES_ROOT &&	HKEY_CURRENT_CONFIG &&	HKEY_CURRENT_USER
 &&	HKEY_DYN_DATA &&	HKEY_LOCAL_MACHINE &&	HKEY_PERFORMANCE_DATA
 &&	HKEY_USERS;
print $ok ? "" : "not ", "ok 23\n";

$ok=	KEY_QUERY_VALUE &&	KEY_SET_VALUE &&	KEY_CREATE_SUB_KEY
 &&	KEY_ENUMERATE_SUB_KEYS &&	KEY_NOTIFY &&	KEY_CREATE_LINK
 &&	KEY_READ &&		KEY_WRITE &&		KEY_EXECUTE
 &&	KEY_ALL_ACCESS;
print $ok ? "" : "not ", "ok 24\n";

$ok=	0==REG_OPTION_RESERVED && 0==REG_OPTION_NON_VOLATILE
 &&	REG_OPTION_VOLATILE
 &&	REG_OPTION_CREATE_LINK && REG_OPTION_BACKUP_RESTORE
 &&	REG_OPTION_OPEN_LINK &&	REG_LEGAL_OPTION &&	REG_CREATED_NEW_KEY
 &&	REG_OPENED_EXISTING_KEY && REG_WHOLE_HIVE_VOLATILE && REG_REFRESH_HIVE
 &&	REG_NO_LAZY_FLUSH &&	REG_NOTIFY_CHANGE_ATTRIBUTES
 &&	REG_NOTIFY_CHANGE_NAME && REG_NOTIFY_CHANGE_LAST_SET
 &&	REG_NOTIFY_CHANGE_SECURITY &&			REG_LEGAL_CHANGE_FILTER
 &&	0==REG_NONE &&		REG_SZ &&		REG_EXPAND_SZ
 &&	REG_BINARY &&		REG_DWORD &&		REG_DWORD_LITTLE_ENDIAN
 &&	REG_DWORD_BIG_ENDIAN &&	REG_LINK &&		REG_MULTI_SZ
 &&	REG_RESOURCE_LIST &&	REG_FULL_RESOURCE_DESCRIPTOR
 &&	REG_RESOURCE_REQUIREMENTS_LIST;
print $ok ? "" : "not ", "ok 25\n";

$ok=  ! eval { AbortSystemShutdown( [] ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 26\n";

$ok= 1;
#$ok=  ! eval { InitiateSystemShutdown([],[],0,0,0) }  &&  $@ eq "";
#$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 27\n";

$ok=  ! eval { RegCloseKey(0) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 28\n";

$ok=  ! eval { RegConnectRegistry(":",0,[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 29\n";

$ok=  ! eval { RegCreateKey(0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 30\n";

$ok=  ! eval { RegCreateKeyEx(0,[],0,[],0,0,[],[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 31\n";

$ok=  ! eval { RegDeleteKey(0,[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 32\n";

$ok=  ! eval { RegDeleteValue(0,[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 33\n";

$ok=  ! eval { RegEnumKey(0,0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 34\n";

$ok=  ! eval { RegEnumKey(0,0,[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 35\n";

$ok=  ! eval { RegEnumKeyEx(0,0,[],[],[],[],[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 36\n";

$ok=  ! eval { RegEnumKeyEx(0,0,[]   ,[],[],   []) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 37\n";

$ok=  ! eval { RegEnumValue(0,0,[],[],[],[],[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 38\n";

$ok=  ! eval { RegEnumValue(0,0,[]   ,[],[],[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 39\n";

$ok=  ! eval { RegFlushKey(0) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 40\n";

$ok=  ! eval { RegGetKeySecurity(0,0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 41\n";

$ok=  ! eval { RegGetKeySecurity(0,0,[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 42\n";

$ok=  ! eval { RegLoadKey(0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 43\n";

$ok=  ! eval { RegNotifyChangeKeyValue(0,0,0,[],0) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 44\n";

$ok=  ! eval { RegOpenKey(0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 45\n";

$ok=  ! eval { RegOpenKeyEx(0,[],0,0,[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 46\n";

$ok=  ! eval { RegQueryInfoKey(0,[],[],([])x9) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 47\n";

$ok=  ! eval { RegQueryInfoKey(0,[]   ,([])x9) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 48\n";

$ok=  ! eval { RegQueryMultipleValues(0,[],0,[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 49\n";

$ok=  ! eval { RegQueryMultipleValues(0,[],0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 50\n";

$ok=  ! eval { RegQueryValue(0,[],[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 51\n";

$ok=  ! eval { RegQueryValue(0,[],[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 52\n";

$ok=  ! eval { RegQueryValueEx(0,[],[],[],[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 53\n";

$ok=  ! eval { RegQueryValueEx(0,[],[],[],[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 54\n";

$ok=  ! eval { RegReplaceKey(0,[],[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 55\n";

$ok=  ! eval { RegRestoreKey(0,[],0) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 56\n";

$ok=  ! eval { RegSaveKey(0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 57\n";

$ok=  ! eval { RegSetKeySecurity(0,0,[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 58\n";

$ok=  ! eval { RegSetValue(0,[],0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 59\n";

$ok=  ! eval { RegSetValue(0,[],0,[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 60\n";

$ok=  ! eval { RegSetValueEx(0,[],0,0,[],[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 61\n";

$ok=  ! eval { RegSetValueEx(0,[],0,0,[]   ) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 62\n";

$ok=  ! eval { RegUnLoadKey(0,[]) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 63\n";

$ok=  ! eval { AllowPriv("",1) }  &&  $@ eq "";
$@ && print "# \$@=$@\n";
print $ok ? "" : "not ", "ok 64\n";

$test= 64;
my %consts;
my @consts= @Win32API::Registry::EXPORT_OK;
@consts{@consts}= @consts;

my( @noargs, %noargs )= qw( regLastError );
@noargs{@noargs}= @noargs;

foreach $func ( @{$Win32API::Registry::EXPORT_TAGS{Func}} ) {
    delete $consts{$func};
    if(  defined( $noargs{$func} )  ) {
	$ok=  ! eval("$func(0,0)")  &&  $@ =~ /(::|\s)_?${func}A?[(:\s]/;
    } else {
	$ok=  ! eval("$func()")  &&  $@ =~ /(::|\s)_?${func}A?[(:\s]/;
    }
    !$ok && print "# $func: $@\n";
    print $ok ? "" : "not ", "ok ", ++$test, "\n";
}

foreach $func ( @{$Win32API::Registry::EXPORT_TAGS{FuncA}},
                @{$Win32API::Registry::EXPORT_TAGS{FuncW}} ) {
    $ok=  ! eval("$func()")  &&  $@ =~ /::_?${func}\(/;
    delete $consts{$func};
    !$ok && print "# $func: $@\n";
    print $ok ? "" : "not ", "ok ", ++$test, "\n";
}

foreach $const ( keys(%consts) ) {
    $ok= eval("my \$x= $const(); 1");
    !$ok && print "# Constant $const: $@\n";
    print $ok ? "" : "not ", "ok ", ++$test, "\n";
}

__END__
