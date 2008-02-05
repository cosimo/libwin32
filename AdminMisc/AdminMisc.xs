/*
	AdminMisc.cpp
	Original code by Hip Communications.

	Modifications by Dave Roth <rothd@roth.net> 96.05.07
	More Mods by Dave Roth <rothd@roth.net> 96.10.03

*/

/*#define WIN32_LEAN_AND_MEAN */
#define _ADMINMISC_H_

#ifdef __BORLANDC__
typedef wchar_t wctype_t; /* in tchar.h, but unavailable unless _UNICODE */
#endif

#include <stdlib.h>	// Borland braindamage
#include <math.h>	// MS braindamage
#include <windows.h>
#include <winsock.h>
#include <lmcons.h>     // LAN Manager common definitions
#include <lmerr.h>      // LAN Manager network error definitions
#include <lmUseFlg.h>
#include <lmAccess.h>
#include <lmAPIBuf.h>

#if defined(__cplusplus)
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#if defined(__cplusplus)
}
#endif

#include "AdminMisc.h"
#include "DNS.h"

	//	Set up Globals...
PHANDLE	phToken = 0;		//	handle to Token for impersonation!


// constant function for exporting NT definitions.

static long constant(char *name)
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
	break;
    case 'I':
	break;
    case 'J':
	break;
    case 'K':
	break;
    case 'L':
		
	if (strEQ(name, "LOGON32_LOGON_BATCH"))
#ifdef LOGON32_LOGON_BATCH
	    return LOGON32_LOGON_BATCH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "LOGON32_LOGON_INTERACTIVE"))
#ifdef LOGON32_LOGON_INTERACTIVE
	    return LOGON32_LOGON_INTERACTIVE;
#else
	    goto not_there;
#endif

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
	break;
    case 'S':
	break;
    case 'T':
	break;
    case 'U':
	if (strEQ(name, "UF_TEMP_DUPLICATE_ACCOUNT"))
#ifdef UF_TEMP_DUPLICATE_ACCOUNT
	    return UF_TEMP_DUPLICATE_ACCOUNT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_NORMAL_ACCOUNT"))
#ifdef UF_NORMAL_ACCOUNT
	    return UF_NORMAL_ACCOUNT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_INTERDOMAIN_TRUST_ACCOUNT"))
#ifdef UF_INTERDOMAIN_TRUST_ACCOUNT
	    return UF_INTERDOMAIN_TRUST_ACCOUNT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_WORKSTATION_TRUST_ACCOUNT"))
#ifdef UF_WORKSTATION_TRUST_ACCOUNT
	    return UF_WORKSTATION_TRUST_ACCOUNT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_SERVER_TRUST_ACCOUNT"))
#ifdef UF_SERVER_TRUST_ACCOUNT
	    return UF_SERVER_TRUST_ACCOUNT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_MACHINE_ACCOUNT_MASK"))
#ifdef UF_MACHINE_ACCOUNT_MASK
	    return UF_MACHINE_ACCOUNT_MASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_ACCOUNT_TYPE_MASK"))
#ifdef UF_ACCOUNT_TYPE_MASK
	    return UF_ACCOUNT_TYPE_MASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_DONT_EXPIRE_PASSWD"))
#ifdef UF_DONT_EXPIRE_PASSWD
	    return UF_DONT_EXPIRE_PASSWD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_SETTABLE_BITS"))
#ifdef UF_SETTABLE_BITS
	    return UF_SETTABLE_BITS;
#else
	    goto not_there;
#endif

	if (strEQ(name, "UF_SCRIPT"))
#ifdef UF_SCRIPT
	    return UF_SCRIPT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_ACCOUNTDISABLE"))
#ifdef UF_ACCOUNTDISABLE
	    return UF_ACCOUNTDISABLE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_HOMEDIR_REQUIRED"))
#ifdef UF_HOMEDIR_REQUIRED
	    return UF_HOMEDIR_REQUIRED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_LOCKOUT"))
#ifdef UF_LOCKOUT
	    return UF_LOCKOUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_PASSWD_NOTREQD"))
#ifdef UF_PASSWD_NOTREQD
	    return UF_PASSWD_NOTREQD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "UF_PASSWD_CANT_CHANGE"))
#ifdef UF_PASSWD_CANT_CHANGE
	    return UF_PASSWD_CANT_CHANGE;
#else
	    goto not_there;
#endif

	if (strEQ(name, "USE_FORCE"))
#ifdef USE_FORCE
	    return USE_FORCE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "USE_LOTS_OF_FORCE"))
