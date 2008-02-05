/*
 * XS interface to the Windows NT EventLog
 * Written by Jesse Dougherty for hip communications
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "../ppport.h"

#define SETIV(index,value) sv_setiv(ST(index),value)
#define SETPV(index,string) sv_setpv(ST(index),string)
#define SETPVN(index, buffer, length) sv_setpvn(ST(index),(char*)buffer,length)

/* Modified calls go here. */

/* Revamped ReportEvent that doesn't use SIDs. */
typedef struct _EvtLogCtlBuf
{
    DWORD  dwID;			/* id for mem block */
    HANDLE hLog;			/* event log handle */
    BOOL   wideEntries;			/* has unicode character entries */
    LPBYTE BufPtr;			/* pointer to data buffer */
    DWORD  BufLen;			/* size of buffer */
    DWORD  NumEntries;			/* number of entries in buffer */
    DWORD  CurEntryNum;			/* next entry to return */
    EVENTLOGRECORD *CurEntry;		/* point to next entry to return */
    DWORD  Flags;			/* read flags for ReadEventLog */
} EvtLogCtlBuf, *lpEvtLogCtlBuf;

#define EVTLOGBUFSIZE 1024
#define EVTLOGID ((DWORD)0x674c7645L)
#define SVE(x)   (lpEvtLogCtlBuf)(x)

/* constant function for exporting NT definitions for Eventlogs. */

static double
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
    if (strEQ(name, "EVENTLOG_AUDIT_FAILURE"))
#ifdef EVENTLOG_AUDIT_FAILURE
        return EVENTLOG_AUDIT_FAILURE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_AUDIT_SUCCESS"))
#ifdef EVENTLOG_AUDIT_SUCCESS
        return EVENTLOG_AUDIT_SUCCESS;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_BACKWARDS_READ"))
#ifdef EVENTLOG_BACKWARDS_READ
        return EVENTLOG_BACKWARDS_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_END_ALL_PAIRED_EVENTS"))
#ifdef EVENTLOG_END_ALL_PAIRED_EVENTS
        return EVENTLOG_END_ALL_PAIRED_EVENTS;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_END_PAIRED_EVENT"))
#ifdef EVENTLOG_END_PAIRED_EVENT
        return EVENTLOG_END_PAIRED_EVENT;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_ERROR_TYPE"))
#ifdef EVENTLOG_ERROR_TYPE
        return EVENTLOG_ERROR_TYPE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_FORWARDS_READ"))
#ifdef EVENTLOG_FORWARDS_READ
        return EVENTLOG_FORWARDS_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_INFORMATION_TYPE"))
#ifdef EVENTLOG_INFORMATION_TYPE
        return EVENTLOG_INFORMATION_TYPE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_PAIRED_EVENT_ACTIVE"))
#ifdef EVENTLOG_PAIRED_EVENT_ACTIVE
        return EVENTLOG_PAIRED_EVENT_ACTIVE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_PAIRED_EVENT_INACTIVE"))
#ifdef EVENTLOG_PAIRED_EVENT_INACTIVE
        return EVENTLOG_PAIRED_EVENT_INACTIVE;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_SEEK_READ"))
#ifdef EVENTLOG_SEEK_READ
        return EVENTLOG_SEEK_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_SEQUENTIAL_READ"))
#ifdef EVENTLOG_SEQUENTIAL_READ
        return EVENTLOG_SEQUENTIAL_READ;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_START_PAIRED_EVENT"))
#ifdef EVENTLOG_START_PAIRED_EVENT
        return EVENTLOG_START_PAIRED_EVENT;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_SUCCESS"))
#ifdef EVENTLOG_SUCCESS
        return EVENTLOG_SUCCESS;
#else
        goto not_there;
#endif
    if (strEQ(name, "EVENTLOG_WARNING_TYPE"))
#ifdef EVENTLOG_WARNING_TYPE
        return EVENTLOG_WARNING_TYPE;
#else
        goto not_there;
#endif
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

MODULE = Win32::EventLog	PACKAGE = Win32::EventLog

PROTOTYPES: DISABLE

