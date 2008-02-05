/* Win32API/Registry.xs */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define  WIN32_LEAN_AND_MEAN	/* Tell windows.h to skip much */
#include <windows.h>
/*#ifdef __cplusplus
#include <malloc.h>*/
void * __cdecl _alloca(size_t);
/*#endif*/

#define oDWORD	DWORD
#define oHKEY	HKEY


#ifndef DEBUGGING
# define	Debug(list)	/*Nothing*/
#else
# define	Debug(list)	ErrPrintf list
# include <stdarg.h>
    static void
    ErrPrintf( const char *sFmt, ... )
    {
      va_list aArgs;
      static char *sEnv= NULL;
      DWORD nErr= GetLastError();
	if(  NULL == sEnv  ) {
	    if(  NULL == ( sEnv= getenv("DEBUG_WIN32API_REGISTRY") )  )
		sEnv= "";
	}
	if(  '\0' == *sEnv  )
	    return;
	va_start( aArgs, sFmt );
	vfprintf( stderr, sFmt, aArgs );
	va_end( aArgs );
	SetLastError( nErr );
    }
#endif /* DEBUGGING */


DWORD
constant( char *sName, int iArg )
{
    errno= 0;
    if(  '\0' == sName[0]  ||  '\0' == sName[1]
     ||  '\0' == sName[2]  ||  '\0' == sName[3]  ) {
	;
    } else switch(  sName[4]  ) {
	case 's':
	    if(  strEQ(sName,"constant")  )
		break;	/* Prevent infinite recursion for some typos */
	    break;
	case '_':
	    if(  strEQ( sName, "HKEY_CLASSES_ROOT" )  )
#ifdef HKEY_CLASSES_ROOT
		return (DWORD)HKEY_CLASSES_ROOT;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "HKEY_CURRENT_CONFIG" )  )
#ifdef HKEY_CURRENT_CONFIG
		return (DWORD)HKEY_CURRENT_CONFIG;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "HKEY_CURRENT_USER" )  )
#ifdef HKEY_CURRENT_USER
		return (DWORD)HKEY_CURRENT_USER;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "HKEY_DYN_DATA" )  )
#ifdef HKEY_DYN_DATA
		return (DWORD)HKEY_DYN_DATA;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "HKEY_LOCAL_MACHINE" )  )
#ifdef HKEY_LOCAL_MACHINE
		return (DWORD)HKEY_LOCAL_MACHINE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "HKEY_PERFORMANCE_DATA" )  )
#ifdef HKEY_PERFORMANCE_DATA
		return (DWORD)HKEY_PERFORMANCE_DATA;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "HKEY_USERS" )  )
#ifdef HKEY_USERS
		return (DWORD)HKEY_USERS;
#else
		goto not_there;
#endif
	    break;
	case 'A':
	    if(  strEQ( sName, "KEY_ALL_ACCESS" )  )
#ifdef KEY_ALL_ACCESS
		return (DWORD)KEY_ALL_ACCESS;
#else
		goto not_there;
#endif
	    break;
	case 'B':
	    if(  strEQ( sName, "REG_BINARY" )  )
#ifdef REG_BINARY
		return REG_BINARY;
#else
		goto not_there;
#endif
	    break;
	case 'C':
	    if(  strEQ( sName, "KEY_CREATE_LINK" )  )
#ifdef KEY_CREATE_LINK
		return KEY_CREATE_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "KEY_CREATE_LINK" )  )
#ifdef KEY_CREATE_LINK
		return KEY_CREATE_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "KEY_CREATE_SUB_KEY" )  )
#ifdef KEY_CREATE_SUB_KEY
		return KEY_CREATE_SUB_KEY;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_CREATED_NEW_KEY" )  )
#ifdef REG_CREATED_NEW_KEY
		return REG_CREATED_NEW_KEY;
#else
		goto not_there;
#endif
	    break;
	case 'D':
	    if(  strEQ( sName, "REG_DWORD" )  )
#ifdef REG_DWORD
		return REG_DWORD;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_DWORD_BIG_ENDIAN" )  )
#ifdef REG_DWORD_BIG_ENDIAN
		return REG_DWORD_BIG_ENDIAN;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_DWORD_LITTLE_ENDIAN" )  )
#ifdef REG_DWORD_LITTLE_ENDIAN
		return REG_DWORD_LITTLE_ENDIAN;
#else
		goto not_there;
#endif
	    break;
	case 'E':
	    if(  strEQ( sName, "KEY_ENUMERATE_SUB_KEYS" )  )
#ifdef KEY_ENUMERATE_SUB_KEYS
		return KEY_ENUMERATE_SUB_KEYS;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "KEY_EXECUTE" )  )
#ifdef KEY_EXECUTE
		return KEY_EXECUTE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_EXPAND_SZ" )  )
#ifdef REG_EXPAND_SZ
		return REG_EXPAND_SZ;
#else
		goto not_there;
#endif
	    break;
	case 'F':
	    if(  strEQ( sName, "REG_FULL_RESOURCE_DESCRIPTOR" )  )
#ifdef REG_FULL_RESOURCE_DESCRIPTOR
		return REG_FULL_RESOURCE_DESCRIPTOR;
#else
		goto not_there;
#endif
	    break;
	case 'G':
	    break;
	case 'H':
	    break;
	case 'I':
	    break;
	case 'J':
	    break;
	case 'K':
	    break;
	case 'L':
	    if(  strEQ( sName, "REG_LEGAL_CHANGE_FILTER" )  )
#ifdef REG_LEGAL_CHANGE_FILTER
		return REG_LEGAL_CHANGE_FILTER;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_LEGAL_OPTION" )  )
#ifdef REG_LEGAL_OPTION
		return REG_LEGAL_OPTION;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_LINK" )  )
