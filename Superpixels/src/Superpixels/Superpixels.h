
#pragma once


#include "resource.h"




class CSLICSuperpixelsApp : public CWinAppEx
{
public:
	CSLICSuperpixelsApp();

	public:
	virtual BOOL InitInstance();


	DECLARE_MESSAGE_MAP()
};

extern CSLICSuperpixelsApp theApp;