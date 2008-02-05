/* FileSecurity.cpp
 * By Monte Mitzelfelt, monte@conchas.nm.org
 * Larry Wall's Artistic License applies to all related Perl
 *  and C code for this module
 * Thanks to the guys at ActiveWare!
 * v0.66
 *
 * minor misc hacks by Gurusamy Sarathy <gsar@umich.edu>
 *
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <winbase.h>
#include <string.h>
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#undef New
#undef Newc

/* Temp override */
#define New(x,v,n,t) (v = (t*)LocalAlloc( LPTR, (MEM_SIZE)((n) * sizeof(t))))
#define Newc(x,v,n,t,c) (v = (c*)LocalAlloc( LPTR, (MEM_SIZE)((n) * sizeof(t))))

#define RETURNRESULT(x)        if((x)){ XST_mYES(0); }\
                             else { XST_mNO(0); }\
                             XSRETURN(1)
#define SETIV(index,value) sv_setiv(ST(index), value)
#define SETPV(index,string) sv_setpv(ST(index), string)

/* check first chars before _stricmp should short-circuit */
#undef    compstr
#define compstr( str1, str2 ) tolower( *str1 ) == tolower( *str2 ) && ! stricmp( str1, str2 )

/* change Safefree to LocalFree to use Win32 */
#undef checkfree
#define checkfree(x)    if ( x != NULL ) LocalFree( x ) ;

#define GENERIC_RIGHTS_MASK (0xF0000000L)
#define REST_RIGHTS_MASK    (0x001FFFFFL)

/* #define NUM_RIGHTS            23 */
#define NUM_SPECIAL_SID        1
#define MAXIMUM_NAME_LENGTH    256
#define ALLOW_ACE_LENGTH    sizeof( ACCESS_ALLOWED_ACE ) + 50

static DWORD nRights[] =
{
  DELETE, READ_CONTROL, WRITE_DAC, WRITE_OWNER,
  SYNCHRONIZE, STANDARD_RIGHTS_REQUIRED, 
  STANDARD_RIGHTS_READ, STANDARD_RIGHTS_WRITE,
  STANDARD_RIGHTS_EXECUTE, STANDARD_RIGHTS_ALL,
  SPECIFIC_RIGHTS_ALL, ACCESS_SYSTEM_SECURITY, 
  MAXIMUM_ALLOWED, GENERIC_READ, GENERIC_WRITE,
  GENERIC_EXECUTE, GENERIC_ALL,
  READ_CONTROL | SYNCHRONIZE,
  READ_CONTROL | SYNCHRONIZE,
  DELETE | READ_CONTROL | SYNCHRONIZE,
  DELETE | READ_CONTROL | SYNCHRONIZE,
  (0x001F01FF), (0x001F01FF) /* FULL from experience rather than compsite flags */
} ;

static char *szRights[] =
{
  "DELETE", "READ_CONTROL", "WRITE_DAC", "WRITE_OWNER",
  "SYNCHRONIZE", "STANDARD_RIGHTS_REQUIRED", 
  "STANDARD_RIGHTS_READ", "STANDARD_RIGHTS_WRITE",
  "STANDARD_RIGHTS_EXECUTE", "STANDARD_RIGHTS_ALL",
  "SPECIFIC_RIGHTS_ALL", "ACCESS_SYSTEM_SECURITY", 
  "MAXIMUM_ALLOWED", "GENERIC_READ", "GENERIC_WRITE",
  "GENERIC_EXECUTE", "GENERIC_ALL",
  "R", "READ", "C", "CHANGE", "F", "FULL", NULL
} ;

static char *szLocalLookup[] = { "BUILTIN", "NT AUTHORITY", NULL } ;

static long constant( char *name ) {
    int i;

    errno = 0;

    for( i = 0; szRights[i] ; i++ ) {
        if ( compstr( name, szRights[i] ) ) {
            return nRights[i] ;
        }
    }

    errno = EINVAL ;
    return 0 ;
}

