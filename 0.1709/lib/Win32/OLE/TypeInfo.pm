# This module is still experimental and intentionally undocumented.
# If you don't know why it is here, then you should probably not use it.

package Win32::OLE::TypeInfo;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK);
use vars qw(@VT %TYPEFLAGS @TYPEKIND %IMPLTYPEFLAGS %PARAMFLAGS
            %FUNCFLAGS @CALLCONV @FUNCKIND %INVOKEKIND %VARFLAGS
	    %LIBFLAGS @SYSKIND);

use Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(
  VT_EMPTY VT_NULL VT_I2 VT_I4 VT_R4 VT_R8 VT_CY VT_DATE
  VT_BSTR VT_DISPATCH VT_ERROR VT_BOOL VT_VARIANT VT_UNKNOWN
  VT_DECIMAL VT_I1 VT_UI1 VT_UI2 VT_UI4 VT_I8 VT_UI8 VT_INT
  VT_UINT VT_VOID VT_HRESULT VT_PTR VT_SAFEARRAY VT_CARRAY
  VT_USERDEFINED VT_LPSTR VT_LPWSTR VT_FILETIME VT_BLOB
  VT_STREAM VT_STORAGE VT_STREAMED_OBJECT VT_STORED_OBJECT
  VT_BLOB_OBJECT VT_CF VT_CLSID VT_VECTOR VT_ARRAY VT_BYREF
  VT_RESERVED VT_ILLEGAL VT_ILLEGALMASKED VT_TYPEMASK

  TYPEFLAG_FAPPOBJECT TYPEFLAG_FCANCREATE TYPEFLAG_FLICENSED
  TYPEFLAG_FPREDECLID TYPEFLAG_FHIDDEN TYPEFLAG_FCONTROL
  TYPEFLAG_FDUAL TYPEFLAG_FNONEXTENSIBLE TYPEFLAG_FOLEAUTOMATION
  TYPEFLAG_FRESTRICTED TYPEFLAG_FAGGREGATABLE TYPEFLAG_FREPLACEABLE
  TYPEFLAG_FDISPATCHABLE TYPEFLAG_FREVERSEBIND

  TKIND_ENUM TKIND_RECORD TKIND_MODULE TKIND_INTERFACE TKIND_DISPATCH
  TKIND_COCLASS TKIND_ALIAS TKIND_UNION TKIND_MAX

  IMPLTYPEFLAG_FDEFAULT IMPLTYPEFLAG_FSOURCE IMPLTYPEFLAG_FRESTRICTED
  IMPLTYPEFLAG_FDEFAULTVTABLE

  PARAMFLAG_NONE PARAMFLAG_FIN PARAMFLAG_FOUT PARAMFLAG_FLCID
  PARAMFLAG_FRETVAL PARAMFLAG_FOPT PARAMFLAG_FHASDEFAULT

  FUNCFLAG_FRESTRICTED FUNCFLAG_FSOURCE FUNCFLAG_FBINDABLE
  FUNCFLAG_FREQUESTEDIT FUNCFLAG_FDISPLAYBIND FUNCFLAG_FDEFAULTBIND
  FUNCFLAG_FHIDDEN FUNCFLAG_FUSESGETLASTERROR FUNCFLAG_FDEFAULTCOLLELEM
  FUNCFLAG_FUIDEFAULT FUNCFLAG_FNONBROWSABLE FUNCFLAG_FREPLACEABLE
  FUNCFLAG_FIMMEDIATEBIND

  CC_FASTCALL CC_CDECL CC_MSCPASCAL CC_PASCAL CC_MACPASCAL CC_STDCALL
  CC_FPFASTCALL CC_SYSCALL CC_MPWCDECL CC_MPWPASCAL CC_MAX

  INVOKE_FUNC INVOKE_PROPERTYGET INVOKE_PROPERTYPUT INVOKE_PROPERTYPUTREF

  VARFLAG_FREADONLY VARFLAG_FSOURCE VARFLAG_FBINDABLE VARFLAG_FREQUESTEDIT
  VARFLAG_FDISPLAYBIND VARFLAG_FDEFAULTBIND VARFLAG_FHIDDEN VARFLAG_FRESTRICTED
  VARFLAG_FDEFAULTCOLLELEM VARFLAG_FUIDEFAULT VARFLAG_FNONBROWSABLE
  VARFLAG_FREPLACEABLE VARFLAG_FIMMEDIATEBIND

  LIBFLAG_FRESTRICTED LIBFLAG_FCONTROL LIBFLAG_FHIDDEN
  SYS_WIN16 SYS_WIN32 SYS_MAC

  FUNC_VIRTUAL FUNC_PUREVIRTUAL FUNC_NONVIRTUAL FUNC_STATIC FUNC_DISPATCH

  @VT %TYPEFLAGS @TYPEKIND %IMPLTYPEFLAGS %PARAMFLAGS
  %FUNCFLAGS @CALLCONV @FUNCKIND %INVOKEKIND %VARFLAGS %LIBFLAGS @SYSKIND
);

