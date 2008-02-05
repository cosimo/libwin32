/* Win32API/Registry.xs */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define  WIN32_LEAN_AND_MEAN	/* Tell windows.h to skip much */
#include <windows.h>
#ifdef __cplusplus
#include <malloc.h>
#endif


#ifndef DEBUGGING
# define	Debug(list)	/*Nothing*/
#else
# define	Debug(list)	ErrPrintf list
# include <stdarg.h>
    static void
    ErrPrintf( const char *fmt, ... )
    {
      va_list alist;
      static char *env= NULL;
      DWORD iErr= GetLastError();
	if(  NULL == env  ) {
	    if(  NULL == ( env= getenv("DEBUG_WIN32API_REGISTRY") )  )
		env= "";
	}
	if(  '\0' == *env  )
	    return;
	va_start( alist, fmt );
	vfprintf( stderr, fmt, alist );
	va_end( alist );
	SetLastError( iErr );
    }
#endif /* DEBUGGING */


DWORD
constant( char *name, int arg )
{
    errno= 0;
    if(  '\0' == name[0]  ||  '\0' == name[1]
     ||  '\0' == name[2]  ||  '\0' == name[3]  ) {
	;
    } else switch(  name[4]  ) {
	case 's':
	    if(  strEQ(name,"constant")  )
		break;	/* Prevent infinite recursion for some typos */
	    break;
	case '_':
	    if(  strEQ( name, "HKEY_CLASSES_ROOT" )  )
#ifdef HKEY_CLASSES_ROOT
		return (DWORD)HKEY_CLASSES_ROOT;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "HKEY_CURRENT_CONFIG" )  )
#ifdef HKEY_CURRENT_CONFIG
		return (DWORD)HKEY_CURRENT_CONFIG;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "HKEY_CURRENT_USER" )  )
#ifdef HKEY_CURRENT_USER
		return (DWORD)HKEY_CURRENT_USER;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "HKEY_DYN_DATA" )  )
#ifdef HKEY_DYN_DATA
		return (DWORD)HKEY_DYN_DATA;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "HKEY_LOCAL_MACHINE" )  )
#ifdef HKEY_LOCAL_MACHINE
		return (DWORD)HKEY_LOCAL_MACHINE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "HKEY_PERFORMANCE_DATA" )  )
#ifdef HKEY_PERFORMANCE_DATA
		return (DWORD)HKEY_PERFORMANCE_DATA;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "HKEY_USERS" )  )
#ifdef HKEY_USERS
		return (DWORD)HKEY_USERS;
#else
		goto not_there;
#endif
	    break;
	case 'A':
	    if(  strEQ( name, "KEY_ALL_ACCESS" )  )
#ifdef KEY_ALL_ACCESS
		return (DWORD)KEY_ALL_ACCESS;
#else
		goto not_there;
#endif
	    break;
	case 'B':
	    if(  strEQ( name, "REG_BINARY" )  )
#ifdef REG_BINARY
		return REG_BINARY;
#else
		goto not_there;
#endif
	    break;
	case 'C':
	    if(  strEQ( name, "KEY_CREATE_LINK" )  )
#ifdef KEY_CREATE_LINK
		return KEY_CREATE_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "KEY_CREATE_LINK" )  )
#ifdef KEY_CREATE_LINK
		return KEY_CREATE_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "KEY_CREATE_SUB_KEY" )  )
#ifdef KEY_CREATE_SUB_KEY
		return KEY_CREATE_SUB_KEY;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_CREATED_NEW_KEY" )  )
#ifdef REG_CREATED_NEW_KEY
		return REG_CREATED_NEW_KEY;
#else
		goto not_there;
#endif
	    break;
	case 'D':
	    if(  strEQ( name, "REG_DWORD" )  )
#ifdef REG_DWORD
		return REG_DWORD;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_DWORD_BIG_ENDIAN" )  )
#ifdef REG_DWORD_BIG_ENDIAN
		return REG_DWORD_BIG_ENDIAN;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_DWORD_LITTLE_ENDIAN" )  )
#ifdef REG_DWORD_LITTLE_ENDIAN
		return REG_DWORD_LITTLE_ENDIAN;
#else
		goto not_there;
#endif
	    break;
	case 'E':
	    if(  strEQ( name, "KEY_ENUMERATE_SUB_KEYS" )  )
#ifdef KEY_ENUMERATE_SUB_KEYS
		return KEY_ENUMERATE_SUB_KEYS;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "KEY_EXECUTE" )  )
#ifdef KEY_EXECUTE
		return KEY_EXECUTE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_EXPAND_SZ" )  )
#ifdef REG_EXPAND_SZ
		return REG_EXPAND_SZ;
#else
		goto not_there;
#endif
	    break;
	case 'F':
	    if(  strEQ( name, "REG_FULL_RESOURCE_DESCRIPTOR" )  )
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
	    if(  strEQ( name, "REG_LEGAL_CHANGE_FILTER" )  )
