/*
 * This file was generated automatically by xsubpp version 1.9 from the 
 * contents of registry.xs. This file has been edited. Don't attempt to rebuild this
 * file with the XS file.
 *
 *    			 
 *
 */

/* XS interface to the Windows NT Registry
 * Written by Jesse Dougherty for Hip Communications 
 */
#define  WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Section for the constant definitions. */
#define MAX_LENGTH 2048
#define TMPBUFSZ 1024
static time_t ft2timet(FILETIME *ft)
{
    SYSTEMTIME st;
    struct tm tm;

    FileTimeToSystemTime(ft, &st);
    tm.tm_sec = st.wSecond;
    tm.tm_min = st.wMinute;
    tm.tm_hour = st.wHour;
    tm.tm_mday = st.wDay;
    tm.tm_mon = st.wMonth - 1;
    tm.tm_year = st.wYear - 1900;
    tm.tm_wday = st.wDayOfWeek;
    tm.tm_yday = -1;
    tm.tm_isdst = -1;
    return mktime (&tm);
}

#define SUCCESS(x)	(x == ERROR_SUCCESS)

#define SETIV(index,value) sv_setiv(ST(index), value)
#define SETNV(index,value) sv_setnv(ST(index), value)
#define SETPV(index,string) sv_setpv(ST(index), string)
#define SETPVN(index, buffer, length) sv_setpvn(ST(index), (char*)buffer, length)

DWORD
SetPrivilege( char *privilege, BOOL bEnable )
{
    HANDLE              hToken;
    TOKEN_PRIVILEGES    tp;
    if (!OpenProcessToken(GetCurrentProcess(),
			  TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
			  &hToken))
	return FALSE;
    if (!LookupPrivilegeValue(NULL, privilege, &tp.Privileges[0].Luid))
    {
	CloseHandle(hToken);
	return FALSE;
    }
    tp.PrivilegeCount = 1;
    if( bEnable )
	tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
    else
	tp.Privileges[0].Attributes = 0;
    if (!AdjustTokenPrivileges(hToken, FALSE, &tp, 0,
			       (PTOKEN_PRIVILEGES)NULL, 0))
    {
	CloseHandle(hToken);
	return FALSE;
    }
    if (!CloseHandle(hToken))
	return FALSE;

    return TRUE;
}


DWORD
constant(char *name, int arg)
{
    errno = 0;
    switch (*name) {
    case 'A':
	break;
    case 'B':
	break;
    case 'C':
	break;
    case 'D':
	break;
    case 'E':
	break;
    case 'F':
	break;
    case 'G':
	break;
    case 'H':
	if (strEQ(name, "HKEY_CLASSES_ROOT"))
#ifdef HKEY_CLASSES_ROOT
	    return (DWORD)HKEY_CLASSES_ROOT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "HKEY_CURRENT_USER"))
#ifdef HKEY_CURRENT_USER
	    return (DWORD)HKEY_CURRENT_USER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "HKEY_LOCAL_MACHINE"))
#ifdef HKEY_LOCAL_MACHINE
	    return (DWORD)HKEY_LOCAL_MACHINE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "HKEY_PERFORMANCE_DATA"))
#ifdef HKEY_PERFORMANCE_DATA
	    return (DWORD)HKEY_PERFORMANCE_DATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "HKEY_CURRENT_CONFIG"))
#ifdef HKEY_CURRENT_CONFIG
	    return (DWORD)HKEY_CURRENT_CONFIG;
#else
	    goto not_there;
#endif
	if (strEQ(name, "HKEY_DYN_DATA"))
#ifdef HKEY_DYN_DATA
	    return (DWORD)HKEY_DYN_DATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "HKEY_USERS"))
#ifdef HKEY_USERS
	    return (DWORD)HKEY_USERS;
#else
	    goto not_there;
#endif
	break;
    case 'I':
	break;
    case 'J':
	break;
    case 'K':
	if (strEQ(name, "KEY_ALL_ACCESS"))
#ifdef KEY_ALL_ACCESS
	    return KEY_ALL_ACCESS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_CREATE_LINK"))
#ifdef KEY_CREATE_LINK
	    return KEY_CREATE_LINK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_CREATE_SUB_KEY"))