#ifdef USE_LOTS_OF_FORCE
	    return USE_LOTS_OF_FORCE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "USE_NOFORCE"))
#ifdef USE_NOFORCE
	    return USE_NOFORCE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "USER_PRIV_MASK"))
#ifdef USER_PRIV_MASK
	    return USER_PRIV_MASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "USER_PRIV_GUEST"))
#ifdef USER_PRIV_GUEST
	    return USER_PRIV_GUEST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "USER_PRIV_USER"))
#ifdef USER_PRIV_USER
	    return USER_PRIV_USER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "USER_PRIV_ADMIN"))
#ifdef USER_PRIV_ADMIN
	    return USER_PRIV_ADMIN;
#else
	    goto not_there;
#endif
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

#undef malloc
#undef free
void AllocWideName(char* name, LPWSTR &lpPtr)
{
	int length;

	lpPtr = NULL;
	if(name != NULL && *name != '\0')
	{							   
		length = strlen(name) * sizeof(wctype_t) + sizeof(wctype_t);
		lpPtr = (LPWSTR)malloc(length);
		if(lpPtr != NULL)
			MultiByteToWideChar(CP_ACP, NULL, name, -1, lpPtr, length);
	}
}

inline void FreeWideName(LPWSTR lpPtr)
{
	if(lpPtr != NULL)
		free(lpPtr);
}

inline int WCTMB(LPWSTR lpwStr, LPSTR lpStr, int size)
{
	*lpStr = '\0';
	return WideCharToMultiByte(CP_ACP, NULL, lpwStr, -1, lpStr, size, NULL, NULL);
}

static DWORD lastError = 0;


XS(XS_NT__AdminMisc_GetError)
{
	dSP;
	PUSHMARK(sp);
	XPUSHs(newSViv(lastError));
	PUTBACK;
}
	//	---------------------------------------------------------------
	//		Added Features...	Dave Roth <rothd@roth.net>
void LogoffImpersonatedUser(int iSeverity){
	if (phToken != 0 || iSeverity){
		RevertToSelf();
		if(phToken){
			CloseHandle(phToken);
		}
		phToken = 0;
	}
}

XS(XS_NT__AdminMisc_GetLogonName)
{
	dXSARGS;
	char szName[128];
	unsigned long len;
	
	lastError = 0;
	if (items != 0){
		croak("Useage: Win32::AdminMisc::GetLogonName()\n");
	}

	PUSHMARK(sp);

	len = sizeof(szName);
	if(!(lastError = GetUserName((LPTSTR) szName, &len))){ 
		strcpy(szName, "");

	}else{
		XPUSHs(newSVpv(szName, strlen(szName)));
	}

	PUTBACK;
}

XS(XS_NT__AdminMisc_LogoffAsUser)
{
	dXSARGS;
	int	iSeverity = 0;

	if (items > 1)
	{
		croak("Useage: Win32::AdminMisc::LogoffAsUser()\n");
	}
	if (items){
		iSeverity = SvIV(ST(0));
	}
	LogoffImpersonatedUser(iSeverity);
	RETURNRESULT(1);
}

XS(XS_NT__AdminMisc_LogonAsUser)
{
 	dXSARGS;
	LPTSTR	szUser, szDomain, szPassword;
	DWORD dType = LOGON32_LOGON_INTERACTIVE;

	if (items > 4 || items < 3)
	{
		croak("Useage: NT::AdminMisc::LogonAsUser(domain, userName, password [, $LogonType)\n");
	}

	lastError = 0;
	szDomain = (LPTSTR) SvPV(ST(0), na);
	szUser   = (LPTSTR) SvPV(ST(1), na);
	szPassword = (LPTSTR) SvPV(ST(2), na);

	if (items == 4){
		dType = SvIV(ST(3));
	}
		//	If we are already logged on, log us out first!
	if (phToken != 0){
		LogoffImpersonatedUser(0);
	}								  
			//	Log on as the User...
	lastError = LogonUser(szUser, szDomain, szPassword, dType, LOGON32_PROVIDER_DEFAULT, (PHANDLE) &phToken);
	if (lastError == 1){
			//	Now impersonate the User...
		if (!(lastError = ImpersonateLoggedOnUser(phToken))){
			LogoffImpersonatedUser(0);
		}
	}
	RETURNRESULT(lastError == 1);
}




XS(XS_NT__AdminMisc_UserCheckPassword)
{
	dXSARGS;

	if (items != 3)
	{
		croak("Useage: NT::AdminMisc::UserCheckPassword(domain, userName, password)\n");
	}
	lastError = ChangePassword((char*)SvPV(ST(0),na),(char*)SvPV(ST(1),na), (char*)SvPV(ST(2),na), (char*)SvPV(ST(2),na)); 

	RETURNRESULT(lastError == 1);
}	

