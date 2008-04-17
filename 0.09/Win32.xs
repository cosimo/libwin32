#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

XS(w32_ExpandEnvironmentStrings)
{
    dXSARGS;
    char *lpSource;
    char buffer[2048];
    DWORD dwDataLen;

    if (items != 1)
	croak("usage: Win32::ExpandEnvironmentStrings($String);\n");

    lpSource = (char *)SvPV(ST(0), na);
    dwDataLen = ExpandEnvironmentStrings(lpSource, buffer, sizeof(buffer));

    XSRETURN_PV(buffer);
}

XS(w32_LookupAccountName)
{
    dXSARGS;
    char SID[400];
    DWORD SIDLen;
    SID_NAME_USE snu;
    char Domain[256];
    DWORD DomLen;
	
    if (items != 5)
	croak("usage: Win32::LookupAccountName($system, $account, $domain, "
	      "$sid, $sidtype);\n");

    SIDLen = sizeof(SID);
    DomLen = sizeof(Domain);
    if (LookupAccountName(SvPV(ST(0), na),	/* System */
			  SvPV(ST(1), na),	/* Account name */
			  &SID,			/* SID structure */
			  &SIDLen,		/* Size of SID buffer */
			  Domain,		/* Domain buffer */
			  &DomLen,		/* Domain buffer size */
			  &snu))		/* SID name type */
    {
	sv_setpv(ST(2), Domain);
	sv_setpvn(ST(3), SID, SIDLen);
	sv_setiv(ST(4), snu);
	XSRETURN_YES;
    }
    else {
	GetLastError();
	XSRETURN_NO;
    }
}	/* NTLookupAccountName */


XS(w32_LookupAccountSID)
{
    dXSARGS;
    PSID sid;
    char Account[256];
    DWORD AcctLen = sizeof(Account);
    char Domain[256];
    DWORD DomLen = sizeof(Domain);
    SID_NAME_USE snu;
    long retval;

    if (items != 5)
	croak("usage: Win32::LookupAccountSID($system, $sid, $account, $domain, $sidtype);\n");

    sid = SvPV(ST(1), na);
    if (IsValidSid(sid)) {
	if (LookupAccountSid(SvPV(ST(0), na),	/* System */
			     sid,		/* SID structure */
			     Account,		/* Account name buffer */
			     &AcctLen,		/* name buffer length */
			     Domain,		/* Domain buffer */
			     &DomLen,		/* Domain buffer length */
			     &snu))		/* SID name type */
	{
	    sv_setpv(ST(2), Account);
	    sv_setpv(ST(3), Domain);
	    sv_setiv(ST(4), (double) snu);
	    XSRETURN_YES;
	}
	else {
	    GetLastError();
	    XSRETURN_NO;
	}
    }
    else {
	GetLastError();
	XSRETURN_NO;
    }
}	/* NTLookupAccountSID */

XS(w32_InitiateSystemShutdown)
{
    dXSARGS;
    HANDLE hToken;              /* handle to process token   */
    TOKEN_PRIVILEGES tkp;       /* pointer to token structure  */
    BOOL bRet;
    char *machineName, *message;

    if (items != 5)
	croak("usage: Win32::InitiateSystemShutdown($machineName, $message, "
	      "$timeOut, $forceClose, $reboot);\n");

    machineName = SvPV(ST(0), na);

    if (OpenProcessToken(GetCurrentProcess(),
			 TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
			 &hToken))
    {
	LookupPrivilegeValue(machineName,
			     SE_SHUTDOWN_NAME,
			     &tkp.Privileges[0].Luid);
	tkp.PrivilegeCount = 1; /* only setting one */
	tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

	/* Get shutdown privilege for this process. */
	AdjustTokenPrivileges(hToken, FALSE, &tkp, 0,
			      (PTOKEN_PRIVILEGES)NULL, 0);
    }

    message = SvPV(ST(1), na);
    bRet = InitiateSystemShutdown(machineName, message,
				  SvIV(ST(2)), SvIV(ST(3)), SvIV(ST(4)));
    CloseHandle(hToken);

    /* Disable shutdown privilege. */
    tkp.Privileges[0].Attributes = 0; 
    AdjustTokenPrivileges(hToken, FALSE, &tkp, 0,
			  (PTOKEN_PRIVILEGES)NULL, 0); 
    XSRETURN_IV(bRet);
}

XS(w32_AbortSystemShutdown)
{
    dXSARGS;
    HANDLE hToken;              /* handle to process token   */
    TOKEN_PRIVILEGES tkp;       /* pointer to token structure  */
    BOOL bRet;
    char *machineName;

    if (items != 1)
	croak("usage: Win32::AbortSystemShutdown($machineName);\n");

    machineName = SvPV(ST(0), na);

    if (OpenProcessToken(GetCurrentProcess(),
			 TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
			 &hToken))
    {
	LookupPrivilegeValue(machineName,
			     SE_SHUTDOWN_NAME,
			     &tkp.Privileges[0].Luid);
	tkp.PrivilegeCount = 1; /* only setting one */
	tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

	/* Get shutdown privilege for this process. */
	AdjustTokenPrivileges(hToken, FALSE, &tkp, 0,
			      (PTOKEN_PRIVILEGES)NULL, 0);
    }

    bRet = AbortSystemShutdown(machineName);

    /* Disable shutdown privilege. */
    tkp.Privileges[0].Attributes = 0;
    AdjustTokenPrivileges(hToken, FALSE, &tkp, 0,
			  (PTOKEN_PRIVILEGES)NULL, 0);
    CloseHandle(hToken);
    XSRETURN_IV(bRet);
}


XS(boot_Win32)
{
    dXSARGS;
    char *file = __FILE__;

    newXS("Win32::LookupAccountName", w32_LookupAccountName, file);
    newXS("Win32::LookupAccountSID", w32_LookupAccountSID, file);
    newXS("Win32::InitiateSystemShutdown", w32_InitiateSystemShutdown, file);
    newXS("Win32::AbortSystemShutdown", w32_AbortSystemShutdown, file);
    newXS("Win32::ExpandEnvironmentStrings", w32_ExpandEnvironmentStrings, file);
    ST(0) = &sv_yes;
    XSRETURN(1);
}