# Lib Flags
# ---------

sub LIBFLAG_FRESTRICTED () { 0x01; }
sub LIBFLAG_FCONTROL    () { 0x02; }
sub LIBFLAG_FHIDDEN     () { 0x04; }

$LIBFLAGS{LIBFLAG_FRESTRICTED()} = LIBFLAG_FRESTRICTED;
$LIBFLAGS{LIBFLAG_FCONTROL()}    = LIBFLAG_FCONTROL;
$LIBFLAGS{LIBFLAG_FHIDDEN()}     = LIBFLAG_FHIDDEN;

# Sys Kind
# --------

sub SYS_WIN16 () { 0; }
sub SYS_WIN32 () { SYS_WIN16() + 1; }
sub SYS_MAC   () { SYS_WIN32() + 1; }

$SYSKIND[SYS_WIN16] = 'SYS_WIN16';
$SYSKIND[SYS_WIN32] = 'SYS_WIN32';
$SYSKIND[SYS_MAC]   = 'SYS_MAC';

# Type Flags
# ----------

sub TYPEFLAG_FAPPOBJECT     () { 0x1; }
sub TYPEFLAG_FCANCREATE     () { 0x2; }
sub TYPEFLAG_FLICENSED      () { 0x4; }
sub TYPEFLAG_FPREDECLID     () { 0x8; }
sub TYPEFLAG_FHIDDEN        () { 0x10; }
sub TYPEFLAG_FCONTROL       () { 0x20; }
sub TYPEFLAG_FDUAL          () { 0x40; }
sub TYPEFLAG_FNONEXTENSIBLE () { 0x80; }
sub TYPEFLAG_FOLEAUTOMATION () { 0x100; }
sub TYPEFLAG_FRESTRICTED    () { 0x200; }
sub TYPEFLAG_FAGGREGATABLE  () { 0x400; }
sub TYPEFLAG_FREPLACEABLE   () { 0x800; }
sub TYPEFLAG_FDISPATCHABLE  () { 0x1000; }
sub TYPEFLAG_FREVERSEBIND   () { 0x2000; }

$TYPEFLAGS{TYPEFLAG_FAPPOBJECT()}     = TYPEFLAG_FAPPOBJECT;
$TYPEFLAGS{TYPEFLAG_FCANCREATE()}     = TYPEFLAG_FCANCREATE;
$TYPEFLAGS{TYPEFLAG_FLICENSED()}      = TYPEFLAG_FLICENSED;
$TYPEFLAGS{TYPEFLAG_FPREDECLID()}     = TYPEFLAG_FPREDECLID;
$TYPEFLAGS{TYPEFLAG_FHIDDEN()}        = TYPEFLAG_FHIDDEN;
$TYPEFLAGS{TYPEFLAG_FCONTROL()}       = TYPEFLAG_FCONTROL;
$TYPEFLAGS{TYPEFLAG_FDUAL()}          = TYPEFLAG_FDUAL;
$TYPEFLAGS{TYPEFLAG_FNONEXTENSIBLE()} = TYPEFLAG_FNONEXTENSIBLE;
$TYPEFLAGS{TYPEFLAG_FOLEAUTOMATION()} = TYPEFLAG_FOLEAUTOMATION;
$TYPEFLAGS{TYPEFLAG_FRESTRICTED()}    = TYPEFLAG_FRESTRICTED;
$TYPEFLAGS{TYPEFLAG_FAGGREGATABLE()}  = TYPEFLAG_FAGGREGATABLE;
$TYPEFLAGS{TYPEFLAG_FREPLACEABLE()}   = TYPEFLAG_FREPLACEABLE;
$TYPEFLAGS{TYPEFLAG_FDISPATCHABLE()}  = TYPEFLAG_FDISPATCHABLE;
$TYPEFLAGS{TYPEFLAG_FREVERSEBIND()}   = TYPEFLAG_FREVERSEBIND;