void
ErrorHandler( const char *ErrName ) {
    SV* sv = NULL ;

/*    sv = perl_get_sv( "!", TRUE ) ; */
    if ( sv == NULL ) {
        croak( "Error handling error: %u, %s", GetLastError(), ErrName ) ;
    } else {
        sv_setpv( sv, (char *) ErrName ) ;
        sv_setiv( sv, GetLastError() ) ;
        SvPOK_on(sv) ;
    }
}


MODULE = Win32::FileSecurity		PACKAGE = Win32::FileSecurity

PROTOTYPES: DISABLE

long
constant(name)
	char *name
    CODE:
        RETVAL = constant(name);
    OUTPUT:
	RETVAL
	
I32
MakeMask(...)
    CODE:
    {
	unsigned int i, j, len ;
	char *name ;
	I32 Mask = 0 ;
	
	for( i = 0 ; i < items ; i++ ) {
	    if ( ! SvPOK( ST(i) ) ) continue ;
	    name = SvPV( ST(i), len ) ;
	    
	    for( j = 0; szRights[j]; j++ ) {
		if ( compstr( name, szRights[j] ) ) {
		    Mask |= nRights[j] ;
		    break ;
		}
	    }
	}
	RETVAL = Mask;
    }
    OUTPUT:
	RETVAL   


bool
EnumerateRights(Mask,av)
	I32 Mask
	SV *av
    CODE:
	{
	    int j, Ok ;
	    if (!(av && SvROK(av) && (av = SvRV(av)) && SvTYPE(av) == SVt_PVAV))
    		croak( "second arg must be ARRAYREF" ) ;

	    av_clear( (AV*)av ) ;

	    for ( j = 0; szRights[j]; j++ ) {
		/* The one length strings are the duplicates
		 * of more readable constants */
		if ( strlen( szRights[j] ) == 1 ) continue ;
		
		if ( ! ( ( nRights[j] & Mask ) ^ nRights[j] ) ) {
		    av_push((AV*)av,
			     newSVpv(szRights[j], strlen((const char*)szRights[j])));
		}
	    }
	    RETVAL = 1;
	}
    OUTPUT:
	RETVAL

