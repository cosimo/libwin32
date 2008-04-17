/*
 * XS interface to Windows NT Network resources
 * Written by Jesse Dougherty for hip communications
 *
 * Heavily cleaned up and bugfixed by Gurusamy Sarathy <gsar@umich.edu>
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <malloc.h>
#include <string.h>

#define UNICODE
#define _UNICODE

#undef LPTSTR        /* This is a band-aid to allow the NetShare* functions to use */
#define LPTSTR LPWSTR    /* UNICODE strings while allowing the other functionts to use
                           ANSI strings. The functions headers for NetShare*
               functions are WRONG! */

#include <lmcons.h>
#include <lmshare.h>

#undef LPTSTR

#undef UNICODE
#undef _UNICODE

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/*#include "NTXSUB.h"*/

static DWORD dwLastError = NO_ERROR;

/*
 * TSHARE_INFO struct is used in the mapping of the SHARE_INFO_502
 * to a perl readable ( non UNICODE ) form.
 */

typedef struct _TSHARE_INFO{
    DWORD        type;
    DWORD        permissions;
    DWORD        max_uses;
    DWORD        current_uses;
    char        remark[MAXCOMMENTSZ+1];
    char        netname[NNLEN+1];
    char        path[PATHLEN+1];
    char        passwd[PWLEN+1];
} TSHARE_INFO, *PTSHARE_INFO, *LPTSHARE_INFO; 

static long
constant(char* name,int arg)
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
    if (strEQ(name, "RESOURCEDISPLAYTYPE_DOMAIN"))
#ifdef RESOURCEDISPLAYTYPE_DOMAIN
        return RESOURCEDISPLAYTYPE_DOMAIN;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEDISPLAYTYPE_FILE"))
#ifdef RESOURCEDISPLAYTYPE_FILE
        return RESOURCEDISPLAYTYPE_FILE;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEDISPLAYTYPE_GENERIC"))
#ifdef RESOURCEDISPLAYTYPE_GENERIC
        return RESOURCEDISPLAYTYPE_GENERIC;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEDISPLAYTYPE_GROUP"))
#ifdef RESOURCEDISPLAYTYPE_GROUP
        return RESOURCEDISPLAYTYPE_GROUP;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEDISPLAYTYPE_SERVER"))
#ifdef RESOURCEDISPLAYTYPE_SERVER
        return RESOURCEDISPLAYTYPE_SERVER;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEDISPLAYTYPE_SHARE"))
#ifdef RESOURCEDISPLAYTYPE_SHARE
        return RESOURCEDISPLAYTYPE_SHARE;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEDISPLAYTYPE_TREE"))
#ifdef RESOURCEDISPLAYTYPE_TREE
        return RESOURCEDISPLAYTYPE_TREE;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCETYPE_ANY"))
#ifdef RESOURCETYPE_ANY
        return RESOURCETYPE_ANY;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCETYPE_DISK"))
#ifdef RESOURCETYPE_DISK
        return RESOURCETYPE_DISK;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCETYPE_PRINT"))
#ifdef RESOURCETYPE_PRINT
        return RESOURCETYPE_PRINT;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCETYPE_UNKNOWN"))
#ifdef RESOURCETYPE_UNKNOWN
        return RESOURCETYPE_UNKNOWN;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEUSAGE_CONNECTABLE"))
#ifdef RESOURCEUSAGE_CONNECTABLE
        return RESOURCEUSAGE_CONNECTABLE;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEUSAGE_CONTAINER"))
#ifdef RESOURCEUSAGE_CONTAINER
        return RESOURCEUSAGE_CONTAINER;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCEUSAGE_RESERVED"))
#ifdef RESOURCEUSAGE_RESERVED
        return RESOURCEUSAGE_RESERVED;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCE_CONNECTED"))
#ifdef RESOURCE_CONNECTED
        return RESOURCE_CONNECTED;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCE_GLOBALNET"))