bool
WriteEventLog(server, source, eventType, category, eventID, reserved, data, ...)
    char *server
    char *source
    DWORD eventType
    DWORD category
    DWORD eventID
    DWORD reserved = NO_INIT
    char *data = NO_INIT
CODE:
{
    unsigned int bufLength, dataLength, index;
    char *buffer, **array;
    LPWSTR *warray, pwChar;
    HANDLE hLog;

    RETVAL = FALSE;

    if (server && *server == '\0')
        server = NULL;

    if (USING_WIDE()) {
	int length;
	WCHAR* pwServer = NULL, *pwSource;
	if (server) {
	    length = strlen(server)+1;
	    New(0, pwServer, length, WCHAR);
	    A2WHELPER(server, pwServer, length*sizeof(WCHAR));
	}
	length = strlen(source)+1;
	New(0, pwSource, length, WCHAR);
	A2WHELPER(source, pwSource, length*sizeof(WCHAR));
	hLog = RegisterEventSourceW(pwServer, pwSource);
	Safefree(pwServer);
	Safefree(pwSource);
    }
    else {
	hLog = RegisterEventSourceA(server, source);
    }
    if (hLog != NULL) {
	data = SvPV(ST(5), dataLength);
	if (USING_WIDE()) {
	    New(3101, warray, items - 6, LPWSTR);
	    for (index = 0; index < items - 6; ++index) {
		buffer = SvPV(ST(index+6), bufLength);
		New(0, pwChar, bufLength+1, WCHAR);
		A2WHELPER(buffer, pwChar, (bufLength+1)*sizeof(WCHAR));
		warray[index] = pwChar;
	    }
	    RETVAL = ReportEventW(
                hLog,                  /* handle returned by RegisterEventSource */
                SvIV(ST(2)),           /* event type to log */
                SvIV(ST(3)),           /* event category */
                SvIV(ST(4)),           /* event identifier */
                NULL,                  /* user security identifier (optional) */
                items - 6,             /* number of strings to merge with message */
                dataLength,            /* size of raw (binary) data (in bytes) */
                (const WCHAR**)warray, /* array of strings to merge with message */
                data                   /* address of binary data */
		);
	    for (index = 0; index < items - 6; ++index) {
		Safefree(warray[index]);
	    }
	    Safefree(warray);
	}
	else {
	    New(3101, array, items - 6, char*);
	    for (index = 0; index < items - 6; ++index) {
		buffer = SvPV(ST(index+6), bufLength);
		array[index] = buffer;
	    }
	    RETVAL = ReportEventA(
                hLog,                /* handle returned by RegisterEventSource */
                SvIV(ST(2)),         /* event type to log */
                SvIV(ST(3)),         /* event category */
                SvIV(ST(4)),         /* event identifier */
                NULL,                /* user security identifier (optional) */
                items - 6,           /* number of strings to merge with message */
                dataLength,          /* size of raw (binary) data (in bytes) */
                (const char**)array, /* array of strings to merge with message */
                data                 /* address of binary data */
		);
	    Safefree(array);
	}
	DeregisterEventSource(hLog);
    }
}
OUTPUT:
    RETVAL

bool
ReadEventLog(handle,Flags,Record,evtHeader,sourceName,computerName,sid,data,strings)
    U32 handle
    DWORD Flags
    DWORD Record
    char *evtHeader = NO_INIT
    char *sourceName = NO_INIT
    char *computerName = NO_INIT
    char *sid = NO_INIT
    char *data = NO_INIT
    char *strings = NO_INIT