#ifdef REG_LINK
		return REG_LINK;
#else
		goto not_there;
#endif
	    break;
	case 'M':
	    if(  strEQ( sName, "REG_MULTI_SZ" )  )
#ifdef REG_MULTI_SZ
		return REG_MULTI_SZ;
#else
		goto not_there;
#endif
	    break;
	case 'N':
	    if(  strEQ( sName, "KEY_NOTIFY" )  )
#ifdef KEY_NOTIFY
		return KEY_NOTIFY;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_NO_LAZY_FLUSH" )  )
#ifdef REG_NO_LAZY_FLUSH
		return REG_NO_LAZY_FLUSH;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_NONE" )  )
#ifdef REG_NONE
		return REG_NONE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_NOTIFY_CHANGE_ATTRIBUTES" )  )
#ifdef REG_NOTIFY_CHANGE_ATTRIBUTES
		return REG_NOTIFY_CHANGE_ATTRIBUTES;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_NOTIFY_CHANGE_LAST_SET" )  )
#ifdef REG_NOTIFY_CHANGE_LAST_SET
		return REG_NOTIFY_CHANGE_LAST_SET;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_NOTIFY_CHANGE_NAME" )  )
#ifdef REG_NOTIFY_CHANGE_NAME
		return REG_NOTIFY_CHANGE_NAME;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_NOTIFY_CHANGE_SECURITY" )  )
#ifdef REG_NOTIFY_CHANGE_SECURITY
		return REG_NOTIFY_CHANGE_SECURITY;
#else
		goto not_there;
#endif
	    break;
	case 'O':
	    if(  strEQ( sName, "REG_OPENED_EXISTING_KEY" )  )
#ifdef REG_OPENED_EXISTING_KEY
		return REG_OPENED_EXISTING_KEY;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_OPTION_BACKUP_RESTORE" )  )
#ifdef REG_OPTION_BACKUP_RESTORE
		return REG_OPTION_BACKUP_RESTORE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_OPTION_CREATE_LINK" )  )
#ifdef REG_OPTION_CREATE_LINK
		return REG_OPTION_CREATE_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_OPTION_NON_VOLATILE" )  )
#ifdef REG_OPTION_NON_VOLATILE
		return REG_OPTION_NON_VOLATILE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_OPTION_OPEN_LINK" )  )
#ifdef REG_OPTION_OPEN_LINK
		return REG_OPTION_OPEN_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_OPTION_RESERVED" )  )
#ifdef REG_OPTION_RESERVED
		return REG_OPTION_RESERVED;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_OPTION_VOLATILE" )  )
#ifdef REG_OPTION_VOLATILE
		return REG_OPTION_VOLATILE;
#else
		goto not_there;
#endif
	    break;
	case 'P':
	    break;
	case 'Q':
	    if(  strEQ( sName, "KEY_QUERY_VALUE" )  )
#ifdef KEY_QUERY_VALUE
		return KEY_QUERY_VALUE;
#else
		goto not_there;
#endif
	    break;
	case 'R':
	    if(  strEQ( sName, "KEY_READ" )  )
#ifdef KEY_READ
		return KEY_READ;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_REFRESH_HIVE" )  )
#ifdef REG_REFRESH_HIVE
		return REG_REFRESH_HIVE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_RESOURCE_LIST" )  )
#ifdef REG_RESOURCE_LIST
		return REG_RESOURCE_LIST;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_RESOURCE_REQUIREMENTS_LIST" )  )
#ifdef REG_RESOURCE_REQUIREMENTS_LIST
		return REG_RESOURCE_REQUIREMENTS_LIST;
#else
		goto not_there;
#endif
	    break;
	case 'S':
	    if(  strEQ( sName, "KEY_SET_VALUE" )  )
#ifdef KEY_SET_VALUE
		return KEY_SET_VALUE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_SZ" )  )
#ifdef REG_SZ
		return REG_SZ;
#else
		goto not_there;
#endif
	    break;
	case 'T':
	    break;
	case 'U':
	    break;
	 case 'V':
	    break;
	 case 'W':
	    if(  strEQ( sName, "KEY_WRITE" )  )
#ifdef KEY_WRITE
		return KEY_WRITE;
#else
		goto not_there;
#endif
	    if(  strEQ( sName, "REG_WHOLE_HIVE_VOLATILE" )  )
#ifdef REG_WHOLE_HIVE_VOLATILE
		return REG_WHOLE_HIVE_VOLATILE;
#else
		goto not_there;
#endif
	    break;
	 case 'X':
	    break;
	 case 'Y':
	    break;
	 case 'Z':
	    break;
    }
    errno = EINVAL;
    return 0;
not_there:
    errno = ENOENT;
    return 0;
}


static LONG
ErrorRet( DWORD uErr )
{
    if(  ERROR_SUCCESS == uErr  )
	return( TRUE );
    SetLastError( uErr );
    /* if(  ERROR_INSUFFICIENT_BUFFER == uErr  )
	return( TRUE );
    */
    return FALSE;
}


#include "buffers.h"


MODULE = Win32API::Registry		PACKAGE = Win32API::Registry		

PROTOTYPES: DISABLE


long
constant( sName, ivArg=0 )
	char *	sName
	int	ivArg


