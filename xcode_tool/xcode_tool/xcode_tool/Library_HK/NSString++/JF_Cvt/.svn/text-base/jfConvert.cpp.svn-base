// jfConvert.cpp: implementation of the CjfConvert class.
//
//////////////////////////////////////////////////////////////////////

#include "jfConvert.h"
#include "stdio.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
// //////////////////////////////////////////////////////////////////////
// 

CjfConvert::CjfConvert()
{
    m_szJJ = NULL;
    m_szJF = NULL;
    m_szFJ = NULL;
    m_szFF = NULL;
}

void CjfConvert::freeBuffer()
{
    if (m_szJJ)
    {
        delete m_szJJ;
        m_szJJ = NULL;
    }
    
    if (m_szJF)
    {
        delete m_szJF;
        m_szJF = NULL;
    }
    
    if (m_szFJ)
    {
        
        delete m_szFJ;
        m_szFJ = NULL;
    }
    
    if (m_szFF)
    {
        printf("delete m_szFF;\n");
        delete m_szFF;
        m_szFF = NULL;
    }
}

CjfConvert::~CjfConvert()
{
    freeBuffer();
}



bool CjfConvert::initjjFile(const char *fileName)
{
    FILE*  fp;//文件指针
    fp = fopen(fileName,"r"); 
    
    if (NULL == fp ) 
    {
        return false;
    }
    
    fseek(fp, 0, SEEK_END);
    int fileLength = ftello(fp);
    fseek(fp, 0, SEEK_SET);
    
    m_szJJ = new char[fileLength];
    
    if(!fread(m_szJJ, 1, fileLength, fp))
    {
        return false;
    }
    
    return true;
}
bool CjfConvert::initjfFile(const char *fileName)
{
    FILE*  fp;//文件指针
    fp = fopen(fileName,"r"); 
    
    if (NULL == fp ) 
    {
        return false;
    }
    
    fseek(fp, 0, SEEK_END);
    int fileLength = ftello(fp);
    fseek(fp, 0, SEEK_SET);
    m_szJF = new char[fileLength];
    
    if(!fread(m_szJF, 1, fileLength, fp))
    {
        return false;
    }
    
    return true;
}
bool CjfConvert::initfjFile(const char *fileName)
{
    FILE*  fp;//文件指针
    fp = fopen(fileName,"r"); 
    
    if (NULL == fp ) 
    {
        return false;
    }
    
    fseek(fp, 0, SEEK_END);
    int fileLength = ftello(fp);
    fseek(fp, 0, SEEK_SET);
    m_szFJ = new char[fileLength];
    
    if(!fread(m_szFJ, 1, fileLength, fp))
    {
        return false;
    }
    
    return true;
}
bool CjfConvert::initffFile(const char *fileName)
{
    FILE*  fp;//文件指针
    fp = fopen(fileName,"r"); 
    
    if (NULL == fp ) 
    {
        return false;
    }
    
    fseek(fp, 0, SEEK_END);
    int fileLength = ftello(fp);
    fseek(fp, 0, SEEK_SET);
    m_szFF = new char[fileLength];
    printf("m_szFF = new char[fileLength];\n");
    if(!fread(m_szFF, 1, fileLength, fp))
    {
        return false;
    }
    
    return true;
}

bool CjfConvert::init(const char *jjFileName,
                      const char *jfFileName,
                      const char *fjFileName,
                      const char *ffFileName)
{
    //通过m_szJJ来判断是否初始化过
    if (m_szJJ == NULL)
    {
        if (!initjjFile(jjFileName))
        {
            freeBuffer();
            return false;
        }
        
        if (!initjfFile(jfFileName))
        {
            freeBuffer();
            return false;
        }
        
        if (!initfjFile(fjFileName))
        {
            freeBuffer();
            return false;
        }
        
        if (!initffFile(ffFileName))
        {
            freeBuffer();
            return false;
        }
    }
    
    
    return true;
}
char * CjfConvert::J2F(char *psz)
{
	int iLow,iHigh,iMid,iCompare;
	char *p=psz;
	unsigned short *w;
	unsigned short *t=(unsigned short *)m_szJJ;
	unsigned short *tr=(unsigned short *)m_szJF;
	while(*p)
	{
		if(*p > 0)
		{
			p++;
			continue;
		}
		w = (unsigned short *)p;
		iLow	= 0;
		iHigh	= TOTAL_CHAR-1;
		while(iLow<=iHigh)
		{
			iMid=(iLow+iHigh)/2;
			iCompare = t[iMid]-*w;		
			if(iCompare>0)		iHigh	=iMid-1;
			else if(iCompare<0) iLow	=iMid+1;  
			else 
			{
				*w = tr[iMid];
				break;
			}
		}	
		p += 2;
	}

	return psz;

}

char * CjfConvert::F2J(char *psz)
{
	int iLow,iHigh,iMid,iCompare;
	char *p=psz;
	unsigned short *w;
	unsigned short *t=(unsigned short *)m_szFF;
	unsigned short *tr=(unsigned short *)m_szFJ;
	while(*p)
	{
		if(*p > 0)
		{
			p++;
			continue;
		}
		w = (unsigned short *)p;
		iLow	= 0;
		iHigh	= TOTAL_CHAR-1;
		while(iLow<=iHigh)
		{
			iMid=(iLow+iHigh)/2;
			iCompare = t[iMid]-*w;		
			if(iCompare>0)		iHigh	=iMid-1;
			else if(iCompare<0) iLow	=iMid+1;  
			else 
			{
				*w = tr[iMid];
				break;
			}
		}	
		p += 2;
	}

	return psz;
}

// #ifdef _MSC_VER
// 
// CString CjfConvert::strF2J(const char *psz)
// {
// 	int iLen = strlen(psz)+1;
// 	if(iLen > 512)
// 	{
// 		char *p=new char[iLen];
// 		strcpy(p,psz);
// 		CString str(F2J(p));
// 		delete p;
// 		return str;
// 	}
// 	else
// 	{
// 		char sz[512]={0};
// 		strcpy(sz,psz);
// 		CString str(F2J(sz));
// 		return str;
// 	}
// 
// }
// 
// CString CjfConvert::strJ2F(const char *psz)
// {
// 	int iLen = strlen(psz)+1;
// 	if(iLen > 512)
// 	{
// 		char *p=new char[iLen];
// 		strcpy(p,psz);
// 		CString str(J2F(p));
// 		delete p;
// 		return str;
// 	}
// 	else
// 	{
// 		char sz[512]={0};
// 		strcpy(sz,psz);
// 		CString str(J2F(sz));
// 		return str;
// 	}
// }
// 
// CString CjfConvert::strCvt(const char *psz, BOOL bToFt)
// {
// 	if(bToFt)	return strJ2F(psz);
// 	else		return strF2J(psz);
// }
// 
// #endif