#ifdef RESOURCE_GLOBALNET
        return RESOURCE_GLOBALNET;
#else
        goto not_there;
#endif
    if (strEQ(name, "RESOURCE_REMEMBERED"))
#ifdef RESOURCE_REMEMBERED
        return RESOURCE_REMEMBERED;
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
 

BOOL
EnumerateFunc(SV* ARef, LPNETRESOURCEA lpnr,DWORD dwType) 
{ 
    DWORD dwResult, dwResultEnum; 
    HANDLE hEnum; 
    DWORD cbBuffer = 16384; /* 16K is reasonable size                 */
    DWORD cEntries = 0xFFFFFFFF; /* enumerate all possible entries    */
    LPNETRESOURCEA lpnrLocal;     /* pointer to enumerated structures  */
    DWORD i; 
    HV*     phvNet;
    SV*        svNetRes;
    static char nulstr[] = "";
 
    dwResult = WNetOpenEnumA(
	RESOURCE_GLOBALNET, 
        dwType, 
        0,                 /* enumerate all resources                 */ 
        lpnr,              /* NULL first time this function is called */ 
        &hEnum);           /* handle to resource                      */ 
 
    if (dwResult != NO_ERROR){ 
         dwLastError = dwResult;
         return FALSE; 
    }
 
    do { 
 
        /* Allocate memory for NETRESOURCE structures. */ 
 
        lpnrLocal = (LPNETRESOURCEA) safemalloc( cbBuffer ); 
 
        dwResultEnum = WNetEnumResourceA(hEnum, /* resource handle     */ 
            &cEntries,               /* defined locally as 0xFFFFFFFF */ 
            lpnrLocal,               /* LPNETRESOURCE                 */ 
            &cbBuffer);              /* buffer size                   */ 
 
        if (dwResultEnum == NO_ERROR) { 
            for(i = 0; i < cEntries; i++) { 
		NETRESOURCEA mine = lpnrLocal[i];
		/* LocalName contains garbage when RESOURCE_GLOBALNET is used */
		/* fprintf(stderr, "==%s=%s=%s=%s==\n",
			mine.lpLocalName,
			mine.lpRemoteName,
			mine.lpComment,
			mine.lpProvider);
		mine.lpLocalName = nulstr;
		mine.lpRemoteName = nulstr;
		mine.lpComment = nulstr;
		mine.lpProvider = nulstr; */
                /* Create a new SV and store the current NETRESOURCE. */

                svNetRes = newSVpv("",0);
		sv_catpvf(svNetRes, "%d\1%d\1%d\1%d\1%s\1%s\1%s\1%s",
			mine.dwScope, mine.dwType,
			mine.dwDisplayType, mine.dwUsage,
			mine.lpLocalName, mine.lpRemoteName,
			mine.lpComment, mine.lpProvider);
                /* svNetRes = newSVpv( (char *)&mine,sizeof( NETRESOURCEA)); */
                 
                /* Store the svNetRes in the list to return. */

                av_push( (AV *)SvRV(ARef),svNetRes ); 
                                                 
        /* If this NETRESOURCE is a container, call the function 
                  recursively. */
 
                if(RESOURCEUSAGE_CONTAINER == 
                        (lpnrLocal[i].dwUsage & RESOURCEUSAGE_CONTAINER)) 
                    if(!EnumerateFunc(ARef, &lpnrLocal[i],dwType)) {
                        safefree(lpnrLocal);
                        return FALSE;
                        } 
            } 
        } 
 
        else if (dwResultEnum != ERROR_NO_MORE_ITEMS) { 
            dwLastError = dwResultEnum;
            safefree(lpnrLocal);
            return(FALSE);
        } 
    } 
    while(dwResultEnum != ERROR_NO_MORE_ITEMS); 
 
    dwResult = WNetCloseEnum(hEnum); 
    safefree(lpnrLocal);
 
    if(dwResult != NO_ERROR){
        dwLastError = dwResult;
        return FALSE;
    } 
    
    dwLastError = NO_ERROR;
    return TRUE; 
} 
 
