#include <gdiplus.h>
#include <vector>
#include <algorithm>

namespace Gdiplus	{
					class  Bitmap;
					class  Graphics;
					struct GdiplusStartupInput;
					}

using namespace Gdiplus;
using namespace std;


class PictureHandler  
{
public:
	PictureHandler();
	virtual ~PictureHandler();

	void							GetPictureBuffer(
										string&				filename,
										vector<UINT>&		outBuff,
										int&				width,
										int&				height);

	void							SavePicture(
										vector<UINT>&		imgBuffer,
										int					width,
										int					height,
										string&				outFilename,
										string&				saveLocation,
										int					format,
										const string&		str = "");

	void							GetPictureBuffer(
										string&				filename,
										UINT*&				outBuff,
										int&				width,
										int&				height);

	void							SavePicture(
										UINT*&				imgBuffer,
										int					width,
										int					height,
										string&				outFilename,
										string&				saveLocation,
										int					format = 1,
										const string&		str = "");

	wstring							Narrow2Wide(
										const string&		narrowString);

	string							Wide2Narrow(
										const wstring&		wideString);

private:
	void							StartUpGdiPlus();
	void							ShutDownGdiPlus();

	int								GetEncoderClsid(
										const WCHAR*		format,
										CLSID*				pClsid);

private:
	ULONG_PTR						m_gdiplusToken;
	GdiplusStartupInput*			m_gdiplusStartupInput;

};