bool
AllowPriv( sPrivName, bEnable )
	char *	sPrivName
	BOOL	bEnable
    PREINIT:
    	HANDLE			hToken= INVALID_HANDLE_VALUE;
	TOKEN_PRIVILEGES	tokPrivNew;
    CODE:
	tokPrivNew.PrivilegeCount= 1;
	if(  bEnable  ) {
	    tokPrivNew.Privileges[0].Attributes= SE_PRIVILEGE_ENABLED;
	} else {
	    tokPrivNew.Privileges[0].Attributes= 0;
	}
	RETVAL= FALSE;
	if(  OpenProcessToken( GetCurrentProcess(),
	       TOKEN_ADJUST_PRIVILEGES, &hToken )
	 &&  LookupPrivilegeValue( NULL, sPrivName,
	       &tokPrivNew.Privileges[0].Luid )
	) {
	    SetLastError( ERROR_SUCCESS );
	    AdjustTokenPrivileges( hToken, FALSE, &tokPrivNew,
	      NULL, NULL, NULL );
	    if(  ERROR_SUCCESS == GetLastError()  ) {
		RETVAL= TRUE;
	    }
	}
	if(  ! RETVAL  &&  INVALID_HANDLE_VALUE != hToken  ) {
	  DWORD uErr= GetLastError();
	    CloseHandle( hToken );
	    SetLastError( uErr );
	}
    OUTPUT:
	RETVAL


BOOL
AbortSystemShutdownA( sComputerName )
	char *	sComputerName


BOOL
AbortSystemShutdownW( swComputerName )
	WCHAR *	swComputerName


BOOL
InitiateSystemShutdownA( sComputer, sMessage, uTimeoutSecs, bForce, bReboot )
	char *	sComputer
	char *	sMessage
	DWORD	uTimeoutSecs
	BOOL	bForce
	BOOL	bReboot


BOOL
InitiateSystemShutdownW( swComputer, swMessage, uTimeoutSecs, bForce, bReboot )
	WCHAR *	swComputer
	WCHAR *	swMessage
	DWORD	uTimeoutSecs
	BOOL	bForce
	BOOL	bReboot


bool
RegCloseKey( hKey )
	HKEY	hKey
    CODE:
	RETVAL= ErrorRet(  RegCloseKey( hKey )  );
    OUTPUT:
	RETVAL


bool
RegConnectRegistryA( sComputer, hRootKey, ohKey )
	char *	sComputer
	HKEY	hRootKey
	oHKEY *	ohKey
    CODE:
	RETVAL= ErrorRet(  RegConnectRegistryA(
			     sComputer, hRootKey, ohKey )  );
    OUTPUT:
	RETVAL
	ohKey


bool
RegConnectRegistryW( swComputer, hRootKey, ohKey )
	WCHAR *	swComputer
	HKEY	hRootKey
	HKEY *	ohKey
    CODE:
	RETVAL= ErrorRet(  RegConnectRegistryW(
			     swComputer, hRootKey, ohKey )  );
    OUTPUT:
	RETVAL
	ohKey


bool
RegCreateKeyA( hKey, sSubKey, ohSubKey )
	HKEY	hKey
	char *	sSubKey
	oHKEY *	ohSubKey
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyA( hKey, sSubKey, ohSubKey )  );
    OUTPUT:
	RETVAL
	ohSubKey


bool
RegCreateKeyW( hKey, swSubKey, ohSubKey )
	HKEY	hKey
	WCHAR *	swSubKey
	oHKEY *	ohSubKey
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyW( hKey, swSubKey, ohSubKey )  );
    OUTPUT:
	RETVAL
	ohSubKey


bool
RegCreateKeyExA(hKey,sSubKey,uZero,sClass,uOpts,uAccess,pSecAttr,ohNewKey,ouDisp)
	HKEY		hKey
	char *		sSubKey
	DWORD		uZero
	char *		sClass
	DWORD		uOpts
	REGSAM		uAccess
	void *		pSecAttr
	oHKEY *		ohNewKey
	oDWORD *	ouDisp
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyExA( hKey, sSubKey, uZero,
	  sClass, uOpts, uAccess, pSecAttr, ohNewKey, ouDisp )  );
    OUTPUT:
	RETVAL
	ohNewKey
	ouDisp


bool
RegCreateKeyExW(hKey,swSubKey,uZero,swClass,uOpts,uAccess,pSecAttr,ohNewKey,ouDisp)
	HKEY		hKey
	WCHAR *		swSubKey
	DWORD		uZero
	WCHAR *		swClass
	DWORD		uOpts
	REGSAM		uAccess
	void *		pSecAttr
	oHKEY *		ohNewKey
	oDWORD *	ouDisp
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyExW( hKey, swSubKey, uZero,
	  swClass, uOpts, uAccess, pSecAttr, ohNewKey, ouDisp )  );
    OUTPUT:
	RETVAL
	ohNewKey
	ouDisp


bool
RegDeleteKeyA( hKey, sSubKey )
	HKEY	hKey
	char *	sSubKey
    CODE:
	RETVAL= ErrorRet(  RegDeleteKeyA( hKey, sSubKey )  );
    OUTPUT:
	RETVAL


bool
RegDeleteKeyW( hKey, swSubKey )
	HKEY	hKey
	WCHAR *	swSubKey
    CODE:
	RETVAL= ErrorRet(  RegDeleteKeyW( hKey, swSubKey )  );
    OUTPUT:
	RETVAL


bool
RegDeleteValueA( hKey, sValueName )
	HKEY	hKey
	char *	sValueName
    CODE:
	RETVAL= ErrorRet(  RegDeleteValueA( hKey, sValueName )  );
    OUTPUT:
	RETVAL


bool
RegDeleteValueW( hKey, swValueName )
	HKEY	hKey
	WCHAR *	swValueName


bool
_RegEnumKeyA( hKey, uIndex, osName, ilNameSize )
	HKEY	hKey
	DWORD	uIndex
	char *	osName= NULL;
	DWORD	ilNameSize= init_buf_l($arg);
    CODE:
	grow_buf_l( osName,ST(2), ilNameSize,ST(3) );
	RETVAL= ErrorRet(  RegEnumKeyA( hKey, uIndex, osName, ilNameSize )  );
    OUTPUT:
	RETVAL
	osName	trunc_buf_z( RETVAL, osName,ST(2) );


