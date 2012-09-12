/*
============================================================================
Name		: UMDDecode.h
Author		: PanZhenyu
Copyright	: PanZhenyu
MSN&Email	: panzhenyu88@gmail.com
============================================================================
*/

#ifndef __UMDDECODE_H__
#define __UMDDECODE_H__

#define  MAXBUFFERSIZE 1024

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <memory.h>
#include <string.h>
#include <vector>

class UMDDecode
{
public:
	UMDDecode();
	~UMDDecode();
public:
	bool Parse(const char *pFileName);
    
    int  readFile(unsigned int relativeOffset, unsigned char* buffer, unsigned int length);
    int  fileLength();
    unsigned char * m_pCover;
    unsigned int    m_nCoverLength;
    unsigned int    m_nCoverType;//char *imagepath[3] = {"Cover.bmp","Cover.jpg","Cover.gif"};
    
    unsigned char * m_pFileName;
    unsigned int    m_nFileNameSize;
private:
    
    int  findZipSegIndex(unsigned int relativeOffset);//-1 表示没有找到
    
	void ReadSection(short id, unsigned char b, unsigned char length);
	void ReadAdditional(short id, unsigned int check, unsigned int length);
	bool ParseHeader();
	void EntelFilter(unsigned char* p,unsigned int len);
    void MinizeZipSeg(unsigned int ZipSegIndex);
	bool ParseContent(unsigned int ZipSegIndex);
	void getMoreBuffer(unsigned int length);
	void changeOffetSet(unsigned int offSet);
private:
	void FreeMemory();
	void PrintLog(const char *format,...);
private:
	FILE *m_pUMDFile;
	unsigned long m_nUMDFileSize;
	unsigned char *m_pCurrent;
private:
	unsigned short m_nPkgSeed;
	unsigned int m_nCid;
	unsigned int m_nAdditionalCheck;
	unsigned int m_nContentLength;

	unsigned int m_nAbsoluteOffset;
	unsigned int m_nRelativeOffet;
	int m_nChapLen;
	unsigned int *m_pChapOffset;
    

    unsigned int m_MAXBUFFERSIZENUMBER;
    unsigned char* BUFFER;
    
	struct ZIPSEGMENG 
	{
		unsigned int    m_nAbsoluteOffset;
		unsigned int    m_nlen;
        unsigned int    m_nRelativeOffet;
        
        unsigned char * m_pBuffer;
        unsigned int    m_nBufferSize;
        unsigned int    m_nVildBufferSize;
	};
    
    struct Chapter
    {
        unsigned char * m_pChapterName;
        unsigned int    m_nChapterNameSize;
        unsigned int    m_nChapterOffset;
    };
    
    public:
	std::vector<ZIPSEGMENG*> m_vZipSeg;
    std::vector<Chapter*>    m_vChapter;
};

#endif  // __UMDDECODE_H__