# Type Kind
# ---------

sub TKIND_ENUM      () { 0; }
sub TKIND_RECORD    () { TKIND_ENUM()      + 1; }
sub TKIND_MODULE    () { TKIND_RECORD()    + 1; }
sub TKIND_INTERFACE () { TKIND_MODULE()    + 1; }
sub TKIND_DISPATCH  () { TKIND_INTERFACE() + 1; }
sub TKIND_COCLASS   () { TKIND_DISPATCH()  + 1; }
sub TKIND_ALIAS     () { TKIND_COCLASS()   + 1; }
sub TKIND_UNION     () { TKIND_ALIAS()     + 1; }
sub TKIND_MAX       () { TKIND_UNION()     + 1; }

$TYPEKIND[TKIND_ENUM]      = 'TKIND_ENUM';
$TYPEKIND[TKIND_RECORD]    = 'TKIND_RECORD';
$TYPEKIND[TKIND_MODULE]    = 'TKIND_MODULE';
$TYPEKIND[TKIND_INTERFACE] = 'TKIND_INTERFACE';
$TYPEKIND[TKIND_DISPATCH]  = 'TKIND_DISPATCH';
$TYPEKIND[TKIND_COCLASS]   = 'TKIND_COCLASS';
$TYPEKIND[TKIND_ALIAS]     = 'TKIND_ALIAS';
$TYPEKIND[TKIND_UNION]     = 'TKIND_UNION';

# Implemented Type Flags
# ----------------------

sub IMPLTYPEFLAG_FDEFAULT	() { 0x1; }
sub IMPLTYPEFLAG_FSOURCE	() { 0x2; }
sub IMPLTYPEFLAG_FRESTRICTED	() { 0x4; }
sub IMPLTYPEFLAG_FDEFAULTVTABLE	() { 0x800; }
 
$IMPLTYPEFLAGS{IMPLTYPEFLAG_FDEFAULT()}       = IMPLTYPEFLAG_FDEFAULT;
$IMPLTYPEFLAGS{IMPLTYPEFLAG_FSOURCE()}        = IMPLTYPEFLAG_FSOURCE;
$IMPLTYPEFLAGS{IMPLTYPEFLAG_FRESTRICTED()}    = IMPLTYPEFLAG_FRESTRICTED;
$IMPLTYPEFLAGS{IMPLTYPEFLAG_FDEFAULTVTABLE()} = IMPLTYPEFLAG_FDEFAULTVTABLE;

# Parameter Flags
# ---------------

sub PARAMFLAG_NONE        () { 0; }
sub PARAMFLAG_FIN         () { 0x1; }
sub PARAMFLAG_FOUT        () { 0x2; }
sub PARAMFLAG_FLCID       () { 0x4; }
sub PARAMFLAG_FRETVAL     () { 0x8; }
sub PARAMFLAG_FOPT        () { 0x10; }
sub PARAMFLAG_FHASDEFAULT () { 0x20; }

$PARAMFLAGS{PARAMFLAG_NONE()}        = PARAMFLAG_NONE;
$PARAMFLAGS{PARAMFLAG_FIN()}         = PARAMFLAG_FIN;
$PARAMFLAGS{PARAMFLAG_FOUT()}        = PARAMFLAG_FOUT;
$PARAMFLAGS{PARAMFLAG_FLCID()}       = PARAMFLAG_FLCID;
$PARAMFLAGS{PARAMFLAG_FRETVAL()}     = PARAMFLAG_FRETVAL;
$PARAMFLAGS{PARAMFLAG_FOPT()}        = PARAMFLAG_FOPT;
$PARAMFLAGS{PARAMFLAG_FHASDEFAULT()} = PARAMFLAG_FHASDEFAULT;

# Function Flags
# --------------

sub FUNCFLAG_FRESTRICTED       () { 0x1; }
sub FUNCFLAG_FSOURCE           () { 0x2; }
sub FUNCFLAG_FBINDABLE         () { 0x4; }
sub FUNCFLAG_FREQUESTEDIT      () { 0x8; }
sub FUNCFLAG_FDISPLAYBIND      () { 0x10; }
sub FUNCFLAG_FDEFAULTBIND      () { 0x20; }
sub FUNCFLAG_FHIDDEN           () { 0x40; }
sub FUNCFLAG_FUSESGETLASTERROR () { 0x80; }
sub FUNCFLAG_FDEFAULTCOLLELEM  () { 0x100; }
sub FUNCFLAG_FUIDEFAULT        () { 0x200; }
sub FUNCFLAG_FNONBROWSABLE     () { 0x400; }
sub FUNCFLAG_FREPLACEABLE      () { 0x800; }
sub FUNCFLAG_FIMMEDIATEBIND    () { 0x1000; }