CODE:
{
    int length;
    lpEvtLogCtlBuf lpEvtLog;
    BOOL result;
    RETVAL = FALSE;

    lpEvtLog = SVE(handle);
    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID)) {
	DWORD NumRead, Required;
	long retval;
	if (Flags != lpEvtLog->Flags) {
	    /* Reset to new read mode & force a re-read call */
	    lpEvtLog->Flags      = Flags;
	    lpEvtLog->NumEntries = 0;
	}
	if ((lpEvtLog->NumEntries == 0) || (Record != 0)) {
	redo_read:
	    if (USING_WIDE()) {
		result = ReadEventLogW(lpEvtLog->hLog, Flags, Record,
				       lpEvtLog->BufPtr, lpEvtLog->BufLen,
				       &NumRead, &Required);
		lpEvtLog->wideEntries = TRUE;
	    }
	    else {
		result = ReadEventLogA(lpEvtLog->hLog, Flags, Record,
				       lpEvtLog->BufPtr, lpEvtLog->BufLen,
				       &NumRead, &Required);
		lpEvtLog->wideEntries = FALSE;
	    }

	    if (result)
		lpEvtLog->NumEntries = NumRead;
	    else {
		lpEvtLog->NumEntries = 0;
		if (Required > lpEvtLog->BufLen
		    && GetLastError() == ERROR_INSUFFICIENT_BUFFER)
		{
		    lpEvtLog->BufLen = Required*2;
		    Renew(lpEvtLog->BufPtr, lpEvtLog->BufLen, BYTE);
		    goto redo_read;
		}
	    }
	    lpEvtLog->CurEntryNum = 0;
	    lpEvtLog->CurEntry    = (EVENTLOGRECORD*)lpEvtLog->BufPtr;
	}

	if (lpEvtLog->CurEntryNum < lpEvtLog->NumEntries) {
	    EVENTLOGRECORD *LogBuf;
	    LogBuf = lpEvtLog->CurEntry;
	    SETPVN(3, (char*)LogBuf, LogBuf->Length);
	    if (lpEvtLog->wideEntries) {
		LPWSTR pwStr;
		char szBuffer[MAX_PATH+1];
		pwStr = (LPWSTR)(((LPSTR)LogBuf)+sizeof(EVENTLOGRECORD));
		W2AHELPER(pwStr, szBuffer, sizeof(szBuffer));
		SETPV(4, szBuffer);
		pwStr += lstrlenW(pwStr)+1; /* step over NULL */
		W2AHELPER(pwStr, szBuffer, sizeof(szBuffer));
		SETPV(5, szBuffer);
	    }
	    else {
		char *name;
		name = ((LPSTR)LogBuf)+sizeof(EVENTLOGRECORD);
		SETPV(4, name);
		name += strlen(name)+1; /* step over NULL */
		SETPV(5, name);
	    }
	    SETPVN(6, ((LPBYTE)LogBuf)+LogBuf->UserSidOffset, LogBuf->UserSidLength);
	    SETPVN(7, ((LPBYTE)LogBuf)+LogBuf->DataOffset, LogBuf->DataLength);
	    if (lpEvtLog->wideEntries) {
		char* ptr = NULL;
		// calculate the length of the strings
		length = LogBuf->DataOffset-LogBuf->StringOffset;
		if (length) {
		    New(0, ptr, length, char);
                    length = W2AHELPER_LEN((LPWSTR)(((LPBYTE)LogBuf)+LogBuf->StringOffset),
                                           length/sizeof(WCHAR), ptr, length);
		}
		if (length)
		    SETPVN(8, ptr, length-1);
		else
		    SvOK_off(ST(8));
		Safefree(ptr);
	    }
	    else
		SETPVN(8, ((LPBYTE)LogBuf)+LogBuf->StringOffset, LogBuf->DataOffset-LogBuf->StringOffset);

	    /* to next entry in buffer */
	    lpEvtLog->CurEntryNum += LogBuf->Length;
	    lpEvtLog->CurEntry = (EVENTLOGRECORD*)(((LPBYTE)LogBuf) + LogBuf->Length);
	    if (lpEvtLog->CurEntryNum == lpEvtLog->NumEntries) {
		lpEvtLog->NumEntries  = 0;
		lpEvtLog->CurEntryNum = 0;
		lpEvtLog->CurEntry    = NULL;
	    }
	    RETVAL = TRUE;
	}
    }
}
OUTPUT:
    RETVAL

bool
GetEventLogText(source,id,longstring,numstrings,message)
    char *source
    DWORD id
    char *longstring
    int numstrings
    char *message = NO_INIT