#ifdef REG_LEGAL_CHANGE_FILTER
		return REG_LEGAL_CHANGE_FILTER;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_LEGAL_OPTION" )  )
#ifdef REG_LEGAL_OPTION
		return REG_LEGAL_OPTION;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_LINK" )  )
#ifdef REG_LINK
		return REG_LINK;
#else
		goto not_there;
#endif
	    break;
	case 'M':
	    if(  strEQ( name, "REG_MULTI_SZ" )  )
#ifdef REG_MULTI_SZ
		return REG_MULTI_SZ;
#else
		goto not_there;
#endif
	    break;
	case 'N':
	    if(  strEQ( name, "KEY_NOTIFY" )  )
#ifdef KEY_NOTIFY
		return KEY_NOTIFY;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_NO_LAZY_FLUSH" )  )
#ifdef REG_NO_LAZY_FLUSH
		return REG_NO_LAZY_FLUSH;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_NONE" )  )
#ifdef REG_NONE
		return REG_NONE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_NOTIFY_CHANGE_ATTRIBUTES" )  )
#ifdef REG_NOTIFY_CHANGE_ATTRIBUTES
		return REG_NOTIFY_CHANGE_ATTRIBUTES;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_NOTIFY_CHANGE_LAST_SET" )  )
#ifdef REG_NOTIFY_CHANGE_LAST_SET
		return REG_NOTIFY_CHANGE_LAST_SET;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_NOTIFY_CHANGE_NAME" )  )
#ifdef REG_NOTIFY_CHANGE_NAME
		return REG_NOTIFY_CHANGE_NAME;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_NOTIFY_CHANGE_SECURITY" )  )
#ifdef REG_NOTIFY_CHANGE_SECURITY
		return REG_NOTIFY_CHANGE_SECURITY;
#else
		goto not_there;
#endif
	    break;
	case 'O':
	    if(  strEQ( name, "REG_OPENED_EXISTING_KEY" )  )
#ifdef REG_OPENED_EXISTING_KEY
		return REG_OPENED_EXISTING_KEY;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_OPTION_BACKUP_RESTORE" )  )
#ifdef REG_OPTION_BACKUP_RESTORE
		return REG_OPTION_BACKUP_RESTORE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_OPTION_CREATE_LINK" )  )
#ifdef REG_OPTION_CREATE_LINK
		return REG_OPTION_CREATE_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_OPTION_NON_VOLATILE" )  )
#ifdef REG_OPTION_NON_VOLATILE
		return REG_OPTION_NON_VOLATILE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_OPTION_OPEN_LINK" )  )
#ifdef REG_OPTION_OPEN_LINK
		return REG_OPTION_OPEN_LINK;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_OPTION_RESERVED" )  )
#ifdef REG_OPTION_RESERVED
		return REG_OPTION_RESERVED;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_OPTION_VOLATILE" )  )
#ifdef REG_OPTION_VOLATILE
		return REG_OPTION_VOLATILE;
#else
		goto not_there;
#endif
	    break;
	case 'P':
	    break;
	case 'Q':
	    if(  strEQ( name, "KEY_QUERY_VALUE" )  )
#ifdef KEY_QUERY_VALUE
		return KEY_QUERY_VALUE;
#else
		goto not_there;
#endif
	    break;
	case 'R':
	    if(  strEQ( name, "KEY_READ" )  )
#ifdef KEY_READ
		return KEY_READ;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_REFRESH_HIVE" )  )
#ifdef REG_REFRESH_HIVE
		return REG_REFRESH_HIVE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_RESOURCE_LIST" )  )
#ifdef REG_RESOURCE_LIST
		return REG_RESOURCE_LIST;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_RESOURCE_REQUIREMENTS_LIST" )  )
#ifdef REG_RESOURCE_REQUIREMENTS_LIST
		return REG_RESOURCE_REQUIREMENTS_LIST;
#else
		goto not_there;
#endif
	    break;
	case 'S':
	    if(  strEQ( name, "KEY_SET_VALUE" )  )
#ifdef KEY_SET_VALUE
		return KEY_SET_VALUE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_SZ" )  )
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
	    if(  strEQ( name, "KEY_WRITE" )  )
#ifdef KEY_WRITE
		return KEY_WRITE;
#else
		goto not_there;
#endif
	    if(  strEQ( name, "REG_WHOLE_HIVE_VOLATILE" )  )
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
ErrorRet( DWORD iErr )
{
    if(  ERROR_SUCCESS == iErr  )
	return( TRUE );
    SetLastError( iErr );
    /* if(  ERROR_INSUFFICIENT_BUFFER == iErr  )
	return( TRUE );
    */
    return FALSE;
}


#include "buffers.h"


