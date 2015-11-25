#include "stdafx.h"
#include "Superpixels.h"
#include "SuperpixelsDlg.h"




BEGIN_MESSAGE_MAP(CSLICSuperpixelsApp, CWinAppEx)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()




CSLICSuperpixelsApp::CSLICSuperpixelsApp()
{
	// TODO: 构造函数

}



CSLICSuperpixelsApp theApp;



BOOL CSLICSuperpixelsApp::InitInstance()
{
	CWinAppEx::InitInstance();


	// TODO: 在此添加代码

	SetRegistryKey(_T("Local AppWizard-Generated Applications"));

	CSLICSuperpixelsDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: 在此添加代码

	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: 在此添加代码

	}


	return FALSE;
}
