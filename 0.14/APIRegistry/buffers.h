/* buffers.h -- Version 1.01 */

/* The following abbreviations are used at start of variable names to indicate
 * the type of data:
 *	s	string (char * or WCHAR *) [PV]
 *	p	pointer (usually to some structure) [PV]
 *	i	integral type [IV or UV]
 *	n	floating-point number (double) [NV]
 *	b	boolean (bool) [IV]
 *	c	count of items [UV]
 *	l	length (in bytes) [UV]
 *	lw	length in WCHARs [UV]
 *	h	hash [HV]
 *	a	array [AV]
 *	r	reference [RV]
 *	sv	scalar value (s, i, n, or r) [SV]
 *	h	a handle [IV]
 */

/* Buffer arguments are usually followed by an argument specifying their size.
 * The size can be measured in bytes ["lSize"] or in characters [also "lSize"
 * for *A() routines that use C<char>s but "lwSize" for *W() routines that use
 * C<WCHAR>s for UNICODE].
 *
 * Before calling the actual C function, you must make sure the Perl variable
 * actually has a big enough buffer allocated, and, if the user didn't want
 * to specify a buffer size, set the buffer size to be correct.  This is what
 * the grow_*() macros are for.  They also handle special meanings of the
 * buffer size argument [described below].
 *
 * Once the actual C function returns, you must set the Perl variable to know
 * the size of the written data.  This is what the trunc_*() macros are for.
 *
 * The size sometimes does and sometimes doesn't include the trailing '\0'
 * (or L'\0'), so we always add or substract 1 in the appropriate places so
 * we don't care about this detail.
 *
 * A call may  1) request a pointer to the buffer size which means that
 * the buffer size will be overwritten with the size of the data written;
 * 2) have an extra argument which is a pointer to the place to write the
 * size of the written data;  or  3) provide the size of the written data
 * in the function's return value.  This obviously determines what you should
 * use in the trunc_*() macro to specify the size of the output value.
 *
 * The user can pass in an empty list reference, C<[]>, to indicate NULL for
 * the pointer to the buffer which means that they don't want that data.
 * The user can pass in C<[]> or C<0> to indicate that they don't care about
 * the buffer size [we aren't programming in C here, after all] and just try
 * to get the data.
 *
 * If the user passes in a positive value for a buffer size, then the XS
 * code makes sure that the buffer is at least large enough to hold a value
 * of that size and then passes in how large the buffer is.  So the buffer
 * size passed to the API call is the larger of the size requested by the
 * user and the size of the buffer previously allocated.
 *
 * The user can also pass in a string consisting of a leading "=" followed
 * by digits for a buffer size.  This means just use the size specified after
 * the equals sign, even if the allocated buffer is larger.  The XS code will
 * still ensure that the buffer is large enough.
 *
 * If the function is nice enough to tell us that a buffer was too small
 * [usually via ERROR_MORE_DATA] _and_ how large the buffer needs to be,
 * then the XS code should enlarge the buffer(s) and repeat the call [once],
 * but only if the caller didn't specify a negative buffer size.
 *
 * Only grow_buf() and perhaps trunc_buf() can be used in the typemap file.
 *
 * Here is a made-up example that shows several cases:
 *
 * bool		# GetDataW() actually returns length of value written to sName
 * GetDataW( sName, lwName, sTxt, plwTxt, pStuff, pRec, lRecIn, plRecOut )
 *	WCHAR *	sName
 *	DWORD	lwName
 *	WCHAR *	sTxt
 *	DWORD *	plwTxt
 *	void *	pStuff
 *	void *	pRec
 *	DWORD	lRecIn
 *	DWORD *	plRecOut
 * INIT:
 *	DWORD	lwNameOut;
 * CODE:
 *	grow_buf_lw( sName,ST(0), lwName,ST(1) );
 *	grow_buf_plw( sTxt,ST(2), plwTxt,ST(3) );
 *	grow_buf_typ( pStuff,ST(4), REALLY_LONG_STRUCT_TYPEDEF );
 *	grow_buf_l( pRec,ST(5), lRecIn,ST(6) );
 *	lwNameOut= GetDataW( sName, lwName, sTxt, plwTxt, pStuff,
 *			pRec, lRecIn, plRecOut );
 *	if(  0 == lwNameOut  &&  ERROR_MORE_DATA == GetLastError()
 *	 &&  ( autosize(ST(3)) || autosize(ST(6)) )  ) {
 *	    grow_buf_plw( sTxt,ST(2), plwTxt,ST(3) );
 *	    lRecIn= *plRecOut;
 *	    grow_buf_l( pRec,ST(5), lRecIn,ST(6) );
 *	    lwNameOut= GetDataW( sName, lwName, sTxt, plwTxt, pStuff,
 * 			pRec, lRecIn, plRecOut );
 *	}
 *	RETVAL=  0 != lwNameOut;
 *	trunc_buf_lw( RETVAL, sName,ST(0), lwNameOut );
 *	trunc_buf_plw( RETVAL, sTxt,ST(2), plwTxt );
 *	trunc_buf_typ( RETVAL, pStuff,ST(4), REALLY_LONG_STRUCT_TYPEDEF );
 *	trunc_buf_pl( RETVAL, pRec,ST(5), plRecOut );
 * OUTPUT:
 *	RETVAL
 *	plwTxt
 *	plRecOut
 */