MODULE = Win32API::Registry		PACKAGE = Win32API::Registry		

PROTOTYPES: DISABLE


long
constant( sName, iArg )
	char *	sName
	int	iArg


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
	 &&  AdjustTokenPrivileges( hToken, FALSE, &tokPrivNew,
	       NULL, NULL, NULL )  ) {
	    RETVAL= TRUE;
	    CloseHandle( hToken );
	} else if(  INVALID_HANDLE_VALUE != hToken  ) {
	  DWORD iErr= GetLastError();
	    CloseHandle( hToken );
	    SetLastError( iErr );
	}
    OUTPUT:
	RETVAL


BOOL
AbortSystemShutdownA( sComputerName )
	char *	sComputerName


BOOL
AbortSystemShutdownW( sComputerName )
	WCHAR *	sComputerName


BOOL
InitiateSystemShutdownA( sComputer, sMessage, iTimeoutSecs, bForce, bReboot )
	char *	sComputer
	char *	sMessage
	DWORD	iTimeoutSecs
	BOOL	bForce
	BOOL	bReboot


BOOL
InitiateSystemShutdownW( sComputer, sMessage, iTimeoutSecs, bForce, bReboot )
	WCHAR *	sComputer
	WCHAR *	sMessage
	DWORD	iTimeoutSecs
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
RegConnectRegistryA( sComputer, hKey, phKey )
	char *	sComputer
	HKEY	hKey
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegConnectRegistryA( sComputer, hKey, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegConnectRegistryW( sComputer, hKey, phKey )
	WCHAR *	sComputer
	HKEY	hKey
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegConnectRegistryW( sComputer, hKey, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegCreateKeyA( hKey, sSubKey, phKey )
	HKEY	hKey
	char *	sSubKey
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyA( hKey, sSubKey, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegCreateKeyW( hKey, sSubKey, phKey )
	HKEY	hKey
	WCHAR *	sSubKey
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyW( hKey, sSubKey, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegCreateKeyExA(hKey,sSubKey,iZero,sClass,iOpts,iAccess,pSecAttr,phKey,piDisp)
	HKEY	hKey
	char *	sSubKey
	DWORD	iZero
	char *	sClass
	DWORD	iOpts
	REGSAM	iAccess
	void *	pSecAttr
	HKEY *	phKey
	DWORD *	piDisp
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyExA( hKey, sSubKey, iZero,
	  sClass, iOpts, iAccess, pSecAttr, phKey, piDisp )  );
    OUTPUT:
	RETVAL
	phKey
	piDisp


bool
RegCreateKeyExW(hKey,sSubKey,iZero,sClass,iOpts,iAccess,pSecAttr,phKey,piDisp)
	HKEY	hKey
	WCHAR *	sSubKey
	DWORD	iZero
	WCHAR *	sClass
	DWORD	iOpts
	REGSAM	iAccess
	void *	pSecAttr
	HKEY *	phKey
	DWORD *	piDisp
    CODE:
	RETVAL= ErrorRet(  RegCreateKeyExW( hKey, sSubKey, iZero,
	  sClass, iOpts, iAccess, pSecAttr, phKey, piDisp )  );
    OUTPUT:
	RETVAL
	phKey
	piDisp


bool
RegDeleteKeyA( hKey, sSubKey )
	HKEY	hKey
	char *	sSubKey
    CODE:
	RETVAL= ErrorRet(  RegDeleteKeyA( hKey, sSubKey )  );
    OUTPUT:
	RETVAL


bool
RegDeleteKeyW( hKey, sSubKey )
	HKEY	hKey
	WCHAR *	sSubKey
    CODE:
	RETVAL= ErrorRet(  RegDeleteKeyW( hKey, sSubKey )  );
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
RegDeleteValueW( hKey, sValueName )
	HKEY	hKey
	WCHAR *	sValueName


bool
_RegEnumKeyA( hKey, iIndex, sName, lNameSize )
	HKEY	hKey
	DWORD	iIndex
	char *	sName
	DWORD	lNameSize
    PREINIT:
    	DWORD		iErr;
    CODE:
	grow_buf_l( sName,ST(2), lNameSize,ST(3) );
	iErr= RegEnumKeyA( hKey, iIndex, sName, lNameSize );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(3))  ) {
	    grow_buf_l( sName,ST(2), lNameSize,ST(3) );
	    iErr= RegEnumKeyA( hKey, iIndex, sName, lNameSize );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_l( RETVAL, sName,ST(2), lNameSize );
    OUTPUT:
	RETVAL
	sName
	lNameSize


bool
_RegEnumKeyW( hKey, iIndex, sName, lwNameSize )
	HKEY	hKey
	DWORD	iIndex
	WCHAR *	sName
	DWORD	lwNameSize
    PREINIT:
    	DWORD		iErr;
    CODE:
	grow_buf_lw( sName,ST(2), lwNameSize,ST(3) );
	iErr= RegEnumKeyW( hKey, iIndex, sName, lwNameSize );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(3))  ) {
	    grow_buf_lw( sName,ST(2), lwNameSize,ST(3) );
	    iErr= RegEnumKeyW( hKey, iIndex, sName, lwNameSize );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_lw( RETVAL, sName,ST(2), lwNameSize );
    OUTPUT:
	RETVAL
	sName
	lwNameSize


bool
_RegEnumKeyExA(hKey,iIndex,sName,plName,pNull,sClass,plClass,pftLastWrite)
	HKEY		hKey
	DWORD		iIndex
	char *		sName
	DWORD *		plName
	DWORD *		pNull
	char *		sClass
	DWORD *		plClass
	FILETIME *	pftLastWrite
    PREINIT:
    	DWORD		iErr;
    CODE:
	grow_buf_pl( sName,ST(2), plName,ST(3) );
	grow_buf_pl( sClass,ST(5), plClass,ST(6) );
	iErr= RegEnumKeyExA( hKey, iIndex, sName, plName,
	  pNull, sClass, plClass, pftLastWrite );
	if(  ERROR_MORE_DATA == iErr
	 &&  ( autosize(ST(3)) || autosize(ST(6)) )  ) {
	    grow_buf_pl( sName,ST(2), plName,ST(3) );
	    grow_buf_pl( sClass,ST(5), plClass,ST(6) );
	    iErr= RegEnumKeyExA( hKey, iIndex, sName, plName,
	      pNull, sClass, plClass, pftLastWrite );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, sName,ST(2), plName );
	trunc_buf_pl( RETVAL, sClass,ST(5), plClass );
    OUTPUT:
	RETVAL
	plName
	pNull
	plClass
	pftLastWrite


bool
_RegEnumKeyExW(hKey,iIndex,sName,plwName,pNull,sClass,plwClass,pftLastWrite)
	HKEY		hKey
	DWORD		iIndex
	WCHAR *		sName
	DWORD *		plwName
	DWORD *		pNull
	WCHAR *		sClass
	DWORD *		plwClass
	FILETIME *	pftLastWrite
    PREINIT:
	DWORD		iErr;
    CODE:
	grow_buf_plw( sName,ST(2), plwName,ST(3) );
	grow_buf_plw( sClass,ST(5), plwClass,ST(6) );
	grow_buf_typ( pftLastWrite,ST(7), FILETIME );
	iErr= RegEnumKeyExW( hKey, iIndex, sName, plwName,
	  pNull, sClass, plwClass, pftLastWrite );
	if(  ERROR_MORE_DATA == iErr
	 &&  ( autosize(ST(3)) || autosize(ST(6)) )  ) {
	    grow_buf_plw( sName,ST(2), plwName,ST(3) );
	    grow_buf_plw( sClass,ST(5), plwClass,ST(6) );
	    iErr= RegEnumKeyExW( hKey, iIndex, sName, plwName,
	      pNull, sClass, plwClass, pftLastWrite );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_plw( RETVAL, sName,ST(2), plwName );
	trunc_buf_plw( RETVAL, sClass,ST(5), plwClass );
	trunc_buf_typ( RETVAL, pftLastWrite,ST(7), FILETIME );
    OUTPUT:
	RETVAL
	plwName
	pNull
	plwClass
	pftLastWrite


bool
_RegEnumValueA(hKey,iIndex,sValName,plValName,pNull,piType,pValData,plValData)
	HKEY	hKey
	DWORD	iIndex
	char *	sValName
	DWORD *	plValName
	DWORD *	pNull
	DWORD *	piType
	BYTE *	pValData
	DWORD *	plValData
    PREINIT:
	DWORD	iErr;
    CODE:
	grow_buf_pl( sValName,ST(2), plValName,ST(3) );
	grow_buf_pl( pValData,ST(6), plValData,ST(7) );
	if(  NULL == piType  &&  NULL != pValData  &&  null_arg(ST(7))  )
	    piType= (DWORD *) _alloca( sizeof(DWORD) );
	iErr= RegEnumValueA( hKey, iIndex, sValName,
	  plValName, pNull, piType, pValData, plValData );
	if(  ERROR_MORE_DATA == iErr
	 &&  ( autosize(ST(3)) || autosize(ST(7)) )  ) {
	    grow_buf_pl( sValName,ST(2), plValName,ST(3) );
	    grow_buf_pl( pValData,ST(6), plValData,ST(7) );
	    iErr= RegEnumValueA( hKey, iIndex, sValName,
	      plValName, pNull, piType, pValData, plValData );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, sValName,ST(2), plValName );
	trunc_buf_pl( RETVAL, pValData,ST(6), plValData );
	/* Traim trailing '\0' from REG*_SZ values if plValData was C<[]>: */
	if(  RETVAL  &&  NULL != pValData  &&  NULL != piType
	 &&  ( REG_SZ == *piType || REG_EXPAND_SZ == *piType )
	 &&  null_arg(ST(7))  &&  '\0' == pValData[*plValData-1]  )
	    SvCUR_set( ST(6), --*plValData );
    OUTPUT:
	RETVAL
	sValName
	plValName
	pNull
	piType
	pValData
	plValData


bool
_RegEnumValueW(hKey,iIndex,sValName,plwValName,pNull,piType,pValData,plValData)
	HKEY	hKey
	DWORD	iIndex
	WCHAR *	sValName
	DWORD *	plwValName
	DWORD *	pNull
	DWORD *	piType
	BYTE *	pValData
	DWORD *	plValData
    PREINIT:
	DWORD	iErr;
    CODE:
	grow_buf_plw( sValName,ST(2), plwValName,ST(3) );
	grow_buf_pl( pValData,ST(6), plValData,ST(7) );
	if(  NULL == piType  &&  NULL != pValData  &&  null_arg(ST(7))  )
	    piType= (DWORD *) _alloca( sizeof(DWORD) );
	iErr= RegEnumValueW( hKey, iIndex, sValName, plwValName,
	  pNull, piType, pValData, plValData );
	if(  ERROR_MORE_DATA == iErr
	 &&  ( autosize(ST(3)) || autosize(ST(7)) )  ) {
	    grow_buf_plw( sValName,ST(2), plwValName,ST(3) );
	    grow_buf_pl( pValData,ST(6), plValData,ST(7) );
	    iErr= RegEnumValueW( hKey, iIndex, sValName, plwValName,
	      pNull, piType, pValData, plValData );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_plw( RETVAL, sValName,ST(2), plwValName );
	trunc_buf_pl( RETVAL, pValData,ST(6), plValData );
	/* Traim trailing L'\0' from REG*_SZ values if plValData was C<[]>: */
	if(  RETVAL  &&  NULL != pValData  &&  NULL != piType
	 &&  ( REG_SZ == *piType || REG_EXPAND_SZ == *piType )
	 &&  null_arg(ST(7))  &&  L'\0' == pValData[*plValData-1]  )
	    SvCUR_set( ST(6), sizeof(WCHAR)*(--*plValData) );
    OUTPUT:
	RETVAL
	plwValName
	pNull
	piType
	plValData


bool
RegFlushKey( hKey )
	HKEY	hKey
    CODE:
	RETVAL= ErrorRet(  RegFlushKey( hKey )  );
    OUTPUT:
	RETVAL


bool
_RegGetKeySecurity( hKey, iSecInfo, pSecDesc, plSecDesc )
	HKEY			hKey
	SECURITY_INFORMATION	iSecInfo
	SECURITY_DESCRIPTOR *	pSecDesc
	DWORD *			plSecDesc
    PREINIT:
	DWORD			iErr;
    CODE:
	grow_buf_pl( pSecDesc,ST(2), plSecDesc,ST(3) );
	iErr= RegGetKeySecurity( hKey, iSecInfo, pSecDesc, plSecDesc );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(3))  ) {
	    grow_buf_pl( pSecDesc,ST(2), plSecDesc,ST(3) );
	    iErr= RegGetKeySecurity( hKey, iSecInfo, pSecDesc, plSecDesc );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, pSecDesc,ST(2), plSecDesc );
    OUTPUT:
	RETVAL
	plSecDesc


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
RegLoadKeyW( hKey, sSubKey, sFileName )
	HKEY	hKey
	WCHAR *	sSubKey
	WCHAR *	sFileName
    CODE:
	RETVAL= ErrorRet(  RegLoadKeyW( hKey, sSubKey, sFileName )  );
    OUTPUT:
	RETVAL


bool
RegNotifyChangeKeyValue( hKey, bWatchSubtree, iNotifyFilter, hEvent, bAsync )
	HKEY	hKey
	BOOL	bWatchSubtree
	DWORD	iNotifyFilter
	HANDLE	hEvent
	BOOL	bAsync
    CODE:
	RETVAL= ErrorRet(  RegNotifyChangeKeyValue(
	  hKey, bWatchSubtree, iNotifyFilter, hEvent, bAsync )  );
    OUTPUT:
	RETVAL


bool
RegOpenKeyA( hKey, sSubKey, phKey )
	HKEY	hKey
	char *	sSubKey
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyA( hKey, sSubKey, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegOpenKeyW( hKey, sSubKey, phKey )
	HKEY	hKey
	WCHAR *	sSubKey
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyW( hKey, sSubKey, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegOpenKeyExA( hKey, sSubKey, iOptions, iAccess, phKey )
	HKEY	hKey
	char *	sSubKey
	DWORD	iOptions
	REGSAM	iAccess
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyExA(
	  hKey, sSubKey, iOptions, iAccess, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
RegOpenKeyExW( hKey, sSubKey, iOptions, iAccess, phKey )
	HKEY	hKey
	WCHAR *	sSubKey
	DWORD	iOptions
	REGSAM	iAccess
	HKEY *	phKey
    CODE:
	RETVAL= ErrorRet(  RegOpenKeyExW(
	  hKey, sSubKey, iOptions, iAccess, phKey )  );
    OUTPUT:
	RETVAL
	phKey


bool
_RegQueryInfoKeyA( hKey, sClass, plClass, pNull, pcSubKeys, plSubKey, plSubClass, pcValues, plValName, plValData, plSecDesc, pftTime )
	HKEY		hKey
	char *		sClass
	DWORD *		plClass
	DWORD *		pNull
	DWORD *		pcSubKeys
	DWORD *		plSubKey
	DWORD *		plSubClass
	DWORD *		pcValues
	DWORD *		plValName
	DWORD *		plValData
	DWORD *		plSecDesc
	FILETIME *	pftTime
    PREINIT:
	DWORD		iErr;
    CODE:
	grow_buf_pl( sClass,ST(1), plClass,ST(2) );
	iErr= RegQueryInfoKeyA( hKey, sClass, plClass,
	  pNull, pcSubKeys, plSubKey, plSubClass, pcValues,
	  plValName, plValData, plSecDesc, pftTime );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(2))  ) {
	    grow_buf_pl( sClass,ST(1), plClass,ST(2) );
	    iErr= RegQueryInfoKeyA( hKey, sClass, plClass,
	      pNull, pcSubKeys, plSubKey, plSubClass, pcValues,
	      plValName, plValData, plSecDesc, pftTime );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, sClass,ST(1), plClass );
    OUTPUT:
	RETVAL
	plClass
	pNull
	pcSubKeys
	plSubKey
	plSubClass
	pcValues
	plValName
	plValData
	plSecDesc
	pftTime


bool
_RegQueryInfoKeyW( hKey, sClass, plwClass, pNull, pcSubKeys, plwSubKey, plwSubClass, pcValues, plwValName, plValData, plSecDesc, pftTime )
	HKEY		hKey
	WCHAR *		sClass
	DWORD *		plwClass
	DWORD *		pNull
	DWORD *		pcSubKeys
	DWORD *		plwSubKey
	DWORD *		plwSubClass
	DWORD *		pcValues
	DWORD *		plwValName
	DWORD *		plValData
	DWORD *		plSecDesc
	FILETIME *	pftTime
    PREINIT:
    	DWORD		iErr;
    CODE:
	grow_buf_plw( sClass,ST(1), plwClass,ST(2) );
	iErr= RegQueryInfoKeyW( hKey, sClass, plwClass,
	  pNull, pcSubKeys, plwSubKey, plwSubClass, pcValues,
	  plwValName, plValData, plSecDesc, pftTime );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(2))  ) {
	    grow_buf_plw( sClass,ST(1), plwClass,ST(2) );
	    iErr= RegQueryInfoKeyW( hKey, sClass, plwClass,
	      pNull, pcSubKeys, plwSubKey, plwSubClass, pcValues,
	      plwValName, plValData, plSecDesc, pftTime );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_plw( RETVAL, sClass,ST(1), plwClass );
    OUTPUT:
	RETVAL
	plwClass
	pNull
	pcSubKeys
	plwSubKey
	plwSubClass
	pcValues
	plwValName
	plValData
	plSecDesc
	pftTime


bool
_RegQueryMultipleValuesA( hKey, pValueEnts, cValueEnts, pBuffer, plBuffer )
	HKEY	hKey
	void *	pValueEnts
	DWORD	cValueEnts
	char *	pBuffer
	DWORD *	plBuffer
    PREINIT:
	DWORD	iErr;
    CODE:
	grow_buf_pl( pBuffer,ST(3), plBuffer,ST(4) );
	iErr= RegQueryMultipleValuesA(
	  hKey, pValueEnts, cValueEnts, pBuffer, plBuffer );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(4))  ) {
	    grow_buf_pl( pBuffer,ST(3), plBuffer,ST(4) );
	    iErr= RegQueryMultipleValuesA(
	      hKey, pValueEnts, cValueEnts, pBuffer, plBuffer );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, pBuffer,ST(3), plBuffer );
    OUTPUT:
	RETVAL
	plBuffer


