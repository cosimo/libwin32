#define	NULL_VALUE	""


struct ODBC_Conn;

class CResults{
	public:
		CResults(ODBC_Conn *hODBC);
		~CResults();
		char *operator[](int iElement);
		SDWORD  Size(int iElement);
		SDWORD	ReturnSize(int iElement);
		SWORD	NumOfCols();
		DWORD	RowSetSize();
		void	Clean();


	private:
		void	RemoveBuffers();
		SDWORD	*dSize;
		char	**szColumn;
		SDWORD	*dReturnSize;
		SWORD	sNumOfCols;
 		DWORD	dRowSetSize;
		int		iODBC;

};