#ifndef Debug
# define	Debug(list)	/*Nothing*/
#endif

/* Is an argument C<[]>, meaning we should pass C<NULL>? */
#define null_arg(sv)	(  SvROK(sv)  &&  SVt_PVAV == SvTYPE(SvRV(sv))	\
			   &&  -1 == av_len((AV*)SvRV(sv))  )

#define PV_or_null(sv)	( null_arg(sv) ? NULL : SvPV(sv,na) )

/* Minimum buffer size to use when no buffer existed: */
#define MIN_GROW_SIZE	8

#ifdef Debug
/* Used in Debug() messages to show which macro call is involved: */
#define string(arg) #arg
#endif

/* Simplify using SvGROW() for byte-sized buffers: */
#define lSvGROW(sv,n)	(void *) SvGROW( sv, 0==(n) ? MIN_GROW_SIZE : (n)+1 )

/* Simplify using SvGROW() for WCHAR-sized buffers: */
#define lwSvGROW(sv,n)	(WCHAR *) SvGROW( sv, sizeof(WCHAR)*	\
			    ( 0==(n) ? MIN_GROW_SIZE : (n)+1 ) )

/* Whether the buffer size we got lets us change what buffer size we use: */
#define autosize(sv)	\
	(  SvROK(sv)  ||  ! SvPV(sv,na)  ||  '=' != *SvPV(sv,na)  )

/* Grow a buffer where we have a pointer to its size in bytes: */
#define	grow_buf_pl( sBuf,svBuf, plSize,svSize )	STMT_START {	\
	if(  ! autosize(svSize)  )					\
	    *plSize= strtoul( 1+SvPV(svSize,na), NULL, 10 );		\
	if(  ! null_arg(svBuf)  ) {					\
	    if(  NULL == plSize  )					\
		*( plSize= (DWORD *) _alloca( sizeof(DWORD) ) )= 0;	\
	    if(  ! SvOK(svBuf)  )    sv_setpvn(svBuf,"",0);		\
	    sBuf= (void *) SvPV_force( svBuf, na );			\
	    sBuf= lSvGROW( svBuf, *plSize );				\
	    if(  autosize(svSize)  )   *plSize= SvLEN(svBuf) - 1;	\
	} } STMT_END

/* Grow a buffer where we have a pointer to its size in WCHARs: */
#define	grow_buf_plw( sBuf,svBuf, plwSize,svSize )	STMT_START {	\
	if(  ! autosize(svSize)  )					\
	    *plwSize= strtoul( 1+SvPV(svSize,na), NULL, 10 );		\
	if(  ! null_arg(svBuf)  ) {					\
	    if(  NULL == plwSize  )					\
		*( plwSize= (DWORD *) _alloca( sizeof(DWORD) ) )= 0;	\
	    if(  ! SvOK(svBuf)  )    sv_setpvn(svBuf,"",0);		\
	    sBuf= (WCHAR *) SvPV_force( svBuf, na );			\
	    sBuf= lwSvGROW( svBuf, *plwSize );				\
	    if(  autosize(svSize)  )					\
		*plwSize= SvLEN(svBuf)/sizeof(WCHAR) - 1;		\
	} } STMT_END