CODE:
{
    HINSTANCE dll = NULL;
    HKEY hk;
    int length = SvCUR(ST(2))+1;

    /* XXX TODO:
     * XXX ParameterMessageFile can also be a semicolon separated list of files
     * XXX What about expanding the category id to a string?
     * XXX Determining the log category is kind of bogus!
     * XXX This should have been a parameter.
     */

    if (USING_WIDE()) {
	static const WCHAR *wEVFILE[] = {L"System", L"Security", L"Application"};
	WCHAR *ptr, *tmpx;
	WCHAR wmsgfile[MAX_PATH], wregPath[MAX_PATH], **wstrings;
	WCHAR wsource[MAX_PATH+1], *wMsgBuf, *wlongstring;
        WCHAR *wmessage = NULL;
	char *MsgBuf;
	DWORD i, id2, maxinsert;
	BOOL result;
	LONG lResult;
	unsigned short j;
	WCHAR *percent;
	int percentLen, msgLen;

        A2WHELPER(source, wsource, sizeof(wsource));

	for (j=0; j < (sizeof(wEVFILE)/sizeof(wEVFILE[0])); j++) {
	    swprintf(wregPath,
		     L"SYSTEM\\CurrentControlSet\\Services\\EventLog\\%s\\%s",
		     wEVFILE[j], wsource);
	    if (RegOpenKeyExW(HKEY_LOCAL_MACHINE, wregPath,
			      0, KEY_READ, &hk) == ERROR_SUCCESS)
	    {
		break;
	    }
	}

	if (j >= (sizeof(wEVFILE)/sizeof(wEVFILE[0])))
	    XSRETURN_NO;

        /* Get the (list of) message file(s) for this entry */
	i = sizeof(wregPath);
	lResult = RegQueryValueExW(hk, L"EventMessageFile", 0, 0,
				   (unsigned char *)wregPath, &i);
	if (lResult != ERROR_SUCCESS) {
            RegCloseKey(hk);
	    XSRETURN_NO;
        }

	if (ExpandEnvironmentStringsW(wregPath, wmsgfile, sizeof(wmsgfile)) == 0) {
            RegCloseKey(hk);
	    XSRETURN_NO;
        }

        /* Try to retrieve message *without* expanding the inserts yet */
        ptr = wmsgfile;
        while (ptr && !wmessage) {
            WCHAR *semi = wcschr(ptr, L';');
            if (semi)
                *semi++ = '\0';
            dll = LoadLibraryExW(ptr, 0, LOAD_LIBRARY_AS_DATAFILE);
            if (dll) {
                FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER |
                               FORMAT_MESSAGE_FROM_HMODULE    |
                               FORMAT_MESSAGE_IGNORE_INSERTS,
                               dll, id, 0, (LPWSTR)&wmessage, 0, NULL);
                FreeLibrary(dll);
            }
            ptr = semi;
        }
	if (!wmessage) {
            RegCloseKey(hk);
	    XSRETURN_NO;
        }

        /* Determine higest %n insert number */
        maxinsert = numstrings;
        ptr = wmessage;
        while ((percent=wcschr(ptr, L'%'))
               && swscanf(percent, L"%%%d", &id2) == 1)
        {
            if (id2 > maxinsert)
                maxinsert = id2;
            ptr = percent + 1;
        }

        New(0, wstrings, maxinsert, WCHAR*);

        /* Allocate dummy strings for inserts not provided by caller */
        for (j=numstrings; j<maxinsert; ++j) {
            New(0, tmpx, 10, WCHAR);
            swprintf(tmpx, L"%%%d", j+1);
            wstrings[j] = tmpx;
        }

	i = sizeof(wregPath);	/* Fixed */

	/* Which EventLog are we reading? */
	New(0, wlongstring, length, WCHAR);

	wlongstring[0] = 0;
        A2WHELPER_LEN(longstring, length, wlongstring, length*sizeof(WCHAR));

	ptr = wlongstring;
	for (j=0; j<numstrings; j++) {
	    wstrings[j] = ptr;

	    ptr += wcslen(ptr)+1;
	    while ((percent = wcschr(wstrings[j], L'%'))
		   && swscanf(percent, L"%%%%%d", &id2) == 1)
	    {
		if (!dll) {		/* first time round - load dll */
		    WCHAR wparamfile[MAX_PATH];

		    i = sizeof(wregPath);
		    if (RegQueryValueExW(hk, L"ParameterMessageFile", 0, 0,
					 (unsigned char *)wregPath,
					 &i) != ERROR_SUCCESS)
		    {
			RegCloseKey(hk);
			XSRETURN_NO;
		    }

		    if (ExpandEnvironmentStringsW(wregPath, wparamfile,
						  sizeof(wparamfile)) == 0)
		    {
			RegCloseKey(hk);
			XSRETURN_NO;
		    }

		    dll = LoadLibraryExW(wparamfile, 0, LOAD_LIBRARY_AS_DATAFILE);
		    if (!dll) {
			RegCloseKey(hk);
			XSRETURN_NO;
		    }
                }

                if (FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER
                                   | FORMAT_MESSAGE_FROM_HMODULE
                                   | FORMAT_MESSAGE_ARGUMENT_ARRAY,
                                   dll, id2, 0, (LPWSTR)&wMsgBuf, 0,
                                   (va_list*)&wstrings[j]) == 0)
                {
                    FreeLibrary(dll);
                    RegCloseKey(hk);
                    XSRETURN_NO;
                }

                percentLen = 2;	/* for %% */
                do {
                    percentLen++;
                } while (id2/=10);	/* compute length of %%xxx string */

                msgLen = wcslen(wMsgBuf);
                Newz(0, tmpx, wcslen(wstrings[j])+msgLen-percentLen+1, WCHAR);
                wcsncpy(tmpx, wstrings[j], percent-wstrings[j]);
                wcsncat(tmpx, wMsgBuf,
                        msgLen - ((wcscmp(wMsgBuf+msgLen-2, L"\r\n")==0) ? 2 : 0));
                wcscat(tmpx, percent+percentLen);
                wstrings[j] = tmpx;
                LocalFree(wMsgBuf);
	    }
	}

        RegCloseKey(hk);
        if (dll)
	    FreeLibrary(dll); /* in case it was used above */

	/* XXX 'strings' argument may be broken on 64-bit
	     * platforms since the documentation says 32-bit
	     * values are required */
	result = (FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER |
				 FORMAT_MESSAGE_FROM_STRING |
				 FORMAT_MESSAGE_ARGUMENT_ARRAY,
				 wmessage, 0, 0, (LPWSTR)&wMsgBuf, 0,
				 (va_list*)wstrings) > 0);

	LocalFree(wmessage);

	for (j=0; j<maxinsert; j++)
	    if (wstrings[j] < wlongstring || wstrings[j] >= wlongstring+length)
		Safefree(wstrings[j]);

	Safefree(wlongstring);
        Safefree(wstrings);

	if (!result || !wMsgBuf) {
	    FreeLibrary(dll);
	    XSRETURN_NO;
	}
	length = (wcslen(wMsgBuf)+1)*2;
	New(0, MsgBuf, length, char);
	W2AHELPER(wMsgBuf, MsgBuf, length);
	SETPV(4, MsgBuf);
	Safefree(MsgBuf);
	LocalFree(wMsgBuf);

	XSRETURN_YES;
    }
    else {
	static const char *EVFILE[] = {"System", "Security", "Application"};
	char *MsgBuf, **strings, *ptr, *tmpx;
	char msgfile[MAX_PATH], regPath[MAX_PATH];
        char *message = NULL;
	DWORD i, id2, maxinsert;
	BOOL result;
	LONG lResult;
	unsigned short j;
	char *percent;
	int percentLen, msgLen, gotPercent;

	/* Which EventLog are we reading? */
	for (j=0; j < (sizeof(EVFILE)/sizeof(EVFILE[0])); j++) {
	    sprintf(regPath,
		    "SYSTEM\\CurrentControlSet\\Services\\EventLog\\%s\\%s",
		    EVFILE[j], source);
	    if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, regPath,
			      0, KEY_READ, &hk) == ERROR_SUCCESS)
	    {
		break;
	    }
	}

	if (j >= (sizeof(EVFILE)/sizeof(EVFILE[0])))
	    XSRETURN_NO;

        /* Get the (list of) message file(s) for this entry */
	i = sizeof(regPath);
	lResult = RegQueryValueExA(hk, "EventMessageFile", 0, 0,
				   (unsigned char *)regPath, &i);
	if (lResult != ERROR_SUCCESS) {
            RegCloseKey(hk);
	    XSRETURN_NO;
        }

	if (ExpandEnvironmentStringsA(regPath, msgfile, sizeof(msgfile)) == 0) {
            RegCloseKey(hk);
	    XSRETURN_NO;
        }

        /* Try to retrieve message *without* expanding the inserts yet */
        ptr = msgfile;
        while (ptr && !message) {
            char *semi = strchr(ptr, ';');
            if (semi)
                *semi++ = '\0';
            dll = LoadLibraryExA(ptr, 0, LOAD_LIBRARY_AS_DATAFILE);
            if (dll) {
                FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER |
                               FORMAT_MESSAGE_FROM_HMODULE    |
                               FORMAT_MESSAGE_IGNORE_INSERTS,
                               dll, id, 0, (LPSTR)&message, 0, NULL);
                FreeLibrary(dll);
            }
            ptr = semi;
        }
	if (!message) {
            RegCloseKey(hk);
	    XSRETURN_NO;
        }

        /* Determine higest %n insert number */
        maxinsert = numstrings;
        ptr = message;
        while ((percent=strchr(ptr, '%'))
               && sscanf(percent, "%%%d", &id2) == 1)
        {
            if (id2 > maxinsert)
                maxinsert = id2;
            ptr = percent + 1;
        }

        New(0, strings, maxinsert, char*);

        /* Allocate dummy strings for inserts not provided by caller */
        for (j=numstrings; j<maxinsert; ++j) {
            New(0, tmpx, 10, char);
            sprintf(tmpx, "%%%d", j+1);
            strings[j] = tmpx;
        }

	i = sizeof(regPath);	/* Fixed */

	ptr = longstring;
	for (j=0; j<numstrings; j++) {
	    strings[j] = ptr;
	    ptr += strlen(ptr)+1;
	    gotPercent = -1;
	    while ((percent=strchr(strings[j], '%'))
		   && sscanf(percent, "%%%%%d", &id2) == 1)
	    {
		gotPercent++;
		if (!dll) {		/* first time round - load dll */
		    char paramfile[MAX_PATH];

		    if (RegQueryValueExA(hk, "ParameterMessageFile", 0, 0,
					 (unsigned char *)regPath,
					 &i) != ERROR_SUCCESS)
		    {
			RegCloseKey(hk);
			XSRETURN_NO;
		    }

		    if (ExpandEnvironmentStringsA(regPath, paramfile,
						  sizeof(paramfile)) == 0)
		    {
			RegCloseKey(hk);
			XSRETURN_NO;
		    }

		    dll = LoadLibraryExA(paramfile, 0, LOAD_LIBRARY_AS_DATAFILE);

		    if (!dll) {
			RegCloseKey(hk);
			XSRETURN_NO;
		    }
                }

                if (FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER
                                   | FORMAT_MESSAGE_FROM_HMODULE
                                   | FORMAT_MESSAGE_ARGUMENT_ARRAY,
                                   dll, id2, 0, (LPSTR)&MsgBuf, 0,
                                   (va_list*)&strings[j]) == 0)
                {
                    FreeLibrary(dll);
                    RegCloseKey(hk);
                    XSRETURN_NO;
                }

                percentLen = 2;	/* for %% */
                do {
                    percentLen++;
                } while (id2/=10);	/* compute length of %%xxx string */

                msgLen = strlen(MsgBuf);
                Newz(0, tmpx, strlen(strings[j])+msgLen-percentLen+1, char);
                strncpy(tmpx, strings[j], percent-strings[j]);
                strncat(tmpx, MsgBuf,
                        msgLen - ((strcmp(MsgBuf+msgLen-2, "\r\n")==0) ? 2 : 0));
                strcat(tmpx, percent+percentLen);
                if (gotPercent)
                    Safefree(strings[j]);
                strings[j] = tmpx;
                LocalFree(MsgBuf);
	    }
	}

        RegCloseKey(hk);
	if (dll)
	    FreeLibrary(dll); /* in case it was used above */

	/* XXX 'strings' argument may be broken on 64-bit
	     * platforms since the documentation says 32-bit
	     * values are required */
	 result = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER |
                                 FORMAT_MESSAGE_FROM_STRING |
                                 FORMAT_MESSAGE_ARGUMENT_ARRAY,
                                 message, 0, 0, (LPSTR)&MsgBuf, 0,
                                 (va_list*)strings) > 0;

	LocalFree(message);

	for (j=0; j<maxinsert; j++)
	    if (strings[j] < longstring || strings[j] >= longstring+length)
		Safefree(strings[j]);

        Safefree(strings);

        if (!result || !MsgBuf) {
	    XSRETURN_NO;
	}

	SETPV(4, MsgBuf);
	LocalFree(MsgBuf);

	XSRETURN_YES;
    }
}
OUTPUT:
    RETVAL

