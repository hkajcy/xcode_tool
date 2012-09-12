// jfConvert.h: interface for the CjfConvert class.
// BigLee 2009.01.06 Shanghai,China
//////////////////////////////////////////////////////////////////////

//#if !defined(AFX_JFCONVERT_H__88C5CCE8_ACF0_44D3_B657_D58B463B2807__INCLUDED_)
//#define AFX_JFCONVERT_H__88C5CCE8_ACF0_44D3_B657_D58B463B2807__INCLUDED_
//
//#if _MSC_VER > 1000
//#pragma once
//#endif // _MSC_VER > 1000
//
#define TOTAL_CHAR		2359
#define TOTAL_CHAR_BUF	4724
//
#ifndef _JFCONVERT_H_
#define _JFCONVERT_H_
class CjfConvert  
{
public:
    
#ifdef _MSC_VER
	static CString strCvt(const char *psz,BOOL bToFt);
	static CString strJ2F(const char *psz);
	static CString strF2J(const char *psz);
#endif
    
    bool init(const char *jjFileName,
              const char *jfFileName,
              const char *fjFileName,
              const char *ffFileName);
    
	char * F2J(char *psz);
	char * J2F(char *psz);
	CjfConvert();
	//virtual ~CjfConvert();
	~CjfConvert();
private:
    bool initjjFile(const char *fileName);
    bool initjfFile(const char *fileName);
    bool initfjFile(const char *fileName);
    bool initffFile(const char *fileName);
    
    void freeBuffer();
    
	char* m_szJJ;
	char* m_szJF;
	char* m_szFJ;
	char* m_szFF;
};
#endif
//#endif // !defined(AFX_JFCONVERT_H__88C5CCE8_ACF0_44D3_B657_D58B463B2807__INCLUDED_)