#ifdef KEY_CREATE_SUB_KEY
	    return KEY_CREATE_SUB_KEY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_ENUMERATE_SUB_KEYS"))
#ifdef KEY_ENUMERATE_SUB_KEYS
	    return KEY_ENUMERATE_SUB_KEYS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_EXECUTE"))
#ifdef KEY_EXECUTE
	    return KEY_EXECUTE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_NOTIFY"))
#ifdef KEY_NOTIFY
	    return KEY_NOTIFY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_QUERY_VALUE"))
#ifdef KEY_QUERY_VALUE
	    return KEY_QUERY_VALUE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_READ"))
#ifdef KEY_READ
	    return KEY_READ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_SET_VALUE"))
#ifdef KEY_SET_VALUE
	    return KEY_SET_VALUE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "KEY_WRITE"))
#ifdef KEY_WRITE
	    return KEY_WRITE;
#else
	    goto not_there;
#endif
	break;
    case 'L':
	break;
    case 'M':
	break;
    case 'N':
	break;
    case 'O':
	break;
    case 'P':
	break;
    case 'Q':
	break;
    case 'R':
	if (strEQ(name, "REG_BINARY"))
#ifdef REG_BINARY
	    return REG_BINARY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_CREATED_NEW_KEY"))
#ifdef REG_CREATED_NEW_KEY
	    return REG_CREATED_NEW_KEY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_DWORD"))
#ifdef REG_DWORD
	    return REG_DWORD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_DWORD_BIG_ENDIAN"))
#ifdef REG_DWORD_BIG_ENDIAN
	    return REG_DWORD_BIG_ENDIAN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_DWORD_LITTLE_ENDIAN"))
#ifdef REG_DWORD_LITTLE_ENDIAN
	    return REG_DWORD_LITTLE_ENDIAN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_EXPAND_SZ"))
#ifdef REG_EXPAND_SZ
	    return REG_EXPAND_SZ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_FULL_RESOURCE_DESCRIPTOR"))
#ifdef REG_FULL_RESOURCE_DESCRIPTOR
	    return REG_FULL_RESOURCE_DESCRIPTOR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_LEGAL_CHANGE_FILTER"))
#ifdef REG_LEGAL_CHANGE_FILTER
	    return REG_LEGAL_CHANGE_FILTER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_LEGAL_OPTION"))
#ifdef REG_LEGAL_OPTION
	    return REG_LEGAL_OPTION;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_LINK"))
#ifdef REG_LINK
	    return REG_LINK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_MULTI_SZ"))
#ifdef REG_MULTI_SZ
	    return REG_MULTI_SZ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_NONE"))
#ifdef REG_NONE
	    return REG_NONE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_NOTIFY_CHANGE_ATTRIBUTES"))
#ifdef REG_NOTIFY_CHANGE_ATTRIBUTES
	    return REG_NOTIFY_CHANGE_ATTRIBUTES;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_NOTIFY_CHANGE_LAST_SET"))
#ifdef REG_NOTIFY_CHANGE_LAST_SET
	    return REG_NOTIFY_CHANGE_LAST_SET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_NOTIFY_CHANGE_NAME"))
#ifdef REG_NOTIFY_CHANGE_NAME
	    return REG_NOTIFY_CHANGE_NAME;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_NOTIFY_CHANGE_SECURITY"))
#ifdef REG_NOTIFY_CHANGE_SECURITY
	    return REG_NOTIFY_CHANGE_SECURITY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_OPENED_EXISTING_KEY"))
#ifdef REG_OPENED_EXISTING_KEY
	    return REG_OPENED_EXISTING_KEY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_OPTION_BACKUP_RESTORE"))
#ifdef REG_OPTION_BACKUP_RESTORE
	    return REG_OPTION_BACKUP_RESTORE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_OPTION_CREATE_LINK"))
#ifdef REG_OPTION_CREATE_LINK
	    return REG_OPTION_CREATE_LINK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_OPTION_NON_VOLATILE"))
#ifdef REG_OPTION_NON_VOLATILE
	    return REG_OPTION_NON_VOLATILE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_OPTION_RESERVED"))
#ifdef REG_OPTION_RESERVED
	    return REG_OPTION_RESERVED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_OPTION_VOLATILE"))
#ifdef REG_OPTION_VOLATILE
	    return REG_OPTION_VOLATILE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_REFRESH_HIVE"))