/*
 * wide character allocation routines used to convert from
 * ANSI char strings to UNICODE strings.
 * Stolen shamelessly from DJL's NetAdmin module.
 */

LPWSTR
_AllocWideName(char* name)
{
    int length;
    LPWSTR lpPtr = NULL;
    if(name != NULL && *name != '\0') {
        length = (strlen(name)+1)*2;
        lpPtr = (LPWSTR)safemalloc(length);
        if(lpPtr != NULL)
            MultiByteToWideChar(CP_ACP, NULL, name, -1, lpPtr, length);
    }
    return lpPtr;
}

#define AllocWideName(n,wn) (wn = _AllocWideName(n))

void
FreeWideName(LPWSTR lpPtr)
{
    if(lpPtr != NULL)
        safefree(lpPtr);
}

int
WCTMB(LPWSTR lpwStr, LPSTR lpStr, int size)
{
    return WideCharToMultiByte(CP_ACP, NULL, lpwStr, -1, lpStr, size, NULL, NULL);
}    


MODULE = Win32::NetResource    PACKAGE = Win32::NetResource

PROTOTYPES: DISABLE

long
constant(name,arg)
    char *        name
    int        arg
CODE:
        RETVAL=constant(name,arg);
OUTPUT:
    RETVAL

BOOL
_GetSharedResources(Resources,dwType)
    SV * Resources
    DWORD dwType
CODE:
    {
        RETVAL = EnumerateFunc(Resources,NULL,dwType);
    }
OUTPUT:
    Resources
    RETVAL

BOOL
_AddConnection(lpNetResource,lpPassword,lpUsername,fdwConnection)
    LPNETRESOURCEA    lpNetResource
    LPCSTR    lpPassword
    LPCSTR    lpUsername
    DWORD    fdwConnection 
CODE:
    {
        if(lpPassword && *lpPassword == '\0' )
            lpPassword = NULL;

        if( lpUsername && *lpUsername == '\0' )
            lpUsername = NULL;

        dwLastError = WNetAddConnection2A(lpNetResource,lpPassword,lpUsername,fdwConnection);
        RETVAL = (dwLastError == NO_ERROR);
    }
OUTPUT:
    RETVAL



BOOL
CancelConnection(lpName,fdwConnection,fForce)
    LPCSTR    lpName
    DWORD    fdwConnection
    BOOL    fForce     
CODE:
    {
        dwLastError = WNetCancelConnection2A(lpName,fdwConnection,fForce);
        RETVAL = (dwLastError == NO_ERROR);
    }
OUTPUT:
    RETVAL

         

BOOL
GetConnection(LocalName,RemoteName)
    LPCSTR    LocalName
    LPCSTR    RemoteName = NO_INIT
CODE:
    {
        BYTE szRemote[4192];
        DWORD cbBuffer = sizeof(szRemote);
        dwLastError = WNetGetConnectionA(LocalName,(char*)szRemote,&cbBuffer);
        RETVAL = (dwLastError == NO_ERROR);
        if (!RETVAL)
            szRemote[0] = '\0';
        RemoteName = (char *) szRemote;
    }
OUTPUT:
    RemoteName
    RETVAL
    


BOOL
WNetGetLastError(ErrorCode,Description,Name)
    DWORD    ErrorCode = NO_INIT
    LPCSTR    Description    = NO_INIT
    LPCSTR    Name = NO_INIT
CODE:
    BYTE    abDesc[2048];
    BYTE    abName[2048];
    DWORD   cbDesc = sizeof(abDesc);
    DWORD   cbName = sizeof(abName);
    dwLastError = WNetGetLastErrorA(&ErrorCode,(char *)abDesc,cbDesc,(char *)abName,cbName);
    RETVAL = (dwLastError == NO_ERROR);
    if (!RETVAL) {
        abDesc[0] = '\0';
        abName[0] = '\0';
    }
    Description = (char *)abDesc;
    Name = (char *)abName;