bool
_RegEnumKeyW( hKey, uIndex, oswName, ilwNameSize )
	HKEY	hKey
	DWORD	uIndex
	WCHAR *	oswName= NULL;
	DWORD	ilwNameSize= init_buf_lw($arg);
    CODE:
	grow_buf_lw( oswName,ST(2), ilwNameSize,ST(3) );
	RETVAL= ErrorRet(  RegEnumKeyW( hKey, uIndex, oswName, ilwNameSize )  );
    OUTPUT:
	RETVAL
	oswName	trunc_buf_zw( RETVAL, oswName,ST(2) );


bool
_RegEnumKeyExA(hKey,uIndex,osName,iolName,pNull,osClass,iolClass,opftLastWrite)
	HKEY		hKey
	DWORD		uIndex
	char *		osName= NULL;
	DWORD *		iolName
	DWORD *		pNull
	char *		osClass= NULL;
	DWORD *		iolClass
	FILETIME *	opftLastWrite
    PREINIT:
    	DWORD		uErr;
    CODE:
	init_buf_pl( iolName,ST(3) );
	grow_buf_pl( osName,ST(2), iolName,ST(3) );
	init_buf_pl( iolClass,ST(6) );
	grow_buf_pl( osClass,ST(5), iolClass,ST(6) );
	uErr= RegEnumKeyExA( hKey, uIndex, osName, iolName,
	  pNull, osClass, iolClass, opftLastWrite );
	if(  ERROR_MORE_DATA == uErr
	 &&  ( autosize(ST(3)) || autosize(ST(6)) )  ) {
	    grow_buf_pl( osName,ST(2), iolName,ST(3) );
	    grow_buf_pl( osClass,ST(5), iolClass,ST(6) );
	    uErr= RegEnumKeyExA( hKey, uIndex, osName, iolName,
	      pNull, osClass, iolClass, opftLastWrite );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	osName	trunc_buf_pl( RETVAL, osName,ST(2), iolName );
	iolName
	pNull
	osClass	trunc_buf_pl( RETVAL, osClass,ST(5), iolClass );
	iolClass
	opftLastWrite


bool
_RegEnumKeyExW(hKey,uIndex,oswName,iolwName,pNull,oswClass,iolwClass,opftLastWrite)
	HKEY		hKey
	DWORD		uIndex
	WCHAR *		oswName= NULL;
	DWORD *		iolwName
	DWORD *		pNull
	WCHAR *		oswClass= NULL;
	DWORD *		iolwClass
	FILETIME *	opftLastWrite
    PREINIT:
	DWORD		uErr;
    CODE:
	init_buf_plw( iolwName,ST(3) );
	grow_buf_plw( oswName,ST(2), iolwName,ST(3) );
	init_buf_plw( iolwClass,ST(6) );
	grow_buf_plw( oswClass,ST(5), iolwClass,ST(6) );
	uErr= RegEnumKeyExW( hKey, uIndex, oswName, iolwName,
	  pNull, oswClass, iolwClass, opftLastWrite );
	if(  ERROR_MORE_DATA == uErr
	 &&  ( autosize(ST(3)) || autosize(ST(6)) )  ) {
	    grow_buf_plw( oswName,ST(2), iolwName,ST(3) );
	    grow_buf_plw( oswClass,ST(5), iolwClass,ST(6) );
	    uErr= RegEnumKeyExW( hKey, uIndex, oswName, iolwName,
	      pNull, oswClass, iolwClass, opftLastWrite );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	oswName		trunc_buf_plw( RETVAL, oswName,ST(2), iolwName );
	iolwName
	pNull
	oswClass	trunc_buf_plw( RETVAL, oswClass,ST(5), iolwClass );
	iolwClass
	opftLastWrite


bool
_RegEnumValueA(hKey,uIndex,osName,iolName,pNull,ouType,opData,iolData)
	HKEY		hKey
	DWORD		uIndex
	char *		osName= NULL;
	DWORD *		iolName
	DWORD *		pNull
	oDWORD *	ouType
	BYTE *		opData= NULL;
	DWORD *		iolData
    PREINIT:
	DWORD	uErr;
    CODE:
	init_buf_pl( iolName,ST(3) );
	grow_buf_pl( osName,ST(2), iolName,ST(3) );
	init_buf_pl( iolData,ST(7) );
	grow_buf_pl( opData,ST(6), iolData,ST(7) );
	if(  NULL == ouType  &&  NULL != opData  &&  null_arg(ST(7))  )
	    ouType= (DWORD *) _alloca( sizeof(DWORD) );
	uErr= RegEnumValueA( hKey, uIndex, osName,
	  iolName, pNull, ouType, opData, iolData );
	if(  ERROR_MORE_DATA == uErr
	 &&  ( autosize(ST(3)) || autosize(ST(7)) )  ) {
	    grow_buf_pl( osName,ST(2), iolName,ST(3) );
	    grow_buf_pl( opData,ST(6), iolData,ST(7) );
	    uErr= RegEnumValueA( hKey, uIndex, osName,
	      iolName, pNull, ouType, opData, iolData );
	}
	RETVAL= ErrorRet( uErr );
	/* Traim trailing '\0' from REG*_SZ values if iolData was C<[]>: */
	if(  RETVAL  &&  NULL != opData  &&  NULL != ouType
	 &&  ( REG_SZ == *ouType || REG_EXPAND_SZ == *ouType )
	 &&  null_arg(ST(7))  &&  '\0' == opData[*iolData-1]  )
	    --*iolData;
    OUTPUT:
	RETVAL
	osName		trunc_buf_pl( RETVAL, osName,ST(2), iolName );
	iolName
	pNull
	ouType
	opData		trunc_buf_pl( RETVAL, opData,ST(6), iolData );
	iolData


bool
_RegEnumValueW(hKey,uIndex,oswName,iolwName,pNull,ouType,opData,iolData)
	HKEY		hKey
	DWORD		uIndex
	WCHAR *		oswName= NULL;
	DWORD *		iolwName
	DWORD *		pNull
	oDWORD *	ouType
	BYTE *		opData= NULL;
	DWORD *		iolData
    PREINIT:
	DWORD	uErr;
    CODE:
	init_buf_plw( iolwName,ST(3) );
	grow_buf_plw( oswName,ST(2), iolwName,ST(3) );
	init_buf_pl( iolData,ST(7) );
	grow_buf_pl( opData,ST(6), iolData,ST(7) );
	if(  NULL == ouType  &&  NULL != opData  &&  null_arg(ST(7))  )
	    ouType= (DWORD *) _alloca( sizeof(DWORD) );
	uErr= RegEnumValueW( hKey, uIndex, oswName, iolwName,
	  pNull, ouType, opData, iolData );
	if(  ERROR_MORE_DATA == uErr
	 &&  ( autosize(ST(3)) || autosize(ST(7)) )  ) {
	    grow_buf_plw( oswName,ST(2), iolwName,ST(3) );
	    grow_buf_pl( opData,ST(6), iolData,ST(7) );
	    uErr= RegEnumValueW( hKey, uIndex, oswName, iolwName,
	      pNull, ouType, opData, iolData );
	}
	RETVAL= ErrorRet( uErr );
	/* Traim trailing L'\0' from REG*_SZ values if iolData was C<[]>: */
	if(  RETVAL  &&  NULL != opData  &&  NULL != ouType
	 &&  ( REG_SZ == *ouType || REG_EXPAND_SZ == *ouType )
	 &&  null_arg(ST(7))
	 &&  L'\0' == ((WCHAR *)opData)[(*iolData/sizeof(WCHAR))-1]  )
	    *iolData -= sizeof(WCHAR);
    OUTPUT:
	RETVAL
	oswName		trunc_buf_plw( RETVAL, oswName,ST(2), iolwName );
	iolwName
	pNull
	ouType
	opData		trunc_buf_pl( RETVAL, opData,ST(6), iolData );
	iolData


bool
RegFlushKey( hKey )
	HKEY	hKey
    CODE:
	RETVAL= ErrorRet(  RegFlushKey( hKey )  );
    OUTPUT:
	RETVAL


bool
_RegGetKeySecurity( hKey, uSecInfo, opSecDesc, iolSecDesc )
	HKEY			hKey
	SECURITY_INFORMATION	uSecInfo
	SECURITY_DESCRIPTOR *	opSecDesc= NULL;
	DWORD *			iolSecDesc
    PREINIT:
	DWORD			uErr;
    CODE:
	init_buf_pl( iolSecDesc,ST(3) );
	grow_buf_pl( opSecDesc,ST(2), iolSecDesc,ST(3) );
	uErr= RegGetKeySecurity( hKey, uSecInfo, opSecDesc, iolSecDesc );
	if(  ERROR_INSUFFICIENT_BUFFER == uErr  &&  autosize(ST(3))  ) {
	    grow_buf_pl( opSecDesc,ST(2), iolSecDesc,ST(3) );
	    uErr= RegGetKeySecurity( hKey, uSecInfo, opSecDesc, iolSecDesc );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	opSecDesc	trunc_buf_pl( RETVAL, opSecDesc,ST(2), iolSecDesc );
	iolSecDesc	if(!null_arg(ST(3)) && !SvREADONLY(ST(3))) sv_setiv( ST(3), (IV)(RETVAL ? GetSecurityDescriptorLength(opSecDesc) : *iolSecDesc) );


bool
RegLoadKeyA( hKey, sSubKey, sFileName )
	HKEY	hKey
	char *	sSubKey
	char *	sFileName
    CODE:
	RETVAL= ErrorRet(  RegLoadKeyA( hKey, sSubKey, sFileName )  );
    OUTPUT:
	RETVAL


bool
RegLoadKeyW( hKey, swSubKey, swFileName )
	HKEY	hKey
	WCHAR *	swSubKey
	WCHAR *	swFileName
    CODE:
	RETVAL= ErrorRet(  RegLoadKeyW( hKey, swSubKey, swFileName )  );
    OUTPUT:
	RETVAL


bool
RegNotifyChangeKeyValue( hKey, bWatchSubtree, uNotifyFilter, hEvent, bAsync )
	HKEY	hKey
	BOOL	bWatchSubtree
	DWORD	uNotifyFilter
	HANDLE	hEvent
	BOOL	bAsync
    CODE:
	RETVAL= ErrorRet(  RegNotifyChangeKeyValue(
	  hKey, bWatchSubtree, uNotifyFilter, hEvent, bAsync )  );
    OUTPUT:
	RETVAL


bool
RegOpenKeyA( hKey, sSubKey, ohSubKey )
	HKEY	hKey
	char *	sSubKey
	oHKEY *	ohSubKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyA( hKey, sSubKey, ohSubKey )  );
    OUTPUT:
	RETVAL
	ohSubKey


bool
RegOpenKeyW( hKey, swSubKey, ohSubKey )
	HKEY	hKey
	WCHAR *	swSubKey
	oHKEY *	ohSubKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyW( hKey, swSubKey, ohSubKey )  );
    OUTPUT:
	RETVAL
	ohSubKey


bool
RegOpenKeyExA( hKey, sSubKey, uOptions, uAccess, ohSubKey )
	HKEY	hKey
	char *	sSubKey
	DWORD	uOptions
	REGSAM	uAccess
	oHKEY *	ohSubKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyExA(
	  hKey, sSubKey, uOptions, uAccess, ohSubKey )  );
    OUTPUT:
	RETVAL
	ohSubKey