#ifdef REG_REFRESH_HIVE
	    return REG_REFRESH_HIVE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_RESOURCE_LIST"))
#ifdef REG_RESOURCE_LIST
	    return REG_RESOURCE_LIST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_RESOURCE_REQUIREMENTS_LIST"))
#ifdef REG_RESOURCE_REQUIREMENTS_LIST
	    return REG_RESOURCE_REQUIREMENTS_LIST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_SZ"))
#ifdef REG_SZ
	    return REG_SZ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "REG_WHOLE_HIVE_VOLATILE"))
#ifdef REG_WHOLE_HIVE_VOLATILE
	    return REG_WHOLE_HIVE_VOLATILE;
#else
	    goto not_there;
#endif
	break;
    case 'S':
	break;
    case 'T':
	break;
    case 'U':
	break;
    case 'V':
	break;
    case 'W':
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

MODULE = Win32::Registry	PACKAGE = Win32::Registry

PROTOTYPES: DISABLE

# modified RegSaveKey that uses a NULL security_descriptor.

long
constant(name,arg)
	char *name
	int arg
    CODE:
	RETVAL = constant(name, arg);
    OUTPUT:
	RETVAL

bool
RegCloseKey(handle)
	HKEY handle
    CODE:
	RETVAL = SUCCESS(RegCloseKey(handle));
    OUTPUT:
	RETVAL

bool
RegConnectRegistry(machine,hkey,ohandle)
	char *machine
	HKEY hkey
	HKEY ohandle = NO_INIT
    CODE:
	RETVAL = SUCCESS(RegConnectRegistry(machine, hkey, &ohandle));
    OUTPUT:
	RETVAL
	ohandle

bool
RegCreateKey(hkey,subkey,ohandle)
	HKEY hkey
	char *subkey
	HKEY ohandle = NO_INIT
    CODE:
	DWORD disposition;
	RETVAL =  SUCCESS(RegCreateKeyEx(hkey, subkey, 0, NULL,
					 REG_OPTION_NON_VOLATILE,
					 KEY_ALL_ACCESS,
					 NULL, &ohandle, &disposition));
   OUTPUT:
	RETVAL
	ohandle


bool
RegCreateKeyEx(hkey,subkey,res,kclass,options,sam,security,ohandle,disposition)
	HKEY hkey
	char *subkey
	SV *res = NO_INIT
	char *kclass
	DWORD options
	REGSAM sam
	SV *security
	HKEY ohandle = NO_INIT
	DWORD disposition = NO_INIT
    CODE:
	unsigned sa_len;
	SECURITY_ATTRIBUTES *psa = (SECURITY_ATTRIBUTES *)SvPV(security,sa_len);
	SECURITY_ATTRIBUTES sa;
	if (sa_len != sizeof(SECURITY_ATTRIBUTES)) {
	    psa = &sa;
	    memset(&sa, 0, sizeof(SECURITY_ATTRIBUTES));
	    sa.nLength = sizeof(SECURITY_ATTRIBUTES);
	}
	RETVAL = SUCCESS(RegCreateKeyEx(hkey, subkey, 0, kclass,
					options, sam, psa, &ohandle,
					&disposition));
   OUTPUT:
	RETVAL
	ohandle
	disposition

bool
RegDeleteKey(hkey,subkey)
	HKEY hkey
	char *subkey
    CODE:
	RETVAL = SUCCESS(RegDeleteKey(hkey, subkey));
    OUTPUT:
	RETVAL

bool
RegDeleteValue(hkey,valname)
	HKEY hkey
	char *valname
    CODE:
	RETVAL = SUCCESS(RegDeleteValue(hkey, valname));
    OUTPUT:
	RETVAL

bool
RegEnumKey(hkey,idx,subkey)
	HKEY hkey
	DWORD idx
	char *subkey = NO_INIT
    CODE:
	char keybuffer[TMPBUFSZ];
	RETVAL = SUCCESS(RegEnumKey(hkey, idx, keybuffer, sizeof(keybuffer)));
    OUTPUT:
	RETVAL
	subkey		if (RETVAL) { SETPV(2, keybuffer); }

