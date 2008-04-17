#ifdef _ADMINMISC_H_

	#define RETURNRESULT(x)		if((x)){ XST_mYES(0); }\
	                     		else { XST_mNO(0); }\
	                     		XSRETURN(1)

	#define SETIV(index,value) sv_setiv(ST(index), value)
	#define SETPV(index,string) sv_setpv(ST(index), string)

	HINSTANCE	ghDLL;
	int			iWinsockActive = 0;
	int			wsErrorStatus;
	WSADATA		wsaData;


#else

	extern	HINSTANCE	ghDLL;
	extern	int			iWinsockActive;
	extern	int			wsErrorStatus;
	extern	WSADATA		wsaData;

#endif
	int	ChangePassword(char *szDomain, char *szUser, char *szOldPassword, char *szNewPassword);
	BOOL WINAPI DllMain(HINSTANCE  hinstDLL, DWORD fdwReason, LPVOID  lpvReserved);