XS(XS_NT__AdminMisc_UserChangePassword)
{
	dXSARGS;

	if (items != 4)
	{
		croak("Useage: NT::AdminMisc::UserChangePassword(domain, userName, oldPassword, newPassword)\n");
	}
	lastError = ChangePassword((char*)SvPV(ST(0),na),(char*)SvPV(ST(1),na), (char*)SvPV(ST(2),na), (char*)SvPV(ST(3),na)); 

	RETURNRESULT(lastError == 1);
}		
	

int ChangePassword(char *szDomain, char *szUser, char *szOldPassword, char *szNewPassword){
	LPWSTR lpwDomain, lpwUser;
	LPWSTR lpwOldPassword, lpwNewPassword;
	int	iResult = 0;

	AllocWideName(szDomain, lpwDomain);
	AllocWideName(szUser, lpwUser);
	AllocWideName(szOldPassword, lpwOldPassword);
	AllocWideName(szNewPassword, lpwNewPassword);

	iResult = NetUserChangePassword(lpwDomain, lpwUser, lpwOldPassword, lpwNewPassword);

	FreeWideName(lpwDomain);
	FreeWideName(lpwUser);
	FreeWideName(lpwOldPassword);
	FreeWideName(lpwNewPassword);
		
	return iResult;
}

XS(XS_NT__AdminMisc_CreateProcessAsUser)
{
	dXSARGS;
	int		iResult = 1;
	char	*szCommand, *szDefaultDir = 0;
	STARTUPINFO 		stStartup;
	PROCESS_INFORMATION	stProcInfo;

		
	lastError = 0;
	if (items < 0 || items > 2){
		croak("Useage: Win32::AdminMisc::CreateProcessAsUser($CommandString [, $DefaultDirectory])\n");
	}

		//spawn
		//	PROCESS_INFORMATION stProcInfo;
		// initialize the STARTUP_INFO structure for the new process.
	stStartup.lpReserved=NULL;
	stStartup.cb = sizeof( STARTUPINFO );
	stStartup.lpDesktop = NULL;
	stStartup.lpTitle = NULL;
	stStartup.dwFlags = 0;
	stStartup.cbReserved2 = 0;
	stStartup.lpReserved2 = NULL;

	if (szCommand = new char [strlen(SvPV(ST(0), na)) + 1]){
		strcpy(szCommand, SvPV(ST(0), na));
	}else{
		iResult = 0;
	}

	if (items == 2 && iResult){
		if (szDefaultDir = new char [strlen(SvPV(ST(1), na)) + 1]){
			strcpy(szDefaultDir, SvPV(ST(1), na));
		}else{
			iResult = 0;
		}
	}

	if (phToken){
		iResult = (CreateProcessAsUser(phToken, NULL, szCommand, NULL, NULL, TRUE, NORMAL_PRIORITY_CLASS, NULL, szDefaultDir, &stStartup, &stProcInfo))? 1:0;
	}else{
		iResult = -1;
	}

	if (szCommand){
		delete szCommand;
	}
	if (szDefaultDir){
		delete szDefaultDir;
	}
	PUTBACK;
	XSRETURN(iResult);
}


	//		End of new features.
	//	---------------------------------------------------------------


XS(XS_NT__AdminMisc_constant)
{
	dXSARGS;

	if (items != 2)
	{
		croak("Usage: NT::AdminMisc::constant(name, arg)\n");
    }
	{
		char* name = (char*)SvPV(ST(0),na);
		ST(0) = sv_newmortal();
		sv_setiv(ST(0), constant(name));
	}
	XSRETURN(1);
}


//	---------------------------------------------------------------
//		Modified Features...	Dave Roth <rothd@roth.net>
	