bool
RegEnumValue(hkey,idx,name,reserved,type,value)
	HKEY hkey
	DWORD idx
	char *name = NO_INIT
	DWORD reserved = NO_INIT
	DWORD type = NO_INIT
	char *value = NO_INIT
    CODE:
	static HKEY last_hkey;
	char  myvalbuf[MAX_LENGTH];
	char  mynambuf[MAX_LENGTH];
	DWORD namesz, valsz;

	/* If this is a new key, find out how big the maximum name and value
	 * sizes are and allocate space for them. Free any old storage and
	 * set the old key value to the current key.
	 */
	if(hkey != (HKEY)last_hkey) {
	    char keyclass[TMPBUFSZ];
	    DWORD classsz, subkeys, maxsubkey, maxclass, maxnamesz;
	    DWORD maxvalsz, values, salen;
	    FILETIME ft;
	    classsz = sizeof(keyclass);
	    RETVAL = SUCCESS(RegQueryInfoKey(hkey, keyclass, &classsz, 0,
					     &subkeys, &maxsubkey, &maxclass,
					     &values, &maxnamesz,&maxvalsz,
					     &salen, &ft));
	    if (!RETVAL)
		XSRETURN_NO;
	    
	    memset( myvalbuf,0,MAX_LENGTH );
	    memset( mynambuf,0,MAX_LENGTH );
	}
	last_hkey = hkey;
	namesz = MAX_LENGTH;
	valsz = MAX_LENGTH;
	RETVAL = SUCCESS(RegEnumValue(hkey, idx, mynambuf, &namesz, 0,
				      &type, (LPBYTE) myvalbuf, &valsz));
	if (RETVAL) {
	    SETPV(2, mynambuf);
	    SETIV(4, type);
	    /* return includes the null terminator so delete it if REG_SZ,
	       REG_MULTI_SZ or REG_EXPAND_SZ */
	    switch (type) {
	    case REG_SZ:
	    case REG_MULTI_SZ:
	    case REG_EXPAND_SZ:
		if(valsz)
		    --valsz;
		/* FALL THROUGH */
	    case REG_BINARY:
	        SETPVN(5, myvalbuf, valsz);
		break;
	    case REG_DWORD_BIG_ENDIAN:
		{
		    BYTE tmp = myvalbuf[0];
		    myvalbuf[0] = myvalbuf[3];
		    myvalbuf[3] = tmp;
		    tmp = myvalbuf[1];
		    myvalbuf[1] = myvalbuf[2];
		    myvalbuf[2] = tmp;
		}
		/* FALL THROUGH */
	    case REG_DWORD_LITTLE_ENDIAN:
		SETNV(5, (double)*((DWORD*)myvalbuf));
		break;
	    default:
		break;
	    }
	}
    OUTPUT:
	RETVAL

bool
RegFlushKey(hkey)
	HKEY hkey
    CODE:
	RETVAL = SUCCESS(RegFlushKey(hkey));
    OUTPUT:
	RETVAL


bool
RegGetKeySecurity(hkey,sec_info,sec_desc)
	HKEY hkey
	DWORD sec_info
	char *sec_desc = NO_INIT
    CODE:
	SECURITY_DESCRIPTOR sd;
	DWORD sdsz;
	RETVAL = SUCCESS(RegGetKeySecurity(hkey, sec_info, &sd, &sdsz));
	if (RETVAL)
	    SETPVN(2, &sd, sdsz);
    OUTPUT:
	RETVAL

bool
RegLoadKey(hkey,subkey,filename)
	HKEY hkey
	char *subkey
	char *filename
    CODE:
	DWORD		    dwLastError;
	if (!SetPrivilege(SE_RESTORE_NAME, TRUE))
	    XSRETURN_NO;
	dwLastError = RegLoadKey(hkey, subkey, filename);
	SetPrivilege(SE_RESTORE_NAME, FALSE);
	RETVAL = SUCCESS(dwLastError);
    OUTPUT:
	RETVAL

bool
RegNotifyChangeKeyValue(hkey,watch_subtree,notify_filt,evt,async_flag)
	HKEY hkey
	bool watch_subtree
	DWORD notify_filt
	HANDLE evt
	bool async_flag
    CODE:
	RETVAL = SUCCESS(RegNotifyChangeKeyValue(hkey, watch_subtree,
						 notify_filt, evt, async_flag));
    OUTPUT:
	RETVAL