bool
Get(filename, hv)
	char *filename
	SV *hv
    CODE:
	{
	    SV*  sv;
	    SV** psv;
	    AV*  av ;
	    PSECURITY_DESCRIPTOR pSecDesc = NULL ;
	    SECURITY_DESCRIPTOR_CONTROL Control = 0 ;
	    BOOL bDaclPresent, bDaclDefaulted ;
	    PACL pDacl ;
	    PACE_HEADER pAce ;
	    PACCESS_ALLOWED_ACE pAllAce ;
	    LPTSTR FullName, Name = NULL, DName = NULL, NoName = "Unknown\000" ;
	    DWORD bFN = MAXIMUM_NAME_LENGTH << 1, 
		bName = MAXIMUM_NAME_LENGTH, bDName = MAXIMUM_NAME_LENGTH;
	    SID_NAME_USE eUse ;
	    DWORD nLength = 0, nLengthNeeded = 1, tries = 2, Revision = 0 ;
	    DWORD error, i, j ;

	    RETVAL = FALSE;
	    
	    if (!(hv && SvROK(hv) && (hv = SvRV(hv)) && SvTYPE(hv) == SVt_PVHV))
		croak( "second arg must be HASHREF" ) ;

	    /* Clean the slate */
	    hv_clear( (HV*)hv ) ;
	    
	    while ( nLengthNeeded && tries ) {
		tries-- ;

		if ( GetFileSecurity(
		    filename ,			/* address of string for file name */
		    DACL_SECURITY_INFORMATION,	/* requested information */
		    pSecDesc,                   /* address of security descriptor */
		    nLength,                    /* size of security descriptor buffer */
		    &nLengthNeeded              /* address of required size of buffer */
		    ) ) {
		    break ;
		} else {
		    if ( GetLastError() != ERROR_INSUFFICIENT_BUFFER ) {
			switch ( error = GetLastError() ) {
			case ERROR_FILE_NOT_FOUND :
			    ErrorHandler( "File not found." ) ;
			    goto GetCleanup ;
			    
			default :
			    ErrorHandler( "GetFileSecurity" ) ;
			    goto GetCleanup ;
			}
		    }
		}

		/* Allocate space for SecurityDescriptor */
		nLength = nLengthNeeded ;
		Newc( 1, pSecDesc, nLength, char, SECURITY_DESCRIPTOR ) ;
		
		if( pSecDesc == NULL ) {
		    ErrorHandler( "Newc pSecDesc" ) ;
		}
	    }

	    if ( ! GetSecurityDescriptorControl(
		pSecDesc,    /* address of security descriptor */
		&Control,    /* address of  control structure */
		(LPDWORD) &Revision     /* address of revision value */
		) ) {
		ErrorHandler( "GetSecurityDescriptorControl" ) ;
	    }
	    
	    if ( ! ( Control & 0x0004 ) ) {
		ErrorHandler( "No DACL present: explicit deny all" ) ;
		goto GetCleanup ;
	    }

	    if ( ! GetSecurityDescriptorDacl(
		pSecDesc,			/* address of security descriptor */
		(LPBOOL) &bDaclPresent,		/* address of flag for presence of disc. ACL */
		&pDacl,				/* address of pointer to ACL */
		(LPBOOL) &bDaclDefaulted	/* address of flag for default disc. ACL */
		) ) {
		ErrorHandler( "GetSecurityDescriptorDacl" ) ;
		goto GetCleanup ;
	    }

	    if ( pDacl == NULL ) {
		ErrorHandler( "Dacl is NULL: implicit access grant" ) ;
		goto GetCleanup ;
	    }

	    New( 2, FullName, bFN, char );
	    New( 2, Name, bName, char );
	    New( 3, DName, bDName, char );
	    if ( FullName == NULL || Name == NULL || DName == NULL ) {
		ErrorHandler( "New names" ) ;
		goto GetCleanup ;
	    }

	    for ( i = 0; i < pDacl->AceCount; i++ ) {
		if ( ! GetAce( pDacl, i, (void **) &pAce ) ) {
		    continue ;
		}

		bDName = bName = MAXIMUM_NAME_LENGTH ;

		switch ( pAce->AceType ) {
		case ACCESS_ALLOWED_ACE_TYPE :
		    pAllAce = (PACCESS_ALLOWED_ACE) pAce ;
		    bName = bDName = MAXIMUM_NAME_LENGTH ;
		    if ( ! LookupAccountSid(
			NULL,		/* CHANGE address of string for system name */
			(PSID) &(pAllAce->SidStart),/* address of security identifier */
			Name,		/* address of string for account name */
			&bName,		/* address of size account string */
			DName,		/* address of string for referenced domain */
			&bDName,        /* address of size domain string */
			&eUse           /* address of structure for SID type */
			) ) {
			Name = NoName ;
		    }

		    if ( bDName ) {
			strcpy( FullName, DName );
			strcat( FullName, "\\" );
			strcat( FullName, Name );
			bFN = bName + bDName + 1 ;
		    } else {
			strcpy( FullName, Name ) ;
			bFN = bName ;
		    }

		    /* This could probably be simplified via hv_fetch lval = TRUE */
		    if ( hv_exists( (HV*)hv, FullName, (U32) bFN ) ) {
			psv = hv_fetch( (HV*)hv, FullName, (U32) bFN, FALSE ) ;
			if ( psv && (sv = *psv) && SvIOK( sv ) ) {
			    sv_setiv( sv, SvIV( sv ) | (IV) pAllAce->Mask ) ;
			} else croak( "MaskBuilder: Not an integer." ) ;
		    } else {
			hv_store( (HV*)hv, FullName, (U32) bFN, sv = newSViv( (IV) pAllAce->Mask ), 0 );
		    }

		    break ;
		    
		default : 
		    ; /* nothing for now... */
		}
	    }

	    RETVAL = TRUE ;

	GetCleanup:
	    checkfree( pSecDesc ) ;
	    checkfree( Name ) ;
	    checkfree( DName ) ;
	    checkfree( FullName ) ;
	}
    OUTPUT:
	RETVAL

