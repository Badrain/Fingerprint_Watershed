#include "stdafx.h"
#include "Superpixels.h"
#include "SuperpixelsDlg.h"




BEGIN_MESSAGE_MAP(CSLICSuperpixelsApp, CWinAppEx)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()




CSLICSuperpixelsApp::CSLICSuperpixelsApp()
{
	// TODO: ���캯��

}



CSLICSuperpixelsApp theApp;



BOOL CSLICSuperpixelsApp::InitInstance()
{
	CWinAppEx::InitInstance();


	// TODO: �ڴ���Ӵ���

	SetRegistryKey(_T("Local AppWizard-Generated Applications"));

	CSLICSuperpixelsDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: �ڴ���Ӵ���

	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: �ڴ���Ӵ���

	}


	return FALSE;
}