bool
RegOpenKey(hkey,subkey,ohandle)
	HKEY hkey
	char *subkey
	HKEY ohandle = NO_INIT
    CODE:
	RETVAL = SUCCESS(RegOpenKey(hkey, subkey, &ohandle));
    OUTPUT:
	RETVAL
	ohandle

bool
RegOpenKeyEx(hkey,subkey,res,sam,ohandle)
	HKEY hkey
	char *subkey
	SV *res = NO_INIT
	REGSAM sam
	HKEY ohandle = NO_INIT
    CODE:
	RETVAL = SUCCESS(RegOpenKeyEx(hkey, subkey, 0, sam, &ohandle));
    OUTPUT:
	RETVAL
	ohandle

bool
RegQueryInfoKey(hkey,kclass,classsz,reserved,numsubkeys,maxsubkeylen,maxclasslen,numvalues,maxvalnamelen,maxvaldatalen,secdesclen,lastwritetime)
	HKEY hkey
	char *kclass = NO_INIT
	DWORD classsz = NO_INIT
	DWORD reserved = NO_INIT
	DWORD numsubkeys = NO_INIT
	DWORD maxsubkeylen = NO_INIT
	DWORD maxclasslen = NO_INIT
	DWORD numvalues = NO_INIT
	DWORD maxvalnamelen = NO_INIT
	DWORD maxvaldatalen = NO_INIT
	DWORD secdesclen = NO_INIT
	FILETIME lastwritetime = NO_INIT
    CODE:
	char keyclass[TMPBUFSZ];
	FILETIME ft;
	classsz = sizeof(keyclass);
	RETVAL = SUCCESS(RegQueryInfoKey(hkey, keyclass, &classsz, 0,
					 &numsubkeys, &maxsubkeylen,
					 &maxclasslen, &numvalues,
					 &maxvalnamelen, &maxvaldatalen,
					 &secdesclen, &ft));
    OUTPUT:
	RETVAL
	kclass			SETPV(1, keyclass);
	numsubkeys
	maxsubkeylen
	maxclasslen
	numvalues
	maxvalnamelen
	maxvaldatalen
	secdesclen
	lastwritetime		if (RETVAL) { ft2timet(&ft); }
	

bool
RegQueryValue(hkey,valuename,data)
	HKEY hkey
	char *valuename
	SV *data
    CODE:
	unsigned char databuffer[TMPBUFSZ*2];
	DWORD datasz = sizeof(databuffer);
	RETVAL = SUCCESS(RegQueryValue(hkey, valuename, (char*)databuffer,
				       (PLONG)&datasz));
	/* return includes the null terminator so delete it */
    OUTPUT:
	RETVAL
	data			if (RETVAL) { SETPVN(2, databuffer, --datasz); }


bool
RegQueryValueEx(hkey,valuename,reserved,type,data)
	HKEY hkey
	char *valuename
	SV *reserved = NO_INIT
	DWORD type = NO_INIT
	SV *data
    CODE:
	unsigned char databuffer[TMPBUFSZ*2];
	LPBYTE ptr = databuffer;
	DWORD datasz = sizeof(databuffer);
	LONG result = RegQueryValueEx(hkey, valuename, NULL, &type,
				      ptr, &datasz);
	if (result == ERROR_MORE_DATA) {
	    New(0, ptr, datasz+1, BYTE); 
	    result = RegQueryValueEx(hkey, valuename, NULL, &type,
				     ptr, &datasz);
	}
	/* return includes the null terminator so delete it if
	 * REG_SZ, REG_MULTI_SZ or REG_EXPAND_SZ */
	if (SUCCESS(result)) {
	    SETIV(3, type);

	    switch (type) {
	    case REG_SZ:
	    case REG_MULTI_SZ:
	    case REG_EXPAND_SZ:
		if (datasz)
		    --datasz;
		/* FALL THROUGH */
	    case REG_BINARY:
		SETPVN(4, ptr, datasz);
		break;
	    case REG_DWORD_BIG_ENDIAN:
		{
		    BYTE tmp = ptr[0];
		    ptr[0] = ptr[3];
		    ptr[3] = tmp;
		    tmp = ptr[1];
		    ptr[1] = ptr[2];
		    ptr[2] = tmp;
		}
		/* FALL THROUGH */
	    case REG_DWORD_LITTLE_ENDIAN:
		SETNV(4, (double) *((DWORD*)ptr));
		break;
	    default:
		break;
	    }
	}
	if (ptr != databuffer)
	    Safefree(ptr);
	RETVAL = SUCCESS(result);
    OUTPUT:
	RETVAL