bool
Set(filename, hv)
	char *filename
	SV *hv
    CODE:
	{
	    SV* sv ;
	    PACL pACLNew = NULL;
	    PACCESS_ALLOWED_ACE pAllAce ;
	    PSECURITY_DESCRIPTOR pSD = NULL; 
	    DWORD cbACL = 1024, i ; 
	    PSID pSID = NULL; 
	    DWORD cbSID = 1024 ; 
	    ACCESS_MASK AccountRights ;
	    LPSTR    lpszAccount, lpszDomain, lpszServer, lpszTemp ;
	    DWORD cchDomainName = 80, tries ; 
	    PSID_NAME_USE psnuType = NULL; 
	    I32 AccountLen ;

	    RETVAL = FALSE ;

	    if (!(hv && SvROK(hv) && (hv = SvRV(hv)) && SvTYPE(hv) == SVt_PVHV))
		croak( "second arg must be HASHREF" ) ;

	    /* Initialize a new security descriptor. */
 
	    /* SECURITY_DESCRIPTOR_MIN_LENGTH defined in WINNT.H */
	    Newc( 4, pSD, SECURITY_DESCRIPTOR_MIN_LENGTH, char, PSECURITY_DESCRIPTOR );
	    if (pSD == NULL) { 
		ErrorHandler( "Newc SECURITY_DESCRIPTOR"); 
		goto SetCleanup ;
	    } 
 
	    if (!InitializeSecurityDescriptor(pSD, 
					      SECURITY_DESCRIPTOR_REVISION)) { 
		ErrorHandler( "InitializeSecurityDescriptor"); 
		goto SetCleanup; 
	    } 
 
	    /* Initialize a new ACL. */
	    Newc( 5, pACLNew, cbACL, char, ACL ) ; 
	    if (pACLNew == NULL) { 
		ErrorHandler( "Newc pACLNew") ; 
		goto SetCleanup; 
	    } 
 
	    if (!InitializeAcl(pACLNew, cbACL, ACL_REVISION2)) { 
		ErrorHandler( "InitializeAcl"); 
		goto SetCleanup; 
	    } 

	    Newc( 6, pSID, cbSID, char, PSID ) ; 
	    Newc( 7, psnuType, 1024, char, SID_NAME_USE ) ; 
	    Newc( 8, pAllAce, ALLOW_ACE_LENGTH,    char, ACCESS_ALLOWED_ACE ) ; 
	    New( 9, lpszDomain, cchDomainName, char ) ;

	    if (pSID == NULL || psnuType == NULL 
		|| lpszDomain == NULL || pAllAce == NULL ) { 
		ErrorHandler( "Newc names/ace"); 
		goto SetCleanup; 
	    } 

	    /* Initialize Common Ace Hardware */
	    pAllAce->Header.AceType = ACCESS_ALLOWED_ACE_TYPE ;

	    /* Process each pair in *hv
	     * the key should be an Account,
	     * the val should be an ACCESS_MASK
	     */
	    for ( hv_iterinit( (HV*)hv ),
		      sv = hv_iternextsv( (HV*)hv, &lpszAccount, &AccountLen ) ;
		  1 ;
		  sv = hv_iternextsv( (HV*)hv, &lpszAccount, &AccountLen ) ) {
		if ( sv == NULL ) break ;
		if (!SvOK( sv ) ) break ;

		if ( SvNOK( sv ) ) {
		    sv_setiv( sv, (IV) SvNV( sv ) ) ;
		}
		if ( !SvIOK( sv ) ) {
		    continue ;
		}

		/* Retrieve the SID */
		cbSID = 1024 ;
		cchDomainName = 80 ;

		if ( lpszTemp = strchr( lpszAccount, '\\' ) ) {
		    lpszServer = lpszAccount ;
		    *lpszTemp = '\0' ;
		    lpszAccount = lpszTemp + 1 ;
		} else {
		    lpszServer = NULL ;
		}

		if ( lpszServer != NULL ) {
		    for ( i = 0; szLocalLookup[i] != NULL; i++ ) {
			if ( stricmp( szLocalLookup[i], lpszServer ) ) {
			    lpszServer = NULL ;
			    break ;
			}
		    }
		}

		if (!LookupAccountName(
		    (LPCSTR) lpszServer,
		    (LPCSTR) lpszAccount, 
		    pSID, 
		    &cbSID, 
		    lpszDomain, 
		    &cchDomainName, 
		    psnuType)) { 
		    printf( "%s\\%s\n", lpszServer, lpszAccount ) ;
		    ErrorHandler( "LookupAccountName"); 
		    goto SetCleanup; 
		}

		/* Move SID into ACE structure */
		if(!CopySid(
		    ALLOW_ACE_LENGTH - sizeof( ACCESS_ALLOWED_ACE ), 
		    (PSID) &pAllAce->SidStart,
		    pSID
		    ) ) {
		    ErrorHandler( "CopySid" ); 
		    goto SetCleanup; 
		}

		/* I've kludged the GENERIC RIGHTS and STANDARD RIGHTS 
		 * into one mask */
		AccountRights = GENERIC_RIGHTS_MASK & (ACCESS_MASK) SvIV( sv ) ;
		pAllAce->Header.AceFlags = INHERIT_ONLY_ACE | OBJECT_INHERIT_ACE ;
		
		tries = 2 ;
		while (tries--) {
		    /* Add Ace */
		    if ( AccountRights ) {
			pAllAce->Header.AceSize = sizeof( ACCESS_ALLOWED_ACE ) - sizeof( DWORD ) + GetLengthSid( (PSID) pSID  ) ;
			pAllAce->Mask = (ACCESS_MASK) AccountRights ;
			
			if (!AddAce(
			    pACLNew, 
			    ACL_REVISION2, 
			    MAXDWORD, 
			    pAllAce,
			    pAllAce->Header.AceSize 
			    )) { 
			    ErrorHandler( "AddAce"); 
			    goto SetCleanup; 
			}
			/* Second pass we get regular rigts */
			pAllAce->Header.AceFlags = CONTAINER_INHERIT_ACE ;
		    } else {
			/* If no container rights flags on first pass then */
			pAllAce->Header.AceFlags = 0 ;
		    }
		    /* Second pass we get regular rigts */
		    AccountRights = REST_RIGHTS_MASK & (ACCESS_MASK) SvIV( sv ) ;
		}
		
	    }
	    
	    /* Add a new ACL to the security descriptor. */
	    if (!SetSecurityDescriptorDacl(pSD, 
					   TRUE,              /* fDaclPresent flag */
					   pACLNew, 
					   FALSE)) {          /* not a default disc. ACL */
		ErrorHandler( "SetSecurityDescriptorDacl"); 
		goto SetCleanup; 
	    }
	    
	    /* Apply the new security descriptor to the file.  */
	    if (!SetFileSecurity( filename , 
				  DACL_SECURITY_INFORMATION, 
				  pSD)) { 
		ErrorHandler( "SetFileSecurity"); 
		goto SetCleanup; 
	    } 
	    
	    /* Return true */
	    RETVAL = TRUE;
	    
	SetCleanup: 
	    FreeSid( pSID ) ; 
	    checkfree( pSD ) ;
	    checkfree( pACLNew ) ;
	    checkfree( psnuType ) ;
	    checkfree( lpszDomain ) ; 
	}
    OUTPUT:
	RETVAL


