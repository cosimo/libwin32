/*
 * Clipboard.CPP
 * 19 Nov 96 by Aldo Calpini
 *
 * XS interface to the Windows Clipboard 
 * based on Registry.CPP written by Jesse Dougherty
 *
 * Version: 0.03 23 Apr 97
 *
 */

#define  WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <string.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
// Section for the constant definitions.
#define CROAK croak
#define MAX_LENGTH 2048
#define TMPBUFSZ 1024

MODULE = Win32::Clipboard	PACKAGE = Win32::Clipboard

PROTOTYPES: DISABLE

void
Get(...)
PPCODE:
    HANDLE myhandle;
    if (OpenClipboard(NULL)) {
	EXTEND(SP,1);
	if(myhandle = GetClipboardData(CF_TEXT))
	    XST_mPV(0,(char *) myhandle);
	else
	    XST_mNO(0);
	CloseClipboard();
	XSRETURN(1);
    }


void
Set(text,...)
    SV *text
PPCODE:
    HANDLE myhandle;
    HGLOBAL hGlobal;
    LPTSTR szString;
    int leng;
    if (items > 1)
	text = ST(1);

    leng = SvCUR(text);
    if (hGlobal = GlobalAlloc(GMEM_DDESHARE, (leng+1)*sizeof(char))) {
	szString = (char *) GlobalLock(hGlobal);
	memcpy(szString, (char *) SvPV(text, na), leng*sizeof(char));
	szString[leng] = (char) 0;
	GlobalUnlock(hGlobal);

	if (OpenClipboard(NULL)) {
	    EmptyClipboard();
	    myhandle = SetClipboardData(CF_TEXT, (HANDLE) hGlobal);
	    CloseClipboard();

	    if (myhandle) {				
		XSRETURN_YES;
	    } else {
		//printf("SetClipboardData failed (%d)\n", GetLastError());
		XSRETURN_NO;
	    }
	} else {
	    //printf("OpenClipboard failed (%d)\n", GetLastError());
	    GlobalFree(hGlobal);
	    XSRETURN_NO;
	}
    } else {
	//printf("GlobalAlloc failed (%d)\n", GetLastError());
	XSRETURN_NO;
    }


void
Empty(...)
PPCODE:
    if (OpenClipboard(NULL)) {
	if(EmptyClipboard()) {
	    CloseClipboard();
	    XSRETURN_YES;
	} else {
	    CloseClipboard();
	    XSRETURN_NO;
	}
    }