bool
RegOpenKeyExW( hKey, swSubKey, uOptions, uAccess, ohSubKey )
	HKEY	hKey
	WCHAR *	swSubKey
	DWORD	uOptions
	REGSAM	uAccess
	oHKEY *	ohSubKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyExW(
	  hKey, swSubKey, uOptions, uAccess, ohSubKey )  );
    OUTPUT:
	RETVAL
	ohSubKey


bool
_RegQueryInfoKeyA( hKey, osClass, iolClass, pNull, ocSubKeys, olSubKey, olSubClass, ocValues, olValName, olValData, olSecDesc, opftTime )
	HKEY		hKey
	char *		osClass= NULL;
	DWORD *		iolClass
	DWORD *		pNull
	oDWORD *	ocSubKeys
	oDWORD *	olSubKey
	oDWORD *	olSubClass
	oDWORD *	ocValues
	oDWORD *	olValName
	oDWORD *	olValData
	oDWORD *	olSecDesc
	FILETIME *	opftTime
    PREINIT:
	DWORD		uErr;
    CODE:
	init_buf_pl( iolClass,ST(2) );
	grow_buf_pl( osClass,ST(1), iolClass,ST(2) );
	uErr= RegQueryInfoKeyA( hKey, osClass, iolClass,
	  pNull, ocSubKeys, olSubKey, olSubClass, ocValues,
	  olValName, olValData, olSecDesc, opftTime );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(2))  ) {
	    grow_buf_pl( osClass,ST(1), iolClass,ST(2) );
	    uErr= RegQueryInfoKeyA( hKey, osClass, iolClass,
	      pNull, ocSubKeys, olSubKey, olSubClass, ocValues,
	      olValName, olValData, olSecDesc, opftTime );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	osClass		trunc_buf_pl( RETVAL, osClass,ST(1), iolClass );
	iolClass
	pNull
	ocSubKeys
	olSubKey
	olSubClass
	ocValues
	olValName
	olValData
	olSecDesc
	opftTime


bool
_RegQueryInfoKeyW( hKey, oswClass, iolwClass, pNull, ocSubKeys, olwSubKey, olwSubClass, ocValues, olwValName, olValData, olSecDesc, opftTime )
	HKEY		hKey
	WCHAR *		oswClass= NULL;
	DWORD *		iolwClass
	DWORD *		pNull
	oDWORD *	ocSubKeys
	oDWORD *	olwSubKey
	oDWORD *	olwSubClass
	oDWORD *	ocValues
	oDWORD *	olwValName
	oDWORD *	olValData
	oDWORD *	olSecDesc
	FILETIME *	opftTime
    PREINIT:
    	DWORD		uErr;
    CODE:
	init_buf_plw( iolwClass,ST(2) );
	grow_buf_plw( oswClass,ST(1), iolwClass,ST(2) );
	uErr= RegQueryInfoKeyW( hKey, oswClass, iolwClass,
	  pNull, ocSubKeys, olwSubKey, olwSubClass, ocValues,
	  olwValName, olValData, olSecDesc, opftTime );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(2))  ) {
	    grow_buf_plw( oswClass,ST(1), iolwClass,ST(2) );
	    uErr= RegQueryInfoKeyW( hKey, oswClass, iolwClass,
	      pNull, ocSubKeys, olwSubKey, olwSubClass, ocValues,
	      olwValName, olValData, olSecDesc, opftTime );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	oswClass	trunc_buf_plw( RETVAL, oswClass,ST(1), iolwClass );
	iolwClass
	pNull
	ocSubKeys
	olwSubKey
	olwSubClass
	ocValues
	olwValName
	olValData
	olSecDesc
	opftTime


bool
_RegQueryMultipleValuesA(hKey,ioarValueEnts,icValueEnts,opBuffer,iolBuffer)
	HKEY		hKey
	VALENTA *	ioarValueEnts
	DWORD		icValueEnts
	char *		opBuffer= NULL;
	DWORD *		iolBuffer
    PREINIT:
	DWORD		uErr;
    CODE:
	if(  NULL != ioarValueEnts  ) {
	    if(  0 == icValueEnts  ) {
		icValueEnts= SvCUR(ST(1)) / sizeof(VALENTA);
	    }
	    if(  SvCUR(ST(1)) < icValueEnts * sizeof(VALENTA)  ) {
		croak( "%s: %s (%d bytes < %d * %d)",
		  "Win32API::Registry::_RegQueryMultipleValuesA",
		  "ioarValueEnts shorter than specified",
		  SvCUR(ST(1)), icValueEnts, sizeof(VALENTA) );
	    }
	}
	init_buf_pl( iolBuffer,ST(4) );
	grow_buf_pl( opBuffer,ST(3), iolBuffer,ST(4) );
	uErr= RegQueryMultipleValuesA(
	  hKey, ioarValueEnts, icValueEnts, opBuffer, iolBuffer );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(4))  ) {
	    grow_buf_pl( opBuffer,ST(3), iolBuffer,ST(4) );
	    uErr= RegQueryMultipleValuesA(
	      hKey, ioarValueEnts, icValueEnts, opBuffer, iolBuffer );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	opBuffer	trunc_buf_pl( RETVAL, opBuffer,ST(3), iolBuffer );
	iolBuffer


bool
_RegQueryMultipleValuesW(hKey,ioarValueEnts,icValueEnts,opBuffer,iolBuffer)
	HKEY		hKey
	VALENTW *	ioarValueEnts
	DWORD		icValueEnts
	WCHAR *		opBuffer= NULL;
	DWORD *		iolBuffer
    PREINIT:
    	DWORD		uErr;
    CODE:
	if(  NULL != ioarValueEnts  ) {
	    if(  0 == icValueEnts  ) {
		icValueEnts= SvCUR(ST(1)) / sizeof(VALENTW);
	    }
	    if(  SvCUR(ST(1)) < icValueEnts * sizeof(VALENTW)  ) {
		croak( "%s: %s (%d bytes < %d * %d)",
		  "Win32API::Registry::_RegQueryMultipleValuesW",
		  "ioarValueEnts shorter than specified",
		  SvCUR(ST(1)), icValueEnts, sizeof(VALENTW) );
	    }
	}
	init_buf_pl( iolBuffer,ST(4) );
	grow_buf_pl( opBuffer,ST(3), iolBuffer,ST(4) );
	uErr= RegQueryMultipleValuesW(
	  hKey, ioarValueEnts, icValueEnts, opBuffer, iolBuffer );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(4))  ) {
	    grow_buf_pl( opBuffer,ST(3), iolBuffer,ST(4) );
	    uErr= RegQueryMultipleValuesW(
	      hKey, ioarValueEnts, icValueEnts, opBuffer, iolBuffer );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	opBuffer	trunc_buf_pl( RETVAL, opBuffer,ST(3), iolBuffer );
	iolBuffer


bool
_RegQueryValueA( hKey, sSubKey, osValueData, iolValueData )
	HKEY	hKey
	char *	sSubKey
	char *	osValueData= NULL;
	LONG *	iolValueData
    PREINIT:
	DWORD	uErr;
    CODE:
	init_buf_pl( iolValueData,ST(3) );
	grow_buf_pl( osValueData,ST(2), iolValueData,ST(3) );
	uErr= RegQueryValueA( hKey, sSubKey, osValueData, iolValueData );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(3))  ) {
	    grow_buf_pl( osValueData,ST(2), iolValueData,ST(3) );
	    uErr= RegQueryValueA( hKey, sSubKey, osValueData, iolValueData );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	osValueData	trunc_buf_pl( RETVAL, osValueData,ST(2), iolValueData );
	iolValueData


bool
_RegQueryValueW( hKey, swSubKey, oswValueData, iolValueData )
	HKEY	hKey
	WCHAR *	swSubKey
	WCHAR *	oswValueData= NULL;
	LONG *	iolValueData
    PREINIT:
    	DWORD	uErr;
    CODE:
	init_buf_pl( iolValueData,ST(3) );
	grow_buf_pl( oswValueData,ST(2), iolValueData,ST(3) );
	uErr= RegQueryValueW( hKey, swSubKey, oswValueData, iolValueData );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(3))  ) {
	    grow_buf_pl( oswValueData,ST(2), iolValueData,ST(3) );
	    uErr= RegQueryValueW( hKey, swSubKey, oswValueData, iolValueData );
	}
	RETVAL= ErrorRet( uErr );
    OUTPUT:
	RETVAL
	oswValueData	trunc_buf_pl(RETVAL,oswValueData,ST(2),iolValueData);
	iolValueData


