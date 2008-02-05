//--------------------------------------------------------------------
// $Id$
//--------------------------------------------------------------------
//
//   Win32::IPC
//   Copyright 1998 by Christopher J. Madsen
//
//   XS file for the Win32::IPC module
//
//--------------------------------------------------------------------

#if defined(__cplusplus)
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#if defined(__cplusplus)
}
#endif

#define WIN32_LEAN_AND_MEAN
#include <windows.h>


static IV
WaitForMultiple(AV* hArray, BOOL fWaitAll, DWORD dwTimeOut)
{
  int	   count;
  SV **    svpp;
  HANDLE   handle;
  HANDLE*  aHandles;
  int	   i=0;
  DWORD    result;

  count = av_len(hArray) + 1;
  if (count == 0) {
    warn("No objects to wait for");
    return IV_MAX;
  }

  aHandles = safemalloc(count * sizeof(HANDLE));

  // Create the array of handles for the WaitForMultipleObjects call

  for (i = 0; i < count; i++) {
    svpp = av_fetch(hArray, i, 0);

    // Check if the object reference is valid

    if (!svpp) {
     invalid:
      croak("Invalid object passed ($objects[%d])",i);
      return IV_MAX;
    } else if (sv_derived_from(*svpp,"Win32::Process")) {
      dSP;
      handle = INVALID_HANDLE_VALUE;
      ENTER;
      SAVETMPS;
      PUSHMARK(sp);
      XPUSHs(*svpp);
      PUTBACK;
      result = perl_call_method("get_process_handle", G_SCALAR|G_EVAL);
      SPAGAIN;
      if ((result == 1) && SvIOKp(TOPs)) handle = (HANDLE)POPi;
      PUTBACK;
      FREETMPS;
      LEAVE;
    } else if (sv_derived_from(*svpp,"Win32::IPC")) {
      handle = (HANDLE)(SvIV(SvRV(*svpp)));
    } else {
      croak("Don't know how to wait on $objects[%d]",i);
      return IV_MAX;
    }

    if (handle == INVALID_HANDLE_VALUE) goto invalid;
    aHandles[i] = handle;
  } // for loop

  // Now wait for something to happen

  result = WaitForMultipleObjects(count, aHandles, fWaitAll, dwTimeOut);
  safefree(aHandles);

  if ((result >= WAIT_OBJECT_0) && (result < WAIT_OBJECT_0 + count))
    return result - WAIT_OBJECT_0 + 1;
  if ((result >= WAIT_ABANDONED_0) && (result < WAIT_ABANDONED_0 + count))
    return -(IV)(result - WAIT_ABANDONED_0 + 1);
  if (result == WAIT_TIMEOUT)
    return 0;
  return IV_MAX; /* error */
} /* end WaitForMultiple */

static DWORD
constant(char* name)
{
    errno = 0;
    if (strEQ(name, "INFINITE"))
      return INFINITE;
    errno = EINVAL;
    return 0;
} /* end constant */


MODULE = Win32::IPC		PACKAGE = Win32::IPC

PROTOTYPES: ENABLE

DWORD
constant(name)
    char* name


IV
wait_any(objects,timeout=INFINITE)
	SV *  objects
	BOOL  waitall
	DWORD timeout
ALIAS:
	wait_all = 1
PROTOTYPE: \@;$
PREINIT:
	AV *	av;
	DWORD 	ret;
CODE:
	if (!(SvROK(objects)
	      && (av = (AV*)SvRV(objects))
	      && SvTYPE(av) == SVt_PVAV))
	    croak("First arg must be an array");
	RETVAL = WaitForMultiple(av, ix, timeout);
        if (RETVAL == IV_MAX)
          XSRETURN_UNDEF;
OUTPUT:
    RETVAL


IV
wait(handle, timeout=INFINITE)
    HANDLE handle
    DWORD  timeout
PREINIT:
	DWORD result;
CODE:
	result = WaitForSingleObject(handle,timeout);
	if (result == WAIT_OBJECT_0)
	  RETVAL = 1;
	else if (result == WAIT_ABANDONED_0)
	  RETVAL = -1;
	else if (result == WAIT_TIMEOUT)
	  RETVAL = 0;
        else
          XSRETURN_UNDEF;
OUTPUT:
    RETVAL


DWORD
Wait(handle, timeout)
    HANDLE handle
    DWORD  timeout
CODE:
    RETVAL = WaitForSingleObject(handle,timeout);
OUTPUT:
    RETVAL