XS(XS_NT__AdminMisc_UserGetAttributes)
{
	dXSARGS;
	char buffer[UNLEN+1];
	LPWSTR lpwServer, lpwUser;
	PUSER_INFO_2 puiUser;

	if (items != 10)
	{
		croak("Usage: NT::AdminMisc::UserGetAttributes(server, userName, userFullName, password, passwordAge,\
					privilege, homeDir, comment, flags, scriptPath)\n");
    }
	{
		AllocWideName((char*)SvPV(ST(0),na), lpwServer);
		AllocWideName((char*)SvPV(ST(1),na), lpwUser);
		lastError = NetUserGetInfo(lpwServer, lpwUser, 2, (LPBYTE*)&puiUser);
		if(lastError == 0)
		{
			WCTMB(puiUser->usri2_full_name, buffer, sizeof(buffer));
			SETPV(2, buffer);
			WCTMB(puiUser->usri2_password, buffer, sizeof(buffer));
			SETPV(3, buffer);
			SETIV(4, puiUser->usri2_password_age);
			SETIV(5, puiUser->usri2_priv);
			WCTMB(puiUser->usri2_home_dir, buffer, sizeof(buffer));
			SETPV(6, buffer);
			WCTMB(puiUser->usri2_comment, buffer, sizeof(buffer));
			SETPV(7, buffer);
			SETIV(8, puiUser->usri2_flags);
			WCTMB(puiUser->usri2_script_path, buffer, sizeof(buffer));
			SETPV(9, buffer);
		}
		FreeWideName(lpwServer);
		FreeWideName(lpwUser);

		NetApiBufferFree(puiUser);
	}
	RETURNRESULT(lastError == 0);
}

XS(XS_NT__AdminMisc_UserSetAttributes)
{
	dXSARGS;
	LPWSTR lpwServer, lpwUser;
	USER_INFO_2 uiUser;
	PUSER_INFO_2 puiUser;

	if (items != 10)
	{
		croak("Usage: NT::AdminMisc::UserSetAttributes(server, userName, userFullName, password, passwordAge,\
					privilege, homeDir, comment, flags, scriptPath)\n");
    }
	{
		
		AllocWideName((char*)SvPV(ST(0),na), lpwServer);
		AllocWideName((char*)SvPV(ST(1),na), lpwUser);
		
		lastError = NetUserGetInfo(lpwServer, lpwUser, 2, (LPBYTE*)&puiUser);
		if (lastError == 0){
			memcpy(&uiUser, puiUser, sizeof(USER_INFO_2));
			
			AllocWideName((char*)SvPV(ST(2),na), uiUser.usri2_full_name);
			AllocWideName((char*)SvPV(ST(3),na), uiUser.usri2_password);
			uiUser.usri2_password_age	= SvIV(ST(4));
			uiUser.usri2_priv			= SvIV(ST(5));
			AllocWideName((char*)SvPV(ST(6),na), uiUser.usri2_home_dir);
			AllocWideName((char*)SvPV(ST(7),na), uiUser.usri2_comment);
			uiUser.usri2_flags			= SvIV(ST(8));
			AllocWideName((char*)SvPV(ST(9),na), uiUser.usri2_script_path);
			
			lastError = NetUserSetInfo(lpwServer, lpwUser, 2, (LPBYTE)&uiUser, NULL);
				
			FreeWideName(uiUser.usri2_full_name);
			FreeWideName(uiUser.usri2_password);
			FreeWideName(uiUser.usri2_home_dir);
			FreeWideName(uiUser.usri2_comment);
			FreeWideName(uiUser.usri2_script_path);
		}
		FreeWideName(lpwUser);
		FreeWideName(lpwServer);
		NetApiBufferFree(puiUser);
	}
	RETURNRESULT(lastError == 0);
}

XS(XS_NT__AdminMisc_GetHostName)
{
	dXSARGS;
	char	*szIP = 0;
	char	*szHost = 0;

	if (items != 1)
	{
		croak("Usage: NT::AdminMisc::GetHostName($IPAddress)\n");
    }
	szIP = SvPV(ST(0),na);
	PUSHMARK(sp);
	
	if (szHost = ResolveSiteName(szIP)){
		XPUSHs(sv_2mortal(newSVpv(szHost, strlen(szHost))));
	}else{
		XPUSHs(sv_2mortal(newSVnv((double)0)));
	}

	PUTBACK;
}

XS(XS_NT__AdminMisc_GetHostAddress)
{
	dXSARGS;
	char	*szIP = 0;
	char	*szHost = 0;

	if (items != 1)
	{
		croak("Usage: NT::AdminMisc::GetHostAddress($HostName)\n");
    }
	szHost = SvPV(ST(0),na);
	PUSHMARK(sp);
	
	if (szIP = ResolveSiteName(szHost)){
		XPUSHs(sv_2mortal(newSVpv(szIP, strlen(szIP))));
	}else{
		XPUSHs(sv_2mortal(newSVnv((double)0)));
	}

	PUTBACK;
}