OUTPUT:
    ErrorCode
    Description
    Name
    RETVAL
    
BOOL
GetError(ErrorCode)
    DWORD ErrorCode = NO_INIT
CODE:
    ErrorCode = dwLastError;
    RETVAL = 1;
OUTPUT:
    ErrorCode
    RETVAL


BOOL
GetUNCName(UNCName,LocalPath)
    LPCSTR UNCName = NO_INIT
    LPCSTR    LocalPath
CODE:
    {
        UNIVERSAL_NAME_INFO   uniBuffer[1024];
        DWORD    BufferSize = sizeof(uniBuffer);
        
        dwLastError = WNetGetUniversalNameA(LocalPath,UNIVERSAL_NAME_INFO_LEVEL,uniBuffer,&BufferSize);
        RETVAL = (dwLastError  == NO_ERROR );         
        if (RETVAL)
            UNCName = (char *) uniBuffer[0].lpUniversalName;
        else
            UNCName = "";
    }
OUTPUT:
    UNCName
    RETVAL


BOOL 
_NetShareAdd(tshare,parm_err,servername=NULL)
    PTSHARE_INFO    tshare
    LPDWORD parm_err     
    LPSTR servername
CODE:
    {
        DWORD    parm;
        SHARE_INFO_502     Share_502;
        LPWSTR    lpwServer;
        AllocWideName( servername,lpwServer );

        /* Copy the non-UNICODE data into the SHARE_INFO_502 structure. */

        Share_502.shi502_type = tshare->type;
        Share_502.shi502_permissions = tshare->permissions;
        Share_502.shi502_max_uses = tshare->max_uses;
        Share_502.shi502_current_uses = tshare->current_uses;

        /* Create the UNICODE strings. */

        AllocWideName( tshare->remark,Share_502.shi502_remark        );
        AllocWideName( tshare->netname, Share_502.shi502_netname    );
        AllocWideName( tshare->passwd, Share_502.shi502_passwd        );
        AllocWideName( tshare->path, Share_502.shi502_path            );

        Share_502.shi502_security_descriptor = NULL;

        dwLastError = NetShareAdd(lpwServer,502,(LPBYTE)&Share_502,&parm);
        RETVAL = (dwLastError == NO_ERROR);
        parm_err = &parm;
                
        /* Deallocate the wide strings */

        FreeWideName( Share_502.shi502_remark );
        FreeWideName( Share_502.shi502_netname );
        FreeWideName( Share_502.shi502_passwd );
        FreeWideName( Share_502.shi502_path );

        FreeWideName( lpwServer );
    }
OUTPUT:
    parm_err
    RETVAL

BOOL 
NetShareCheck(device,type,servername=NULL)
    LPSTR device
    LPDWORD type    
    LPSTR servername
CODE:
    {
        LPWSTR    lpwServer,lpwDevice;
        AllocWideName( servername,lpwServer );
        AllocWideName( device, lpwDevice );
        
        dwLastError = NetShareCheck(lpwServer,lpwDevice,type);
        FreeWideName( lpwServer );
        FreeWideName( lpwDevice );
        
        RETVAL = (dwLastError == NO_ERROR);
    }
OUTPUT:
    RETVAL
    type


BOOL 
NetShareDel(netname,servername=NULL)
    LPSTR netname
    LPSTR servername
CODE:
    {
        LPWSTR    lpwServer,lpwNetname;
        AllocWideName( servername, lpwServer );
        AllocWideName( netname, lpwNetname );

        dwLastError = NetShareDel(lpwServer,lpwNetname,0);
        RETVAL = (dwLastError == NO_ERROR);

        FreeWideName( lpwServer );
        FreeWideName( lpwNetname );

    }