double
constant(name,arg)
    char *          name
    int             arg

bool
BackupEventLog(hEventLog,lpszBackupFileName)
    void *    hEventLog
    char *    lpszBackupFileName
    CODE:
{
    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
    RETVAL = FALSE;
    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID))
	if (USING_WIDE()) {
	    WCHAR wBackupFileName[MAX_PATH+1];
	    A2WHELPER(lpszBackupFileName, wBackupFileName, sizeof(wBackupFileName));
	    RETVAL = BackupEventLogW(lpEvtLog->hLog, wBackupFileName);
	}
	else {
	    RETVAL = BackupEventLogA(lpEvtLog->hLog, lpszBackupFileName);
	}
}
OUTPUT:
    RETVAL

bool
ClearEventLog(hEventLog,lpszBackupFileName)
    void *    hEventLog
    char *    lpszBackupFileName
 CODE:
{
    BOOL result;
    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
    RETVAL = FALSE;
    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID)) {
	if (USING_WIDE()) {
	    WCHAR wBackupFileName[MAX_PATH+1];
	    A2WHELPER(lpszBackupFileName, wBackupFileName, sizeof(wBackupFileName));
	    result = ClearEventLogW(lpEvtLog->hLog, wBackupFileName);
	}
	else {
	    result = ClearEventLogA(lpEvtLog->hLog, lpszBackupFileName);
	}
	if (result && CloseEventLog(lpEvtLog->hLog)) {
	    if (lpEvtLog->BufPtr)
		Safefree(lpEvtLog->BufPtr);
	    Safefree(lpEvtLog);
	    RETVAL = TRUE;
	}
    }
}
OUTPUT:
    RETVAL

