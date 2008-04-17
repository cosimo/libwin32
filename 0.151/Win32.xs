#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

XS(w32_ExpandEnvironmentStrings)
{
    dXSARGS;
    char *lpSource;
    char buffer[2048];
    DWORD dwDataLen;
    STRLEN n_a;

    if (items != 1)
	croak("usage: Win32::ExpandEnvironmentStrings($String);\n");

    lpSource = (char *)SvPV(ST(0), n_a);
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
    STRLEN n_a;

    if (items != 5)
	croak("usage: Win32::LookupAccountName($system, $account, $domain, "
	      "$sid, $sidtype);\n");

    SIDLen = sizeof(SID);
    DomLen = sizeof(Domain);
    if (LookupAccountName(SvPV(ST(0), n_a),	/* System */
			  SvPV(ST(1), n_a),	/* Account name */
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
    STRLEN n_a;

    if (items != 5)
	croak("usage: Win32::LookupAccountSID($system, $sid, $account, $domain, $sidtype);\n");

    sid = SvPV(ST(1), n_a);
    if (IsValidSid(sid)) {
	if (LookupAccountSid(SvPV(ST(0), n_a),	/* System */
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
    STRLEN n_a;

    if (items != 5)
	croak("usage: Win32::InitiateSystemShutdown($machineName, $message, "
	      "$timeOut, $forceClose, $reboot);\n");

    machineName = SvPV(ST(0), n_a);

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

    message = SvPV(ST(1), n_a);
    bRet = InitiateSystemShutdown(machineName, message,
				  SvIV(ST(2)), SvIV(ST(3)), SvIV(ST(4)));

    /* Disable shutdown privilege. */
    tkp.Privileges[0].Attributes = 0; 
    AdjustTokenPrivileges(hToken, FALSE, &tkp, 0,
			  (PTOKEN_PRIVILEGES)NULL, 0); 
    CloseHandle(hToken);
    XSRETURN_IV(bRet);
}

XS(w32_AbortSystemShutdown)
{
    dXSARGS;
    HANDLE hToken;              /* handle to process token   */
    TOKEN_PRIVILEGES tkp;       /* pointer to token structure  */
    BOOL bRet;
    char *machineName;
    STRLEN n_a;

    if (items != 1)
	croak("usage: Win32::AbortSystemShutdown($machineName);\n");

    machineName = SvPV(ST(0), n_a);

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


XS(w32_MsgBox)
{
    dXSARGS;
    char *msg;
    char *title = "Perl";
    DWORD flags = MB_ICONEXCLAMATION;
    STRLEN n_a;

    if (items < 1 || items > 3)
	croak("usage: Win32::MsgBox($message [, $flags [, $title]]);\n");

    msg = SvPV(ST(0), n_a);
    if (items > 1) {
	flags = SvIV(ST(1));
	if (items > 2)
	    title = SvPV(ST(2), n_a);
    }
    XSRETURN_IV(MessageBox(GetActiveWindow(), msg, title, flags));
}

XS(w32_LoadLibrary)
{
    dXSARGS;
    STRLEN n_a;

    if (items != 1)
	croak("usage: Win32::LoadLibrary($libname)\n");
    XSRETURN_IV((long)LoadLibrary((char *)SvPV(ST(0), n_a)));
}

XS(w32_FreeLibrary)
{
    dXSARGS;
    if (items != 1)
	croak("usage: Win32::FreeLibrary($handle)\n");
    if (FreeLibrary((HINSTANCE) SvIV(ST(0)))) {
	XSRETURN_YES;
    }
    XSRETURN_NO;
}

XS(w32_GetProcAddress)
{
    dXSARGS;
    STRLEN n_a;
    if (items != 2)
	croak("usage: Win32::GetProcAddress($hinstance, $procname)\n");
    XSRETURN_IV((long)GetProcAddress((HINSTANCE)SvIV(ST(0)), SvPV(ST(1), n_a)));
}

XS(w32_RegisterServer)
{
    dXSARGS;
    BOOL result = FALSE;
    HINSTANCE hnd;
    FARPROC func;
    STRLEN n_a;

    if (items != 1)
	croak("usage: Win32::RegisterServer($libname)\n");
    hnd = LoadLibrary(SvPV(ST(0), n_a));
    if (hnd) {
	func = GetProcAddress(hnd, "DllRegisterServer");
	if (func && func() == 0)
	    result = TRUE;
	FreeLibrary(hnd);
    }
    if (result)
	XSRETURN_YES;
    else
	XSRETURN_NO;
}

XS(w32_UnregisterServer)
{
    dXSARGS;
    BOOL result = FALSE;
    HINSTANCE hnd;
    FARPROC func;
    STRLEN n_a;

    if (items != 1)
	croak("usage: Win32::UnregisterServer($libname)\n");
    hnd = LoadLibrary(SvPV(ST(0), n_a));
    if (hnd) {
	func = GetProcAddress(hnd, "DllUnregisterServer");
	if (func && func() == 0)
	    result = TRUE;
	FreeLibrary(hnd);
    }
    if (result)
	XSRETURN_YES;
    else
	XSRETURN_NO;
}

/* XXX rather bogus */
XS(w32_GetArchName)
{
    dXSARGS;
    XSRETURN_PV(getenv("PROCESSOR_ARCHITECTURE"));
}

XS(w32_GetChipName)
{
    dXSARGS;
    SYSTEM_INFO sysinfo;

    Zero(&sysinfo,1,SYSTEM_INFO);
    GetSystemInfo(&sysinfo);
    /* XXX docs say dwProcessorType is deprecated on NT */
    XSRETURN_IV(sysinfo.dwProcessorType);
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
    newXS("Win32::MsgBox", w32_MsgBox, file);
    newXS("Win32::LoadLibrary", w32_LoadLibrary, file);
    newXS("Win32::FreeLibrary", w32_FreeLibrary, file);
    newXS("Win32::GetProcAddress", w32_GetProcAddress, file);
    newXS("Win32::RegisterServer", w32_RegisterServer, file);
    newXS("Win32::UnregisterServer", w32_UnregisterServer, file);
    newXS("Win32::GetArchName", w32_GetArchName, file);
    newXS("Win32::GetChipName", w32_GetChipName, file);

    XSRETURN_YES;
}