bool
_RegQueryValueExA( hKey, sName, pNull, ouType, opData, iolData )
	HKEY		hKey
	char *		sName
	DWORD *		pNull
	oDWORD *	ouType
	BYTE *		opData= NULL;
	DWORD *		iolData
    PREINIT:
	DWORD	uErr;
    CODE:
	if(  NULL == ouType  &&  NULL != opData  &&  null_arg(ST(5))  )
	    ouType= (DWORD *) _alloca( sizeof(DWORD) );
	init_buf_pl( iolData,ST(5) );
	grow_buf_pl( opData,ST(4), iolData,ST(5) );
	uErr= RegQueryValueExA(
	  hKey, sName, pNull, ouType, opData, iolData );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(5))  ) {
	    grow_buf_pl( opData,ST(4), iolData,ST(5) );
	    uErr= RegQueryValueExA(
	      hKey, sName, pNull, ouType, opData, iolData );
	}
	RETVAL= ErrorRet( uErr );
	/* Traim trailing '\0' from REG*_SZ values if iolData was C<[]>: */
	if(  RETVAL  &&  NULL != opData  &&  NULL != ouType
	 &&  ( REG_SZ == *ouType || REG_EXPAND_SZ == *ouType )
	 &&  null_arg(ST(5))  &&  '\0' == opData[*iolData-1]  )
	    --*iolData;
    OUTPUT:
	RETVAL
	pNull
	ouType
	opData	trunc_buf_pl( RETVAL, opData,ST(4), iolData );
	iolData