bool
_RegQueryMultipleValuesW( hKey, pValueEnts, cValueEnts, pBuffer, plBuffer )
	HKEY	hKey
	void *	pValueEnts
	DWORD	cValueEnts
	WCHAR *	pBuffer
	DWORD *	plBuffer
    PREINIT:
    	DWORD	iErr;
    CODE:
	grow_buf_pl( pBuffer,ST(3), plBuffer,ST(4) );
	iErr= RegQueryMultipleValuesW(
	  hKey, pValueEnts, cValueEnts, pBuffer, plBuffer );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(4))  ) {
	    grow_buf_pl( pBuffer,ST(3), plBuffer,ST(4) );
	    iErr= RegQueryMultipleValuesW(
	      hKey, pValueEnts, cValueEnts, pBuffer, plBuffer );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, pBuffer,ST(3), plBuffer );
    OUTPUT:
	RETVAL
	plBuffer


bool
_RegQueryValueA( hKey, sSubKey, sValueData, plValueData )
	HKEY	hKey
	char *	sSubKey
	char *	sValueData
	LONG *	plValueData
    PREINIT:
	DWORD	iErr;
    CODE:
	grow_buf_pl( sValueData,ST(2), plValueData,ST(3) );
	iErr= RegQueryValueA( hKey, sSubKey, sValueData, plValueData );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(3))  ) {
	    grow_buf_pl( sValueData,ST(2), plValueData,ST(3) );
	    iErr= RegQueryValueA( hKey, sSubKey, sValueData, plValueData );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, sValueData,ST(2), plValueData );
    OUTPUT:
	RETVAL
	plValueData