$FUNCFLAGS{FUNCFLAG_FRESTRICTED()}       = FUNCFLAG_FRESTRICTED;
$FUNCFLAGS{FUNCFLAG_FSOURCE()}           = FUNCFLAG_FSOURCE;
$FUNCFLAGS{FUNCFLAG_FBINDABLE()}         = FUNCFLAG_FBINDABLE;
$FUNCFLAGS{FUNCFLAG_FREQUESTEDIT()}      = FUNCFLAG_FREQUESTEDIT;
$FUNCFLAGS{FUNCFLAG_FDISPLAYBIND()}      = FUNCFLAG_FDISPLAYBIND;
$FUNCFLAGS{FUNCFLAG_FDEFAULTBIND()}      = FUNCFLAG_FDEFAULTBIND;
$FUNCFLAGS{FUNCFLAG_FHIDDEN()}           = FUNCFLAG_FHIDDEN;
$FUNCFLAGS{FUNCFLAG_FUSESGETLASTERROR()} = FUNCFLAG_FUSESGETLASTERROR;
$FUNCFLAGS{FUNCFLAG_FDEFAULTCOLLELEM()}  = FUNCFLAG_FDEFAULTCOLLELEM;
$FUNCFLAGS{FUNCFLAG_FUIDEFAULT()}        = FUNCFLAG_FUIDEFAULT;
$FUNCFLAGS{FUNCFLAG_FNONBROWSABLE()}     = FUNCFLAG_FNONBROWSABLE;
$FUNCFLAGS{FUNCFLAG_FREPLACEABLE()}      = FUNCFLAG_FREPLACEABLE;
$FUNCFLAGS{FUNCFLAG_FIMMEDIATEBIND()}    = FUNCFLAG_FIMMEDIATEBIND;

# Calling conventions
# -------------------

sub CC_FASTCALL   () { 0; }
sub CC_CDECL      () { 1; }
sub CC_MSCPASCAL  () { CC_CDECL()      + 1; }
sub CC_PASCAL     () { CC_MSCPASCAL; }
sub CC_MACPASCAL  () { CC_PASCAL()     + 1; }
sub CC_STDCALL    () { CC_MACPASCAL()  + 1; }
sub CC_FPFASTCALL () { CC_STDCALL()    + 1; }
sub CC_SYSCALL    () { CC_FPFASTCALL() + 1; }
sub CC_MPWCDECL   () { CC_SYSCALL()    + 1; }
sub CC_MPWPASCAL  () { CC_MPWCDECL()   + 1; }
sub CC_MAX        () { CC_MPWPASCAL()  + 1; }

$CALLCONV[CC_FASTCALL]   = 'CC_FASTCALL';
$CALLCONV[CC_CDECL]      = 'CC_CDECL';
$CALLCONV[CC_PASCAL]     = 'CC_PASCAL';
$CALLCONV[CC_MACPASCAL]  = 'CC_MACPASCAL';
$CALLCONV[CC_STDCALL]    = 'CC_STDCALL';
$CALLCONV[CC_FPFASTCALL] = 'CC_FPFASTCALL';
$CALLCONV[CC_SYSCALL]    = 'CC_SYSCALL';
$CALLCONV[CC_MPWCDECL]   = 'CC_MPWCDECL';
$CALLCONV[CC_MPWPASCAL]  = 'CC_MPWPASCAL';

# Function Kind
# -------------

sub FUNC_VIRTUAL     () { 0; }
sub FUNC_PUREVIRTUAL () { FUNC_VIRTUAL()     + 1; }
sub FUNC_NONVIRTUAL  () { FUNC_PUREVIRTUAL() + 1; }
sub FUNC_STATIC      () { FUNC_NONVIRTUAL()  + 1; }
sub FUNC_DISPATCH    () { FUNC_STATIC()      + 1; }