bool
_RegQueryValueExW( hKey, swName, pNull, ouType, opData, iolData )
	HKEY		hKey
	WCHAR *		swName
	DWORD *		pNull
	oDWORD *	ouType
	BYTE *		opData= NULL;
	DWORD *		iolData
    PREINIT:
	DWORD	uErr;
    CODE:
	if(  NULL == ouType  &&  NULL != opData  &&  null_arg(ST(7))  )
	    ouType= (DWORD *) _alloca( sizeof(DWORD) );
	init_buf_pl( iolData,ST(5) );
	grow_buf_pl( opData,ST(4), iolData,ST(5) );
	uErr= RegQueryValueExW(
	  hKey, swName, pNull, ouType, opData, iolData );
	if(  ERROR_MORE_DATA == uErr  &&  autosize(ST(5))  ) {
	    grow_buf_pl( opData,ST(4), iolData,ST(5) );
	    uErr= RegQueryValueExW(
	      hKey, swName, pNull, ouType, opData, iolData );
	}
	RETVAL= ErrorRet( uErr );
	/* Traim trailing L'\0' from REG*_SZ vals if iolData was C<[]>: */
	if(  RETVAL  &&  NULL != opData  &&  NULL != ouType
	 &&  ( REG_SZ == *ouType || REG_EXPAND_SZ == *ouType )
	 &&  null_arg(ST(5))
	 &&  L'\0' == ((WCHAR *)opData)[(*iolData/sizeof(WCHAR))-1]  )
	    *iolData -= sizeof(WCHAR);
    OUTPUT:
	RETVAL
	pNull
	ouType
	opData	trunc_buf_pl( RETVAL, opData,ST(4), iolData );
	iolData