/* Grow a buffer where we have its size in bytes: */
#define	grow_buf_l( sBuf,svBuf, lSize,svSize )		STMT_START {	\
	if(  ! autosize(svSize)  )					\
	    lSize= strtoul( 1+SvPV(svSize,na), NULL, 10 );		\
	if(  ! null_arg(svBuf)  ) {					\
	    if(  ! SvOK(svBuf)  )    sv_setpvn(svBuf,"",0);		\
	    sBuf= (void *) SvPV_force( svBuf, na );			\
	    sBuf= lSvGROW( svBuf, lSize );				\
	    if(  autosize(svSize)  )   lSize= SvLEN(svBuf) - 1;		\
	} } STMT_END

/* Grow a buffer where we have its size in WCHARs: */
#define	grow_buf_lw( sBuf,svBuf, lwSize,svSize )	STMT_START {	\
	if(  ! autosize(svSize)  )					\
	    lwSize= strtoul( 1+SvPV(svSize,na), NULL, 10 );		\
	if(  ! null_arg(svBuf)  ) {					\
	    if(  ! SvOK(svBuf)  )    sv_setpvn(svBuf,"",0);		\
	    sBuf= (WCHAR *) SvPV_force( svBuf, na );			\
	    sBuf= lwSvGROW( svBuf, lwSize );				\
	    if(  autosize(svSize)  )					\
	    	lwSize= SvLEN(svBuf)/sizeof(WCHAR) - 1;			\
	} } STMT_END

/* Grow a buffer that contains the declared fixed data type: */
#define	grow_buf( pBuf,svBuf, pType )			STMT_START {	\
	if(  null_arg(svBuf)  ) {					\
	    pBuf= (pType) NULL;						\
	} else {							\
	    if(  ! SvOK(svBuf)  )    sv_setpvn(svBuf,"",0);		\
	    (void) SvPV_force( svBuf, na );				\
	    pBuf= (pType) SvGROW( svBuf, sizeof(*pBuf) );		\
	} } STMT_END

/* Grow a buffer that contains a fixed data type other than that declared: */
#define	grow_buf_typ( pBuf,svBuf, Type )		STMT_START {	\
	if(  ! null_arg(svBuf)  ) {					\
	    if(  ! SvOK(svBuf)  )    sv_setpvn(svBuf,"",0);		\
	    (void) SvPV_force( svBuf, na );				\
	    pBuf= (Type *) SvGROW( svBuf, sizeof(Type) );		\
	} } STMT_END

#define	trunc_buf_pl( bOkay, sBuf,svBuf, plSize )			\
	trunc_buf_l( bOkay, sBuf,svBuf, *plSize )

#define	trunc_buf_plw( bOkay, sBuf,svBuf, plwSize )			\
	trunc_buf_lw( bOkay, sBuf,svBuf, *plwSize )

/* Set data length for a buffer where we have a its size in bytes: */
#define	trunc_buf_l( bOkay, sBuf,svBuf, lSize )		STMT_START {	\
	if(  bOkay  &&  NULL != sBuf  ) {				\
	    SvPOK_only( svBuf );					\
	    SvCUR_set( svBuf, lSize );					\
	} } STMT_END

/* Set data length for a buffer where we have a its size in WCHARs: */
#define	trunc_buf_lw( bOkay, sBuf,svBuf, lwSize )	STMT_START {	\
	if(  bOkay  &&  NULL != sBuf  ) {				\
	    SvPOK_only( svBuf );					\
	    SvCUR_set( svBuf, (lwSize)*sizeof(WCHAR) );			\
	} } STMT_END

/* Set data length for a buffer that contains the declared fixed data type: */
#define	trunc_buf( bOkay, pBuf,svBuf )			STMT_START {	\
	if(  bOkay  &&  NULL != pBuf  ) {				\
	    SvPOK_only( svBuf );					\
	    SvCUR_set( svBuf, sizeof(*pBuf) );				\
	} } STMT_END

/* Set data length for a buffer that contains some other fixed data type: */
#define	trunc_buf_typ( bOkay, pBuf,svBuf, Type )	STMT_START {	\
	if(  bOkay  &&  NULL != pBuf  ) {				\
	    SvPOK_only( svBuf );					\
	    SvCUR_set( svBuf, sizeof(Type) );				\
	} } STMT_END
