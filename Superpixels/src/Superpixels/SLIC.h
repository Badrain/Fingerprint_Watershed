#include <vector>
#include <string>
#include <algorithm>
using namespace std;


class SLIC  
{
public:
	SLIC();
	virtual ~SLIC();
	void DoSuperpixelSegmentation_ForGivenStepSize(
		const unsigned int*			ubuff,
		const int					width,
		const int					height,
		int*						klabels,
		int&						numlabels,
		const int&					STEP,
		const double&				m);

	void DoSuperpixelSegmentation_ForGivenK(
		const unsigned int*			ubuff,
		const int					width,
		const int					height,
		int*						klabels,
		int&						numlabels,
		const int&					K,
		const double&				m);

	void DoSupervoxelSegmentation(
		const unsigned int**		ubuffvec,
		const int&					width,
		const int&					height,
		const int&					depth,
		int**						klabels,
		int&						numlabels,
		const int&					STEP,
		const double&				m);

	void SaveSuperpixelLabels(
		const int*&					labels,
		const int&					width,
		const int&					height,
		const string&				filename,
		const string&				path);

	void SaveSupervoxelLabels(
		const int**&				labels,
		const int&					width,
		const int&					height,
		const int&					depth,
		const string&				filename,
		const string&				path);

	void DrawContoursAroundSegments(
		unsigned int*				segmentedImage,
		const int*					labels,
		const int&					width,
		const int&					height,
		const unsigned int&			color );

private:

	void PerformSuperpixelSLIC(
		vector<double>&				kseedsl,
		vector<double>&				kseedsa,
		vector<double>&				kseedsb,
		vector<double>&				kseedsx,
		vector<double>&				kseedsy,
		int*						klabels,
		const int&					STEP,
		const vector<double>&		edgemag,
		const double&				m);

	void PerformSupervoxelSLIC(
		vector<double>&				kseedsl,
		vector<double>&				kseedsa,
		vector<double>&				kseedsb,
		vector<double>&				kseedsx,
		vector<double>&				kseedsy,
		vector<double>&				kseedsz,
		int**						klabels,
		const int&					STEP,
		const double&				m);

	void GetLABXYSeeds_ForGivenStepSize(
		vector<double>&				kseedsl,
		vector<double>&				kseedsa,
		vector<double>&				kseedsb,
		vector<double>&				kseedsx,
		vector<double>&				kseedsy,
		const int&					STEP,
		const bool&					perturbseeds,
		const vector<double>&		edgemag);

	void GetLABXYSeeds_ForGivenK(
		vector<double>&				kseedsl,
		vector<double>&				kseedsa,
		vector<double>&				kseedsb,
		vector<double>&				kseedsx,
		vector<double>&				kseedsy,
		const int&					STEP,
		const bool&					perturbseeds,
		const vector<double>&		edges);

	void GetKValues_LABXYZ(
		vector<double>&				kseedsl,
		vector<double>&				kseedsa,
		vector<double>&				kseedsb,
		vector<double>&				kseedsx,
		vector<double>&				kseedsy,
		vector<double>&				kseedsz,
		const int&					STEP);

	void PerturbSeeds(
		vector<double>&				kseedsl,
		vector<double>&				kseedsa,
		vector<double>&				kseedsb,
		vector<double>&				kseedsx,
		vector<double>&				kseedsy,
		const vector<double>&		edges);

	void DetectLabEdges(
		const double*				lvec,
		const double*				avec,
		const double*				bvec,
		const int&					width,
		const int&					height,
		vector<double>&				edges);

	void RGB2XYZ(
		const int&					sR,
		const int&					sG,
		const int&					sB,
		double&						X,
		double&						Y,
		double&						Z);

	void RGB2LAB(
		const int&					sR,
		const int&					sG,
		const int&					sB,
		double&						lval,
		double&						aval,
		double&						bval);

	void DoRGBtoLABConversion(
		const unsigned int*&		ubuff,
		double*&					lvec,
		double*&					avec,
		double*&					bvec);

	void DoRGBtoLABConversion(
		const unsigned int**&		ubuff,
		double**&					lvec,
		double**&					avec,
		double**&					bvec);


	void EnforceLabelConnectivity(
		const int*					labels,
		const int&					width,
		const int&					height,
		int*						nlabels,
		int&						numlabels,
		const int&					K); 


	void FindNext(
		const int*					labels,
		int*						nlabels,
		const int&					height,
		const int&					width,
		const int&					h,
		const int&					w,
		const int&					lab,
		int*						xvec,
		int*						yvec,
		int&						count);


	void EnforceLabelConnectivity_supervoxels(
		const int&					width,
		const int&					height,
		const int&					depth,
		int**						nlabels,
		int&						numlabels,
		const int&					STEP);


	void FindNext_supervoxels(
		int**						labels,
		int**						nlabels,
		const int&					depth,
		const int&					height,
		const int&					width,
		const int&					d,
		const int&					h,
		const int&					w,
		const int&					lab,
		int*						xvec,
		int*						yvec,
		int*						zvec,
		int&						count);

private:
	int										m_width;
	int										m_height;
	int										m_depth;

	double*									m_lvec;
	double*									m_avec;
	double*									m_bvec;

	double**								m_lvecvec;
	double**								m_avecvec;
	double**								m_bvecvec;
};