XS(XS_NT__AdminMisc_DNSCache)
{
	dXSARGS;
	int		iTemp = iEnableDNSCache;

	if (items > 1)
	{
		croak("Usage: NT::AdminMisc::DNSCache([1|0])\n");
    }
	if (items){
		iTemp = SvIV(ST(0));
		iEnableDNSCache = (iTemp)? 1:0;
	}
	PUSHMARK(sp);

	XPUSHs(sv_2mortal(newSVnv((double)iEnableDNSCache)));
	
	PUTBACK;
}

XS(XS_NT__AdminMisc_DNSCacheSize)
{
	dXSARGS;
	int		iTemp = iDNSCacheLimit;

	if (items > 1)
	{
		croak("Usage: $Size = Win32::AdminMisc::DNSCacheSize([$Size])\n");
    }
	if (items){
		iTemp = SvIV(ST(0));
		if (iTemp < 0){
			iTemp = 0;
		}
		iEnableDNSCache = (iTemp)? 1:0;
		ResetDNSCache();
		iDNSCacheLimit = iTemp;
	}
	PUSHMARK(sp);

	XPUSHs(sv_2mortal(newSVnv((double)iDNSCacheLimit)));
	PUTBACK;
}

XS(XS_NT__AdminMisc_DNSCacheCount)
{
	dXSARGS;
	int		iTemp = iDNSCacheLimit;

	if (items > 1)
	{
		croak("Usage: $Size = Win32::AdminMisc::DNSCacheCount()\n");
    }
	PUSHMARK(sp);

	XPUSHs(sv_2mortal(newSVnv((double)iDNSCacheCount)));

	PUTBACK;
}



#if defined(__cplusplus)
extern "C"
#endif
XS(boot_Win32__AdminMisc)
{
	dXSARGS;
	char* file = __FILE__;

	newXS("Win32::AdminMisc::constant", XS_NT__AdminMisc_constant, file);
	newXS("Win32::AdminMisc::GetError", XS_NT__AdminMisc_GetError, file);
	newXS("Win32::AdminMisc::UserGetAttributes", XS_NT__AdminMisc_UserGetAttributes, file);
	newXS("Win32::AdminMisc::UserSetAttributes", XS_NT__AdminMisc_UserSetAttributes, file);
		//	New Features...		<rothd@roth.net>
	newXS("Win32::AdminMisc::GetLogonName", XS_NT__AdminMisc_GetLogonName, file);
	newXS("Win32::AdminMisc::LogoffAsUser", XS_NT__AdminMisc_LogoffAsUser, file);
	newXS("Win32::AdminMisc::LogonAsUser", XS_NT__AdminMisc_LogonAsUser, file);
	newXS("Win32::AdminMisc::UserCheckPassword", XS_NT__AdminMisc_UserCheckPassword, file);
	newXS("Win32::AdminMisc::UserChangePassword", XS_NT__AdminMisc_UserChangePassword, file);
	newXS("Win32::AdminMisc::CreateProcessAsUser", XS_NT__AdminMisc_CreateProcessAsUser, file);

	newXS("Win32::AdminMisc::GetHostName", XS_NT__AdminMisc_GetHostName, file);
	newXS("Win32::AdminMisc::gethostbyname", XS_NT__AdminMisc_GetHostName, file);
	newXS("Win32::AdminMisc::GetHostAddress", XS_NT__AdminMisc_GetHostName, file);
	newXS("Win32::AdminMisc::gethostbyaddr", XS_NT__AdminMisc_GetHostName, file);
	newXS("Win32::AdminMisc::DNSCache", XS_NT__AdminMisc_DNSCache, file);
	newXS("Win32::AdminMisc::DNSCacheSize", XS_NT__AdminMisc_DNSCacheSize, file);
	newXS("Win32::AdminMisc::DNSCacheCount", XS_NT__AdminMisc_DNSCacheCount, file);
		//	End of new Features.
	ST(0) = &sv_yes;
	XSRETURN(1);
}

/* ===============  DLL Specific  Functions  ===================  */

BOOL WINAPI DllMain(HINSTANCE  hinstDLL, DWORD fdwReason, LPVOID  lpvReserved){
	BOOL	bResult = 1;
	switch(fdwReason){
		case DLL_PROCESS_ATTACH:
			ghDLL = hinstDLL;
				/*
					Initialize the Winsock
				*/
			if (wsErrorStatus = WSAStartup(0x0101, &wsaData)){
				iWinsockActive = 0;
			}else{
				iWinsockActive = 1;
				ResetDNSCache();
			}
			break;

		case DLL_PROCESS_DETACH:
			if (phToken){
				LogoffImpersonatedUser(0);
			}
			if (iWinsockActive){
				WSACleanup();
			}
			ResetDNSCache();
			break;

	}
	return bResult;
}