$FUNCKIND[FUNC_VIRTUAL]     = 'FUNC_VIRTUAL';
$FUNCKIND[FUNC_PUREVIRTUAL] = 'FUNC_PUREVIRTUAL';
$FUNCKIND[FUNC_NONVIRTUAL]  = 'FUNC_NONVIRTUAL';
$FUNCKIND[FUNC_STATIC]      = 'FUNC_STATIC';
$FUNCKIND[FUNC_DISPATCH]    = 'FUNC_DISPATCH';

# Invoke Kind
# -----------

sub INVOKE_FUNC           () { 1; }
sub INVOKE_PROPERTYGET    () { 2; }
sub INVOKE_PROPERTYPUT    () { 4; }
sub INVOKE_PROPERTYPUTREF () { 8; }

$INVOKEKIND{INVOKE_FUNC()}           = INVOKE_FUNC;
$INVOKEKIND{INVOKE_PROPERTYGET()}    = INVOKE_PROPERTYGET;
$INVOKEKIND{INVOKE_PROPERTYPUT()}    = INVOKE_PROPERTYPUT;
$INVOKEKIND{INVOKE_PROPERTYPUTREF()} = INVOKE_PROPERTYPUTREF;

# Variable Flags
# --------------

sub VARFLAG_FREADONLY        () { 0x1;    }
sub VARFLAG_FSOURCE          () { 0x2;    }
sub VARFLAG_FBINDABLE        () { 0x4;    }
sub VARFLAG_FREQUESTEDIT     () { 0x8;    }
sub VARFLAG_FDISPLAYBIND     () { 0x10;   }
sub VARFLAG_FDEFAULTBIND     () { 0x20;   }
sub VARFLAG_FHIDDEN          () { 0x40;   }
sub VARFLAG_FRESTRICTED      () { 0x80;   }
sub VARFLAG_FDEFAULTCOLLELEM () { 0x100;  }
sub VARFLAG_FUIDEFAULT       () { 0x200;  }
sub VARFLAG_FNONBROWSABLE    () { 0x400;  }
sub VARFLAG_FREPLACEABLE     () { 0x800;  }
sub VARFLAG_FIMMEDIATEBIND   () { 0x1000; }

$VARFLAGS{VARFLAG_FREADONLY()}        = VARFLAG_FREADONLY;
$VARFLAGS{VARFLAG_FSOURCE()}          = VARFLAG_FSOURCE;
$VARFLAGS{VARFLAG_FBINDABLE()}        = VARFLAG_FBINDABLE;
$VARFLAGS{VARFLAG_FREQUESTEDIT()}     = VARFLAG_FREQUESTEDIT;
$VARFLAGS{VARFLAG_FDISPLAYBIND()}     = VARFLAG_FDISPLAYBIND;
$VARFLAGS{VARFLAG_FDEFAULTBIND()}     = VARFLAG_FDEFAULTBIND;
$VARFLAGS{VARFLAG_FHIDDEN()}          = VARFLAG_FHIDDEN;
$VARFLAGS{VARFLAG_FRESTRICTED()}      = VARFLAG_FRESTRICTED;
$VARFLAGS{VARFLAG_FDEFAULTCOLLELEM()} = VARFLAG_FDEFAULTCOLLELEM;
$VARFLAGS{VARFLAG_FUIDEFAULT()}       = VARFLAG_FUIDEFAULT;
$VARFLAGS{VARFLAG_FNONBROWSABLE()}    = VARFLAG_FNONBROWSABLE;
$VARFLAGS{VARFLAG_FREPLACEABLE()}     = VARFLAG_FREPLACEABLE;
$VARFLAGS{VARFLAG_FIMMEDIATEBIND()}   = VARFLAG_FIMMEDIATEBIND;


# Variant Types
# -------------