bool
_RegQueryValueW( hKey, sSubKey, sValueData, plValueData )
	HKEY	hKey
	WCHAR *	sSubKey
	WCHAR *	sValueData
	LONG *	plValueData
    PREINIT:
    	DWORD	iErr;
    CODE:
	grow_buf_pl( sValueData,ST(2), plValueData,ST(3) );
	iErr= RegQueryValueW( hKey, sSubKey, sValueData, plValueData );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(3))  ) {
	    grow_buf_pl( sValueData,ST(2), plValueData,ST(3) );
	    iErr= RegQueryValueW( hKey, sSubKey, sValueData, plValueData );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, sValueData,ST(2), plValueData );
    OUTPUT:
	RETVAL
	plValueData


bool
_RegQueryValueExA( hKey, sValueName, pNull, piType, pValueData, plValueData )
	HKEY	hKey
	char *	sValueName
	DWORD *	pNull
	DWORD *	piType
	BYTE *	pValueData
	DWORD *	plValueData
    PREINIT:
	DWORD	iErr;
    CODE:
	grow_buf_pl( pValueData,ST(4), plValueData,ST(5) );
	if(  NULL == piType  &&  NULL != pValueData  &&  null_arg(ST(5))  )
	    piType= (DWORD *) _alloca( sizeof(DWORD) );
	iErr= RegQueryValueExA(
	  hKey, sValueName, pNull, piType, pValueData, plValueData );
	if(  ERROR_MORE_DATA == iErr  &&  autosize(ST(5))  ) {
	    grow_buf_pl( pValueData,ST(4), plValueData,ST(5) );
	    iErr= RegQueryValueExA(
	      hKey, sValueName, pNull, piType, pValueData, plValueData );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, pValueData,ST(4), plValueData );
	/* Traim trailing '\0' from REG*_SZ values if plValueData was C<[]>: */
	if(  RETVAL  &&  NULL != pValueData  &&  NULL != piType
	 &&  ( REG_SZ == *piType || REG_EXPAND_SZ == *piType )
	 &&  null_arg(ST(5))  &&  '\0' == pValueData[*plValueData-1]  )
	    SvCUR_set( ST(4), --*plValueData );
    OUTPUT:
	RETVAL
	pNull
	piType
	plValueData


