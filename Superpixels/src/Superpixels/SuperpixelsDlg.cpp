

#include "stdafx.h"
#include "Superpixels.h"
#include "SuperpixelsDlg.h"
#include "PictureHandler.h"
#include "SLIC.h"


CSLICSuperpixelsDlg::CSLICSuperpixelsDlg(CWnd* pParent)
	: CDialog(CSLICSuperpixelsDlg::IDD, pParent)
	, m_spcount(0)
	, m_compactness(0)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSLICSuperpixelsDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_SPCOUNT, m_spcount);
	DDV_MinMaxInt(pDX, m_spcount, 10, 100000);
	DDX_Text(pDX, IDC_EDIT_COMPACTNESS, m_compactness);
	DDV_MinMaxDouble(pDX, m_compactness, 1.0, 50.0);
}

BEGIN_MESSAGE_MAP(CSLICSuperpixelsDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_CREATESUPERPIXELS, &CSLICSuperpixelsDlg::OnBnClickedButtonCreatesuperpixels)
	ON_EN_CHANGE(IDC_EDIT_SPCOUNT, &CSLICSuperpixelsDlg::OnEnChangeEditSpcount)
	ON_EN_CHANGE(IDC_EDIT_COMPACTNESS, &CSLICSuperpixelsDlg::OnEnChangeEditCompactness)
END_MESSAGE_MAP()



BOOL CSLICSuperpixelsDlg::OnInitDialog()
{
	CDialog::OnInitDialog();


	SetIcon(m_hIcon, TRUE);			
	SetIcon(m_hIcon, FALSE);		


	m_spcount = 0;
	m_compactness = 10.0;
	UpdateData(FALSE);

	return TRUE;  
}

void CSLICSuperpixelsDlg::OnEnChangeEditSpcount()
{


	UpdateData(TRUE);
}

void CSLICSuperpixelsDlg::OnEnChangeEditCompactness()
{



	UpdateData(TRUE);
}



void CSLICSuperpixelsDlg::GetPictures(vector<string>& picvec)
{
	CFileDialog cfd(TRUE,NULL,NULL,OFN_OVERWRITEPROMPT,L"*.*|*.*|",NULL);
	cfd.m_ofn.Flags |= OFN_ALLOWMULTISELECT;


	
	CString strFileNames;
	cfd.m_ofn.lpstrFile = strFileNames.GetBuffer(2048);
	cfd.m_ofn.nMaxFile = 2048;

	BOOL bResult = cfd.DoModal() == IDOK ? TRUE : FALSE;
	strFileNames.ReleaseBuffer();


	if( bResult )
	{
		POSITION pos = cfd.GetStartPosition();
		while (pos) 
		{
			CString imgFile = cfd.GetNextPathName(pos);			
			PictureHandler ph;
			string name = ph.Wide2Narrow(imgFile.GetString());
			picvec.push_back(name);
		}
	}
	else return;
}

void CSLICSuperpixelsDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this);

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);


		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;


		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

HCURSOR CSLICSuperpixelsDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CSLICSuperpixelsDlg::OnBnClickedButtonCreatesuperpixels()
{
	PictureHandler picHand;
	vector<string> picvec(0);
	picvec.resize(0);
	GetPictures(picvec);
	string saveLocation = "C:\\rktemp\\";
	BrowseForFolder(saveLocation);

	int numPics( picvec.size() );

	for( int k = 0; k < numPics; k++ )
	{
		UINT* img = NULL;
		int width(0);
		int height(0);

		picHand.GetPictureBuffer( picvec[k], img, width, height );
		int sz = width*height;

		int* labels = new int[sz];
		int numlabels(0);
		SLIC slic;
		slic.DoSuperpixelSegmentation_ForGivenK(img, width, height, labels, numlabels, m_spcount, m_compactness);
		slic.DrawContoursAroundSegments(img, labels, width, height, 0);
		if(labels) delete [] labels;
		
		picHand.SavePicture(img, width, height, picvec[k], saveLocation, 1, "_SuperPixel");
		if(img) delete [] img;
	}
}


bool CSLICSuperpixelsDlg::BrowseForFolder(string& folderpath)
{
	IMalloc* pMalloc = 0;
	if(::SHGetMalloc(&pMalloc) != NOERROR)
	return false;

	BROWSEINFO bi;
	memset(&bi, 0, sizeof(bi));

	bi.hwndOwner = m_hWnd;
	bi.lpszTitle = L"选择处理后的图像存储位置";

	LPITEMIDLIST pIDL = ::SHBrowseForFolder(&bi);
	if(pIDL == NULL)
	return false;

	TCHAR buffer[_MAX_PATH];
	if(::SHGetPathFromIDList(pIDL, buffer) == 0)
	return false;
	PictureHandler pichand;
	folderpath = pichand.Wide2Narrow(buffer);
	folderpath.append("\\");
	return true;
}