sub VT_EMPTY           () { 0; }
sub VT_NULL            () { 1; }
sub VT_I2              () { 2; }
sub VT_I4              () { 3; }
sub VT_R4              () { 4; }
sub VT_R8              () { 5; }
sub VT_CY              () { 6; }
sub VT_DATE            () { 7; }
sub VT_BSTR            () { 8; }
sub VT_DISPATCH        () { 9; }
sub VT_ERROR           () { 10; }
sub VT_BOOL            () { 11; }
sub VT_VARIANT         () { 12; }
sub VT_UNKNOWN         () { 13; }
sub VT_DECIMAL         () { 14; }
sub VT_I1              () { 16; }
sub VT_UI1             () { 17; }
sub VT_UI2             () { 18; }
sub VT_UI4             () { 19; }
sub VT_I8              () { 20; }
sub VT_UI8             () { 21; }
sub VT_INT             () { 22; }
sub VT_UINT            () { 23; }
sub VT_VOID            () { 24; }
sub VT_HRESULT         () { 25; }
sub VT_PTR             () { 26; }
sub VT_SAFEARRAY       () { 27; }
sub VT_CARRAY          () { 28; }
sub VT_USERDEFINED     () { 29; }
sub VT_LPSTR           () { 30; }
sub VT_LPWSTR          () { 31; }
sub VT_FILETIME        () { 64; }
sub VT_BLOB            () { 65; }
sub VT_STREAM          () { 66; }
sub VT_STORAGE         () { 67; }
sub VT_STREAMED_OBJECT () { 68; }
sub VT_STORED_OBJECT   () { 69; }
sub VT_BLOB_OBJECT     () { 70; }
sub VT_CF              () { 71; }
sub VT_CLSID           () { 72; }
sub VT_VECTOR          () { 0x1000; }
sub VT_ARRAY           () { 0x2000; }
sub VT_BYREF           () { 0x4000; }
sub VT_RESERVED        () { 0x8000; }
sub VT_ILLEGAL         () { 0xffff; }
sub VT_ILLEGALMASKED   () { 0xfff; }
sub VT_TYPEMASK        () { 0xfff; }

$VT[VT_EMPTY]           = 'VT_EMPTY';
$VT[VT_NULL]            = 'VT_NULL';
$VT[VT_I2]              = 'VT_I2';
$VT[VT_I4]              = 'VT_I4';
$VT[VT_R4]              = 'VT_R4';
$VT[VT_R8]              = 'VT_R8';
$VT[VT_CY]              = 'VT_CY';
$VT[VT_DATE]            = 'VT_DATE';
$VT[VT_BSTR]            = 'VT_BSTR';
$VT[VT_DISPATCH]        = 'VT_DISPATCH';
$VT[VT_ERROR]           = 'VT_ERROR';
$VT[VT_BOOL]            = 'VT_BOOL';
$VT[VT_VARIANT]         = 'VT_VARIANT';
$VT[VT_UNKNOWN]         = 'VT_UNKNOWN';
$VT[VT_DECIMAL]         = 'VT_DECIMAL';
$VT[VT_I1]              = 'VT_I1';
$VT[VT_UI1]             = 'VT_UI1';
$VT[VT_UI2]             = 'VT_UI2';
$VT[VT_UI4]             = 'VT_UI4';
$VT[VT_I8]              = 'VT_I8';
$VT[VT_UI8]             = 'VT_UI8';
$VT[VT_INT]             = 'VT_INT';
$VT[VT_UINT]            = 'VT_UINT';
$VT[VT_VOID]            = 'VT_VOID';
$VT[VT_HRESULT]         = 'VT_HRESULT';
$VT[VT_PTR]             = 'VT_PTR';
$VT[VT_SAFEARRAY]       = 'VT_SAFEARRAY';
$VT[VT_CARRAY]          = 'VT_CARRAY';
$VT[VT_USERDEFINED]     = 'VT_USERDEFINED';
$VT[VT_LPSTR]           = 'VT_LPSTR';
$VT[VT_LPWSTR]          = 'VT_LPWSTR';
$VT[VT_FILETIME]        = 'VT_FILETIME';
$VT[VT_BLOB]            = 'VT_BLOB';
$VT[VT_STREAM]          = 'VT_STREAM';
$VT[VT_STORAGE]         = 'VT_STORAGE';
$VT[VT_STREAMED_OBJECT] = 'VT_STREAMED_OBJECT';
$VT[VT_STORED_OBJECT]   = 'VT_STORED_OBJECT';
$VT[VT_BLOB_OBJECT]     = 'VT_BLOB_OBJECT';
$VT[VT_CF]              = 'VT_CF';
$VT[VT_CLSID]           = 'VT_CLSID';
$VT[VT_VECTOR]          = 'VT_VECTOR';
$VT[VT_ARRAY]           = 'VT_ARRAY';
$VT[VT_BYREF]           = 'VT_BYREF';
$VT[VT_RESERVED]        = 'VT_RESERVED';
$VT[VT_ILLEGAL]         = 'VT_ILLEGAL';
$VT[VT_ILLEGALMASKED]   = 'VT_ILLEGALMASKED';
$VT[VT_TYPEMASK]        = 'VT_TYPEMASK';

1;