bool
_RegQueryValueExW( hKey, sValueName, pNull, piType, pValueData, plValueData )
	HKEY	hKey
	WCHAR *	sValueName
	DWORD *	pNull
	DWORD *	piType
	BYTE *	pValueData
	DWORD *	plValueData
    PREINIT:
	DWORD	iErr;
    CODE:
	grow_buf_pl( pValueData,ST(4), plValueData,ST(5) );
	if(  NULL == piType  &&  NULL != pValueData  &&  null_arg(ST(7))  )
	    piType= (DWORD *) _alloca( sizeof(DWORD) );
	iErr= RegQueryValueExW(
	  hKey, sValueName, pNull, piType, pValueData, plValueData );
	if(  ERROR_MORE_DATA == RETVAL  &&  autosize(ST(5))  ) {
	    grow_buf_pl( pValueData,ST(4), plValueData,ST(5) );
	    iErr= RegQueryValueExW(
	      hKey, sValueName, pNull, piType, pValueData, plValueData );
	}
	RETVAL= ErrorRet( iErr );
	trunc_buf_pl( RETVAL, pValueData,ST(4), plValueData );
	/* Traim trailing L'\0' from REG*_SZ values if plValueData was C<[]>: */
	if(  RETVAL  &&  NULL != pValueData  &&  NULL != piType
	 &&  ( REG_SZ == *piType || REG_EXPAND_SZ == *piType )
	 &&  null_arg(ST(5))  &&  '\0' == pValueData[*plValueData-1]  )
	    SvCUR_set( ST(4), sizeof(WCHAR)*(--*plValueData) );
    OUTPUT:
	RETVAL
	pNull
	piType
	plValueData


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
RegReplaceKeyW( hKey, sSubKey, sNewFile, sOldFile )
	HKEY	hKey
	WCHAR *	sSubKey
	WCHAR *	sNewFile
	WCHAR *	sOldFile
    CODE:
	RETVAL= ErrorRet(
	  RegReplaceKeyW( hKey, sSubKey, sNewFile, sOldFile )  );
    OUTPUT:
	RETVAL


