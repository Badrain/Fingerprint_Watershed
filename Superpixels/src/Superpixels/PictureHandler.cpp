#include "stdafx.h"
#include "PictureHandler.h"
#include <mbctype.h>  


PictureHandler::PictureHandler()
{
	StartUpGdiPlus();
}

PictureHandler::~PictureHandler()
{
	ShutDownGdiPlus();
}

void PictureHandler::StartUpGdiPlus()
{
	m_gdiplusStartupInput = new GdiplusStartupInput();
	Status stat = GdiplusStartup(&m_gdiplusToken, m_gdiplusStartupInput, NULL);
	_ASSERT( stat == Ok );
}

void PictureHandler::ShutDownGdiPlus()
{
	if (m_gdiplusToken != NULL)
	{
		GdiplusShutdown(m_gdiplusToken);
		delete m_gdiplusStartupInput;
		m_gdiplusStartupInput = NULL;
		m_gdiplusToken = NULL;
	}
}


int PictureHandler::GetEncoderClsid(const WCHAR* format, CLSID* pClsid)
{
   UINT  num = 0;          
   UINT  size = 0;         

   ImageCodecInfo* pImageCodecInfo = NULL;

   GetImageEncodersSize(&num, &size);
   if(size == 0)
      return -1;  

   pImageCodecInfo = (ImageCodecInfo*)(malloc(size));
   if(pImageCodecInfo == NULL)
      return -1;  

   GetImageEncoders(num, size, pImageCodecInfo);

   for(UINT j = 0; j < num; ++j)
   {
      if( wcscmp(pImageCodecInfo[j].MimeType, format) == 0 )
      {
         *pClsid = pImageCodecInfo[j].Clsid;
         free(pImageCodecInfo);
         return j;  
      }    
   }

   free(pImageCodecInfo);
   return -1;  
}

wstring PictureHandler::Narrow2Wide(const std::string& narrowString)
{
	int m_codepage = _getmbcp();

	int numChars =
	::MultiByteToWideChar( m_codepage, 
						   MB_PRECOMPOSED, 
						   narrowString.c_str(), 
						   -1, 
						   0, 
						   0
						  );
	_ASSERT(numChars);

	wchar_t* test = new wchar_t[numChars+1];
	numChars =
	::MultiByteToWideChar( m_codepage, 
						   MB_PRECOMPOSED, 
						   narrowString.c_str(), 
						   -1, 
						   test, 
						   numChars
						  );

	std::wstring temp(test);
	delete []test;

	return temp;
}
string PictureHandler::Wide2Narrow(const wstring& wideString)
{
	int m_codepage = ::_getmbcp();

	int result = ::WideCharToMultiByte( 
							m_codepage,  
							0,		
							wideString.c_str(), 
							-1,		
							0,      
							0,		
							0,		
							0		
						 );
	_ASSERT(result);
	char *test = new char[result+1]; 
	result = ::WideCharToMultiByte( 
							m_codepage,  
							0,		
							wideString.c_str(), 
							-1,		
							test,   
							result,	
							0,		
							0		
						 );

	std::string temp(test);
	delete []test;

	return temp;
}

void PictureHandler::GetPictureBuffer(
	string&				filename,
	vector<UINT>&		imgBuffer,
	int&				width,
	int&				height)
{
	Bitmap* bmp				= Bitmap::FromFile((Narrow2Wide(filename)).c_str());
	BitmapData*	bmpData		= new BitmapData;
	height					= bmp->GetHeight();
	width					= bmp->GetWidth();
	long imgSize			= height*width;
	
	Rect rect(0, 0, width, height);
	bmp->LockBits(
		&rect,
		ImageLockModeWrite,
		PixelFormat32bppARGB,
		bmpData);

	_ASSERT( bmpData->Stride/4 == width );

	imgBuffer.resize(imgSize);

	UINT* tempBuff = (UINT*)bmpData->Scan0;
	for( int p = 0; p < imgSize; p++ ) imgBuffer[p] = tempBuff[p];

	bmp->UnlockBits(bmpData);
}


void PictureHandler::SavePicture(
	vector<UINT>&		imgBuffer,
	int					width,
	int					height,
	string&				outFilename,
	string&				saveLocation,
	int					format,
	const string&		str)
{
	int sz = width*height;
	UINT* uintBuffer = new UINT[sz];

	for( int p = 0; p < sz; p++ ) uintBuffer[p] = imgBuffer[p];

	Bitmap bmp(width, height, width*sizeof(UINT), PixelFormat32bppARGB, (unsigned char *)uintBuffer);

	CLSID picClsid;
	if( 1 == format ) GetEncoderClsid(L"image/jpeg", &picClsid);
	if( 0 == format ) GetEncoderClsid(L"image/bmp",  &picClsid);

	string path = saveLocation;

	char fname[_MAX_FNAME];
	_splitpath(outFilename.c_str(), NULL, NULL, fname, NULL);

	path += fname;

	if( 0 != str.compare("") ) path.append(str);
	if( 1 == format ) path.append(".jpg");
	if( 0 == format ) path.append(".bmp");

	wstring wholepath = Narrow2Wide(path);
	const WCHAR* wp = wholepath.c_str();

	Status st = bmp.Save( wp, &picClsid, NULL );
	_ASSERT( st == Ok );

	if(uintBuffer) delete [] uintBuffer;
}

void PictureHandler::GetPictureBuffer(
	string&			filename,
	UINT*&				imgBuffer,
	int&				width,
	int&				height)
{
	Bitmap* bmp				= Bitmap::FromFile((Narrow2Wide(filename)).c_str());
	BitmapData*	bmpData		= new BitmapData;
	height					= bmp->GetHeight();
	width					= bmp->GetWidth();
	long imgSize			= height*width;
	
	Rect rect(0, 0, width, height);

	bmp->LockBits(
		&rect,
		ImageLockModeWrite,
		PixelFormat32bppARGB,
		bmpData);

	_ASSERT( bmpData->Stride/4 == width );

	if( bmpData->Stride/4 != width )
		return;

	imgBuffer = new UINT[imgSize];

	memcpy( imgBuffer, (UINT*)bmpData->Scan0, imgSize*sizeof(UINT) );

	bmp->UnlockBits(bmpData);
}


void PictureHandler::SavePicture(
	UINT*&				imgBuffer,
	int					width,
	int					height,
	string&				outFilename,
	string&				saveLocation,
	int					format,
	const string&		str)
{
	int sz = width*height;

	Bitmap bmp(width, height, width*sizeof(UINT), PixelFormat32bppARGB, (unsigned char *)imgBuffer);

	CLSID picClsid;
	if( 1 == format ) GetEncoderClsid(L"image/jpeg", &picClsid);
	if( 0 == format ) GetEncoderClsid(L"image/bmp",  &picClsid);

	string path = saveLocation;
	char fname[_MAX_FNAME];
	_splitpath(outFilename.c_str(), NULL, NULL, fname, NULL);
	path += fname;

	if( 0 != str.compare("") ) path.append(str);
	if( 1 == format ) path.append(".jpg");
	if( 0 == format ) path.append(".bmp");

	wstring wholepath = Narrow2Wide(path);
	const WCHAR* wp = wholepath.c_str();

	Status st = bmp.Save( wp, &picClsid, NULL );
	_ASSERT( st == Ok );
}