bool
RegReplaceKey(hkey,subkey,newfile,oldfile)
	HKEY hkey
	char *subkey
	char *newfile
	char *oldfile
    CODE:
	DWORD dwLastError;
	if (!SetPrivilege(SE_RESTORE_NAME, TRUE))
	    XSRETURN_NO;
	dwLastError = RegReplaceKey(hkey, subkey, newfile, oldfile);
	SetPrivilege(SE_RESTORE_NAME, FALSE);
	RETVAL = SUCCESS(dwLastError);
    OUTPUT:
	RETVAL

bool
RegRestoreKey(hkey,filename, ...)
	HKEY hkey
	char *filename
    PREINIT:
	DWORD flags = 0;
    CODE:
	DWORD dwLastError;
	if (items > 2) flags = SvIV(ST(2));
	if (!SetPrivilege(SE_RESTORE_NAME, TRUE))
	    XSRETURN_NO;
	dwLastError = RegRestoreKey(hkey, filename, flags);
	SetPrivilege(SE_RESTORE_NAME, FALSE);
	RETVAL = SUCCESS(dwLastError);
    OUTPUT:
	RETVAL

bool
RegSaveKey(hkey,filename)
	HKEY hkey
	char *filename
    CODE:
	DWORD dwLastError;
	if (!SetPrivilege(SE_BACKUP_NAME, TRUE))
	    XSRETURN_NO;
	dwLastError = RegSaveKey(hkey, filename, NULL);
	SetPrivilege(SE_BACKUP_NAME, FALSE);
	RETVAL = SUCCESS(dwLastError);
    OUTPUT:
	RETVAL


bool
RegSetKeySecurity(hkey,sec_info,sec_desc)
	HKEY hkey
	DWORD sec_info
	char *sec_desc
    CODE:
	RETVAL = SUCCESS(RegSetKeySecurity(hkey, sec_info,
					   (SECURITY_DESCRIPTOR*)sec_desc));
    OUTPUT:
	RETVAL

bool
RegSetValue(hkey,subkey,type,data)
	HKEY hkey
	char *subkey
	DWORD type
	SV *data
    CODE:
	unsigned int size;
	char *buffer;
	if(type != REG_SZ)
		croak("Type was not REG_SZ, cannot set %s\n", subkey);
	buffer = SvPV(data, size);
	RETVAL = SUCCESS(RegSetValue(hkey, subkey, REG_SZ, buffer, size));
    OUTPUT:
	RETVAL

bool
RegSetValueEx(hkey,valname,reserved,type,data)
	HKEY hkey
	char *valname
	DWORD reserved = NO_INIT
	DWORD type
	SV *data
    CODE:
	DWORD val;
	unsigned int size;
	char *buffer;
	switch (type) 
	{
		case REG_NONE:
		case REG_SZ:
		case REG_MULTI_SZ:
		case REG_EXPAND_SZ:
		case REG_BINARY:
		    buffer = SvPV(data, size);
		    if (type != REG_BINARY)
			size++;		/* include null terminator in size */
		    RETVAL = SUCCESS(RegSetValueEx(hkey,valname,0,type,
						   (PBYTE) buffer, size));
		    break;
		case REG_DWORD_BIG_ENDIAN:
		case REG_DWORD_LITTLE_ENDIAN: /* Same as REG_DWORD */
		    val = (DWORD) SvIV(data);
		    RETVAL = SUCCESS(RegSetValueEx(hkey,valname, 0, type,
						   (PBYTE)&val, sizeof(DWORD)));
		    break;
		default:
			croak("Type not supported, cannot set %s\n", valname);
	}
    OUTPUT:
	RETVAL

bool
RegUnLoadKey(hkey, subkey)
	HKEY hkey
	char *subkey
    CODE:
	RETVAL = SUCCESS(RegUnLoadKey(hkey, subkey));
    OUTPUT:
	RETVAL