bool
CloseEventLog(hEventLog)
    void *    hEventLog
CODE:
{
    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
    RETVAL = FALSE;
    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
	CloseEventLog(lpEvtLog->hLog))
    {
	if (lpEvtLog->BufPtr)
	    Safefree(lpEvtLog->BufPtr);
	Safefree(lpEvtLog);
	RETVAL = TRUE;
    }
}
OUTPUT:
    RETVAL

bool
DeregisterEventSource(hEventLog)
    void *    hEventLog

bool
GetNumberOfEventLogRecords(hEventLog,dwRecords)
    void *     hEventLog
    DWORD dwRecords = NO_INIT
CODE:
{
    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
    RETVAL = FALSE;
    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
	GetNumberOfEventLogRecords(lpEvtLog->hLog, &dwRecords))
    {
	RETVAL = TRUE;
    }
}
OUTPUT:
    RETVAL
    dwRecords	if (RETVAL) SETIV(1, dwRecords);

bool
GetOldestEventLogRecord(hEventLog,dwOldestRecord)
    void *    hEventLog
    DWORD     dwOldestRecord = NO_INIT
CODE:
{
    lpEvtLogCtlBuf lpEvtLog = SVE(hEventLog);
    RETVAL = FALSE;
    if ((lpEvtLog != NULL) && (lpEvtLog->dwID == EVTLOGID) &&
	GetOldestEventLogRecord(lpEvtLog->hLog, &dwOldestRecord))
    {
	RETVAL = TRUE;
    }
}
OUTPUT:
    RETVAL
    dwOldestRecord	if (RETVAL) SETIV(1, dwOldestRecord);