OUTPUT:
    RETVAL

BOOL 
_NetShareGetInfo(netname,ReturnInfo,servername=NULL)
    LPSTR netname
    PTSHARE_INFO ReturnInfo = NO_INIT
    LPSTR servername
CODE:
    {
        BOOL bRet;
        TSHARE_INFO    tRet;    
        PSHARE_INFO_502    pShareInfo;
        LPWSTR    lpwServer,lpwNetname;

        /* Create the UNICODE strings for the API call. */

        /* zero the arrays in tRet; */
        memset(tRet.remark,0,MAXCOMMENTSZ+1);
        memset(tRet.netname,0,NNLEN+1);
        memset(tRet.path,0,PATHLEN+1);
        memset(tRet.passwd,0,PWLEN+1);

        AllocWideName( servername,lpwServer );
        AllocWideName( netname, lpwNetname ); 

        dwLastError = NetShareGetInfo(lpwServer,lpwNetname,502,(BYTE **)&pShareInfo);
        assert( pShareInfo != NULL );

        FreeWideName( lpwServer );
        FreeWideName( lpwNetname );

        /* Convert the SHARE_INFO_502 structure into a TSHARE structure for Perl. */
        if( dwLastError == NO_ERROR){

            tRet.type = pShareInfo->shi502_type;
            tRet.permissions = pShareInfo->shi502_permissions;
            tRet.max_uses = pShareInfo->shi502_max_uses;
            tRet.current_uses = pShareInfo->shi502_current_uses;

            /* Convert the UNICODE strings into ANSI strings for perl. */
            WCTMB( pShareInfo->shi502_remark,    tRet.remark,    MAXCOMMENTSZ+1);
            WCTMB( pShareInfo->shi502_netname,    tRet.netname,    NNLEN+1);
            WCTMB( pShareInfo->shi502_path,        tRet.path,    PATHLEN+1);
            WCTMB( pShareInfo->shi502_passwd,    tRet.passwd,    PWLEN+1);

            /* Store the results. */
             ReturnInfo = &tRet;
        }
        RETVAL = ( dwLastError == NO_ERROR );
    }
OUTPUT:
    RETVAL
    ReturnInfo    



BOOL 
_NetShareSetInfo(netname,tshare,parm_err,servername=NULL)
    LPSTR netname
    PTSHARE_INFO tshare
    LPDWORD parm_err     
    LPSTR servername
CODE:
    {
        SHARE_INFO_502     Share_502;
        LPWSTR    lpwServer,lpwNetname;
        AllocWideName( servername,lpwServer );
        AllocWideName( netname, lpwNetname );

        assert( tshare != NULL );

        /* Copy the non-UNICODE data into the SHARE_INFO_502 structure. */
        Share_502.shi502_type = tshare->type;
        Share_502.shi502_permissions = tshare->permissions;
        Share_502.shi502_max_uses = tshare->max_uses;
        Share_502.shi502_current_uses = tshare->current_uses;

        /* Create the UNICODE strings. */
        AllocWideName( tshare->remark,Share_502.shi502_remark        );
        AllocWideName( tshare->netname, Share_502.shi502_netname    );
        AllocWideName( tshare->passwd, Share_502.shi502_passwd        );
        AllocWideName( tshare->path, Share_502.shi502_path            );

        dwLastError = NetShareSetInfo(lpwServer,lpwNetname,502,(LPBYTE)&Share_502,parm_err);
        RETVAL = (dwLastError == NO_ERROR);

        /* Free the UNICODE strings. */
        FreeWideName( Share_502.shi502_remark     );
        FreeWideName( Share_502.shi502_netname );
        FreeWideName( Share_502.shi502_passwd     );
        FreeWideName( Share_502.shi502_path     );
        FreeWideName( lpwServer );
        FreeWideName( lpwNetname );
    }
OUTPUT:
    RETVAL
    parm_err