bool
RegReplaceKeyA( hKey, sSubKey, sNewFile, sOldFile )
	HKEY	hKey
	char *	sSubKey
	char *	sNewFile
	char *	sOldFile
    CODE:
	RETVAL= ErrorRet(
	  RegReplaceKeyA( hKey, sSubKey, sNewFile, sOldFile )  );
    OUTPUT:
	RETVAL


bool
RegReplaceKeyW( hKey, swSubKey, swNewFile, swOldFile )
	HKEY	hKey
	WCHAR *	swSubKey
	WCHAR *	swNewFile
	WCHAR *	swOldFile
    CODE:
	RETVAL= ErrorRet(
	  RegReplaceKeyW( hKey, swSubKey, swNewFile, swOldFile )  );
    OUTPUT:
	RETVAL


bool
RegRestoreKeyA( hKey, sFileName, uFlags )
	HKEY	hKey
	char *	sFileName
	DWORD	uFlags
    CODE:
	RETVAL= ErrorRet(  RegRestoreKeyA( hKey, sFileName, uFlags )  );
    OUTPUT:
	RETVAL


bool
RegRestoreKeyW( hKey, swFileName, uFlags )
	HKEY	hKey
	WCHAR *	swFileName
	DWORD	uFlags
    CODE:
	RETVAL= ErrorRet(  RegRestoreKeyW( hKey, swFileName, uFlags )  );
    OUTPUT:
	RETVAL


bool
RegSaveKeyA( hKey, sFileName, pSecAttr )
	HKEY			hKey
	char *			sFileName
	SECURITY_ATTRIBUTES *	pSecAttr
    CODE:
	RETVAL= ErrorRet(  RegSaveKeyA( hKey, sFileName, pSecAttr )  );
    OUTPUT:
	RETVAL


bool
RegSaveKeyW( hKey, swFileName, pSecAttr )
	HKEY			hKey
	WCHAR *			swFileName
	SECURITY_ATTRIBUTES *	pSecAttr
    CODE:
	RETVAL= ErrorRet(  RegSaveKeyW( hKey, swFileName, pSecAttr )  );
    OUTPUT:
	RETVAL


bool
RegSetKeySecurity( hKey, uSecInfo, pSecDesc )
	HKEY			hKey
	SECURITY_INFORMATION	uSecInfo
	SECURITY_DESCRIPTOR *	pSecDesc
    CODE:
	RETVAL= ErrorRet(  RegSetKeySecurity( hKey, uSecInfo, pSecDesc )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueA( hKey, sSubKey, uType, sValueData, lValueData )
	HKEY	hKey
	char *	sSubKey
	DWORD	uType
	char *	sValueData
	DWORD	lValueData
    CODE:
	if(  0 == lValueData  )
	    lValueData= SvCUR( ST(3) );
	RETVAL= ErrorRet(
	  RegSetValueA( hKey, sSubKey, uType, sValueData, lValueData )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueW( hKey, swSubKey, uType, swValueData, lValueData )
	HKEY	hKey
	WCHAR *	swSubKey
	DWORD	uType
	WCHAR *	swValueData
	DWORD	lValueData
    CODE:
	if(  0 == lValueData  )
	    lValueData= SvCUR( ST(3) ) / sizeof(WCHAR);
	RETVAL= ErrorRet(
	  RegSetValueW( hKey, swSubKey, uType, swValueData, lValueData )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueExA( hKey, sName, uZero, uType, pData, lData )
	HKEY	hKey
	char *	sName
	DWORD	uZero
	DWORD	uType
	BYTE *	pData
	DWORD	lData
    CODE:
	if(  0 == lData  ) {
	    lData= SvCUR( ST(4) );
	    if(  ( REG_SZ == uType || REG_EXPAND_SZ == uType )
	     &&  '\0' != pData[lData-1]  ) {
		pData[lData++]= '\0';	/* Should already be '\0', though. */
	    }
	}
	RETVAL= ErrorRet(  RegSetValueExA(
	  hKey, sName, uZero, uType, pData, lData )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueExW( hKey, swName, uZero, uType, pData, lData )
	HKEY	hKey
	WCHAR *	swName
	DWORD	uZero
	DWORD	uType
	BYTE *	pData
	DWORD	lData
    CODE:
	if(  0 == lData  ) {
	    lData= SvCUR( ST(4) );
	    if(  ( REG_SZ == uType || REG_EXPAND_SZ == uType )
	     &&  L'\0' != ((WCHAR *)pData)[(lData/sizeof(WCHAR))-1]  ) {
		pData[lData/sizeof(WCHAR)]= L'\0'; /* Should already be L'\0' */
		lData += sizeof(WCHAR);
	    }
	}
	RETVAL= ErrorRet(  RegSetValueExW(
	  hKey, swName, uZero, uType, pData, lData )  );
    OUTPUT:
	RETVAL


bool
RegUnLoadKeyA( hKey, sSubKey )
	HKEY	hKey
	char *	sSubKey
    CODE:
	RETVAL= ErrorRet(  RegUnLoadKeyA( hKey, sSubKey )  );
    OUTPUT:
	RETVAL


bool
RegUnLoadKeyW( hKey, swSubKey )
	HKEY	hKey
	WCHAR *	swSubKey
    CODE:
	RETVAL= ErrorRet(  RegUnLoadKeyW( hKey, swSubKey )  );
    OUTPUT:
	RETVAL