bool
OpenBackupEventLog(hEventLog,lpszUNCServerName,lpszFileName)
    U32       hEventLog = 0;
    char *    lpszUNCServerName
    char *    lpszFileName
CODE:
{
    lpEvtLogCtlBuf lpEvtLog;
    New(1908, lpEvtLog, 1, EvtLogCtlBuf);
    lpEvtLog->BufLen = EVTLOGBUFSIZE;
    New(1908, lpEvtLog->BufPtr, lpEvtLog->BufLen, BYTE);
    RETVAL = FALSE;
    if (USING_WIDE()) {
	WCHAR wUNCServerName[MAX_PATH+1], wFileName[MAX_PATH+1];
	A2WHELPER(lpszUNCServerName, wUNCServerName, sizeof(wUNCServerName));
	A2WHELPER(lpszFileName, wFileName, sizeof(wFileName));
	lpEvtLog->hLog = OpenBackupEventLogW(wUNCServerName,wFileName);
    }
    else {
	lpEvtLog->hLog = OpenBackupEventLogA(lpszUNCServerName,lpszFileName);
    }
    if (lpEvtLog->hLog) {
	/* return info... */
	lpEvtLog->dwID          = EVTLOGID;
	lpEvtLog->NumEntries    = 0;
	lpEvtLog->CurEntryNum   = 0;
	lpEvtLog->CurEntry      = NULL;
	lpEvtLog->Flags         = 0;
	hEventLog = (U32)lpEvtLog;
	RETVAL = TRUE;
    }
    else {
	/* Open failed... */
	if (lpEvtLog->BufPtr)
	    Safefree(lpEvtLog->BufPtr);
	Safefree(lpEvtLog);
    }
}
OUTPUT:
    RETVAL
    hEventLog

