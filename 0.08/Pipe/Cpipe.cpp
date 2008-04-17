
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include <EXTERN.h>
#include "perl.h"
#include "XSub.h"
#include "CPipe.hpp"
#include "pipe.h"

CPipe::CPipe(char *szName){
	CPipe(szName, DEFAULT_WAIT_TIME);
}

CPipe::CPipe(char *szName, DWORD dWait){
	int	iTemp;
	int	iFlag = 1;
	
	hPipe = 0;                 
	dBufferSize = BUFFER_SIZE;
	dBytes = 0;
			              	
	lpName[PIPE_NAME_SIZE + 1];				
	dwOpenMode = PIPE_ACCESS_DUPLEX;		
	dwPipeMode = 	PIPE_TYPE_BYTE	 |      
					PIPE_READMODE_BYTE	 |  
					PIPE_WAIT;				
	nMaxInstances =	PIPE_UNLIMITED_INSTANCES;
	nOutBufferSize = dBufferSize;			
	nInBufferSize  = dBufferSize;
	nDefaultTimeOut = PIPE_TIMEOUT;			
	lpSecurityAttributes= NULL; 
	iError = 0;
	strcpy((char *)szError, "");
	
	cBuffer = new char [dBufferSize];
	if (! cBuffer){
		dBufferSize = 0;
	}

	memset((void *)szError, 0, ERROR_TEXT_SIZE);
	memset((void *)lpName, 0, PIPE_NAME_SIZE + 1);
	if (strncmp((char *)szName, "\\\\", 2) == 0){
		iPipeType = CLIENT;
		iTemp = 0;
	}else{
		iPipeType = SERVER;
		strcpy((char *)lpName, PIPE_NAME_PREFIX);
		iTemp = strlen(PIPE_NAME_PREFIX);
	}
	strncat((char *)lpName, szName, PIPE_NAME_SIZE - iTemp);

	if(iPipeType == SERVER){
		hPipe = CreateNamedPipe((const char *)lpName,
								dwOpenMode, 
								dwPipeMode, 
								nMaxInstances, 
								nOutBufferSize, 
								nInBufferSize, 
								nDefaultTimeOut,
								lpSecurityAttributes);
	}else{
		while(iFlag){
			hPipe = CreateFile((LPCTSTR) lpName,
								GENERIC_READ | GENERIC_WRITE, 
								FILE_SHARE_READ	| FILE_SHARE_WRITE,
								NULL,
								OPEN_EXISTING,
								FILE_ATTRIBUTE_NORMAL | FILE_FLAG_WRITE_THROUGH,
								NULL);
			if (GetLastError() == ERROR_PIPE_BUSY){
				iFlag = WaitNamedPipe((LPCTSTR)lpName, dWait);
			}else{
				iFlag = 0;
			}
		}
	}
	if (cBuffer == 0){
		iError = 998;
		strcpy((char *)szError, "Could not allocate a buffer for the pipe connection");
	}
	if (hPipe == INVALID_HANDLE_VALUE){
		iError = 999;
		strcpy((char *)szError, "Could not connect");
		delete this;
	}
}									  

CPipe::~CPipe(){
	Disconnect(TRUE);
	if (hPipe){
		CloseHandle(hPipe);
		hPipe = 0;
	}
	if(cBuffer){
		delete cBuffer;
	}
}

DWORD CPipe::BufferSize(){
	return dBufferSize;
}

DWORD CPipe::ResizeBuffer(DWORD dNewSize){
	CHAR	*szNewBuffer;

	if (dNewSize > 0){
		if (szNewBuffer = new char [dNewSize]){
			memset((void *)szNewBuffer, 0, dNewSize);
			delete cBuffer;
			dBufferSize = dNewSize;
			cBuffer = szNewBuffer;
		}
	}
	return dBufferSize;
}

char *CPipe::Read(DWORD *dLen){                   
	BOOL bResult;
	DWORD	cbBytes = 0, cbReply = 0;

	bResult = ReadFile(hPipe, cBuffer, dBufferSize, dLen, NULL); 
	dBytes = *dLen;
	return (bResult)? cBuffer:0;
}

int	CPipe::Write(void *vBuffer, DWORD dSize){
	BOOL bResult;
	DWORD	cbBytes = 0, cbReply = 0;

	bResult = WriteFile(hPipe, vBuffer, dSize, &cbBytes, NULL);
	return bResult;
}

int CPipe::Connect(){
	BOOL bResult;

	bResult = ConnectNamedPipe(hPipe, NULL);

		//	Just in case the pipe is already connected return TRUE even though
		//	ConnectNamedPipe() returned FALSE!
	if (!bResult && GetLastError() == ERROR_PIPE_CONNECTED){
		bResult = 1;
	}
		
	return bResult;
}

int CPipe::Disconnect(int iPurge){
	BOOL	bResult = 0;

	if (iPurge){
		FlushFileBuffers(hPipe);
	}
	if (iPipeType == SERVER){
		bResult = DisconnectNamedPipe(hPipe);
	}
	if (iPipeType == CLIENT){
		bResult = CloseHandle(hPipe);
		hPipe = 0;
	}
	
	return bResult;
}	


int	CPipe::Error(int iErrorNum, char *szErrorText){
	strncpy((char *)szError, szErrorText, ERROR_TEXT_SIZE);
	szError[ERROR_TEXT_SIZE] = '\0';
	iError = iErrorNum;
	return iError;
}

int	CPipe::EndOfFile(){
	return (dBytes)? 1:0;
}