bool
RegRestoreKeyA( hKey, sFileName, iFlags )
	HKEY	hKey
	char *	sFileName
	DWORD	iFlags
    CODE:
	RETVAL= ErrorRet(  RegRestoreKeyA( hKey, sFileName, iFlags )  );
    OUTPUT:
	RETVAL


bool
RegRestoreKeyW( hKey, sFileName, iFlags )
	HKEY	hKey
	WCHAR *	sFileName
	DWORD	iFlags
    CODE:
	RETVAL= ErrorRet(  RegRestoreKeyW( hKey, sFileName, iFlags )  );
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
RegSaveKeyW( hKey, sFileName, pSecAttr )
	HKEY			hKey
	WCHAR *			sFileName
	SECURITY_ATTRIBUTES *	pSecAttr
    CODE:
	RETVAL= ErrorRet(  RegSaveKeyW( hKey, sFileName, pSecAttr )  );
    OUTPUT:
	RETVAL


bool
RegSetKeySecurity( hKey, iSecInfo, pSecDesc )
	HKEY			hKey
	SECURITY_INFORMATION	iSecInfo
	SECURITY_DESCRIPTOR *	pSecDesc
    CODE:
	RETVAL= ErrorRet(  RegSetKeySecurity( hKey, iSecInfo, pSecDesc )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueA( hKey, sSubKey, iType, sValueData, lValueData )
	HKEY	hKey
	char *	sSubKey
	DWORD	iType
	char *	sValueData
	DWORD	lValueData
    CODE:
	if(  0 == lValueData  )
	    lValueData= SvCUR( ST(3) );
	RETVAL= ErrorRet(
	  RegSetValueA( hKey, sSubKey, iType, sValueData, lValueData )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueW( hKey, sSubKey, iType, sValueData, lValueData )
	HKEY	hKey
	WCHAR *	sSubKey
	DWORD	iType
	WCHAR *	sValueData
	DWORD	lValueData
    CODE:
	if(  0 == lValueData  )
	    lValueData= SvCUR( ST(3) ) / sizeof(WCHAR);
	RETVAL= ErrorRet(
	  RegSetValueW( hKey, sSubKey, iType, sValueData, lValueData )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueExA( hKey, sValueName, iZero, iType, pValueData, lValueData )
	HKEY	hKey
	char *	sValueName
	DWORD	iZero
	DWORD	iType
	BYTE *	pValueData
	DWORD	lValueData
    CODE:
	if(  0 == lValueData  ) {
	    lValueData= SvCUR( ST(4) );
	    if(  ( REG_SZ == iType || REG_EXPAND_SZ == iType )
	     &&  '\0' != pValueData[lValueData-1]  ) {
		sv_catpvn( ST(4), "", 1 );
		lValueData= SvCUR( ST(4) );
	    }
	}
	RETVAL= ErrorRet(  RegSetValueExA(
	  hKey, sValueName, iZero, iType, pValueData, lValueData )  );
    OUTPUT:
	RETVAL


bool
_RegSetValueExW( hKey, sValueName, iZero, iType, pValueData, lValueData )
	HKEY	hKey
	WCHAR *	sValueName
	DWORD	iZero
	DWORD	iType
	BYTE *	pValueData
	DWORD	lValueData
    CODE:
	if(  0 == lValueData  ) {
	    lValueData= SvCUR( ST(4) );
	    if(  ( REG_SZ == iType || REG_EXPAND_SZ == iType )
	     &&  L'\0' != ((WCHAR *)pValueData)[lValueData-1]  ) {
		sv_catpvn( ST(4), (char *)L"", sizeof(WCHAR) );
		lValueData= SvCUR( ST(4) ) / sizeof(WCHAR);
	    }
	}
	RETVAL= ErrorRet(  RegSetValueExW(
	  hKey, sValueName, iZero, iType, pValueData, lValueData )  );
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
RegUnLoadKeyW( hKey, sSubKey )
	HKEY	hKey
	WCHAR *	sSubKey
    CODE:
	RETVAL= ErrorRet(  RegUnLoadKeyW( hKey, sSubKey )  );
    OUTPUT:
	RETVAL