bool
OpenEventLog(hEventLog,lpszUNCServerName,lpszSourceName)
    U32       hEventLog = 0;
    char *    lpszUNCServerName
    char *    lpszSourceName
CODE:
{
    lpEvtLogCtlBuf lpEvtLog;
    New(1908, lpEvtLog, 1, EvtLogCtlBuf);
    lpEvtLog->BufLen = EVTLOGBUFSIZE;
    New(1908, lpEvtLog->BufPtr, lpEvtLog->BufLen, BYTE);
    RETVAL = FALSE;
    if (USING_WIDE()) {
	WCHAR wUNCServerName[MAX_PATH+1], wSourceName[MAX_PATH+1];
	A2WHELPER(lpszUNCServerName, wUNCServerName, sizeof(wUNCServerName));
	A2WHELPER(lpszSourceName, wSourceName, sizeof(wSourceName));
	lpEvtLog->hLog = OpenEventLogW(wUNCServerName,wSourceName);
    }
    else {
	lpEvtLog->hLog = OpenEventLogA(lpszUNCServerName,lpszSourceName);
    }
    if (lpEvtLog->hLog) {
	/* return info... */
	lpEvtLog->dwID          = EVTLOGID;
	lpEvtLog->NumEntries    = 0;
	lpEvtLog->CurEntryNum   = 0;
	lpEvtLog->CurEntry      = NULL;
	lpEvtLog->Flags         = 0;
	hEventLog = (U32)lpEvtLog;
	RETVAL = TRUE;
    }
    else {
	/* Open failed... */
	if (lpEvtLog->BufPtr)
	    Safefree(lpEvtLog->BufPtr);
	Safefree(lpEvtLog);
    }
}
OUTPUT:
    RETVAL
    hEventLog

void*
RegisterEventSource(lpszUNCServerName,lpszSource)
    char *    lpszUNCServerName
    char *    lpszSource

