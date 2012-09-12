/*
============================================================================
Name		: UMDDecode.cpp
Author		: PanZhenyu
Copyright	: PanZhenyu
MSN&Email	: panzhenyu88@gmail.com
============================================================================
*/

#include "UMDDecode.h"
#include "zlib/zlib.h"


UMDDecode::UMDDecode()
{
	m_pUMDFile = NULL;
	m_nUMDFileSize = NULL;
	m_pChapOffset = NULL;
	m_pChapOffset = NULL;
	m_nAbsoluteOffset = NULL;
	m_nRelativeOffet = NULL;
    m_pCover = NULL;
    m_pFileName = NULL;
    BUFFER= NULL;
	m_nPkgSeed = 0;
	m_nCid = 0;
	m_nAdditionalCheck = 0;
	m_nContentLength = 0;
	m_nChapLen = 0;
}

UMDDecode::~UMDDecode()
{
	FreeMemory();
}

void UMDDecode::FreeMemory()
{
	if (m_pUMDFile)
	{
		fclose(m_pUMDFile);
		m_pUMDFile = NULL;
	}

	if (m_pChapOffset)
	{
		free(m_pChapOffset);
		m_pChapOffset = NULL;
	}

	for(int i=0;i<m_vZipSeg.size();i++)
	{
        delete m_vZipSeg[i]->m_pBuffer;
        m_vZipSeg[i]->m_pBuffer = NULL;
		free(m_vZipSeg[i]);
	}
    
    for (int i=0; i<m_vChapter.size(); i++)
    {
        delete m_vChapter[i]->m_pChapterName;
        m_vChapter[i]->m_pChapterName = NULL;
        delete m_vChapter[i];
    }
    
    if (BUFFER)
    {
        delete BUFFER;
        BUFFER = NULL;
    }
    
    if (m_pCover)
    {
        delete m_pCover;
        m_pCover = NULL;
    }
    
    if (m_pFileName)
    {
        delete m_pFileName;
        m_pFileName = NULL;
    }
}

//打印单行小于100字节
void UMDDecode::PrintLog(const char *format,...)
{
//	va_list args;
//	char buffer[100];
//
//	va_start(args, format);
//
//	vsprintf(buffer, format, args); 
//	puts(buffer);
//
//	FILE *Log = fopen("Information.txt", "a");
//	fprintf(Log, "%s",buffer);
//	fclose(Log);
}

void UMDDecode::ReadAdditional(short id, unsigned int check, unsigned int length)
{
	getMoreBuffer(length);
	switch(id)
	{
	case 0x81:
		break;
	case 0x82:
		{
			int type = 0;
			unsigned short flag = *(unsigned short*)m_pCurrent;
			if (flag == 0xD8FF)
			{
				type = 1;
			}
            else if (flag == 0x4947)
			{
				type = 2;
			}
            else if (flag == 0x4D42)
			{
				type = 0;
			}
            
            delete m_pCover;
            m_pCover = new unsigned char[length];
            memcpy(m_pCover, m_pCurrent, length);
            m_nCoverLength = length;
            m_nCoverType = type;
		}
		break;
	case 0x83:
		{
			m_nChapLen = length/4;
			m_pChapOffset = (unsigned int*)calloc(m_nChapLen,sizeof(unsigned int));
			for (int i=0;i<m_nChapLen;i++)
			{
				m_pChapOffset[i] = *((unsigned int*)m_pCurrent + i);
			}
			PrintLog("章节数:%d\n",m_nChapLen);
		}
		break;
	case 0x84:
		{
			if (m_nAdditionalCheck != check)
			{
				//这里估计是读取zip压缩段的地方
				ZIPSEGMENG *seg = (ZIPSEGMENG*)calloc(1,sizeof(ZIPSEGMENG));
				seg->m_nAbsoluteOffset = m_nAbsoluteOffset;
				seg->m_nlen = length;
                seg->m_nRelativeOffet = 0;
                seg->m_pBuffer = NULL;
                seg->m_nBufferSize = 0;
				m_vZipSeg.push_back(seg);
			}
			else
			{
				unsigned int index = 0;
				int i = 0;
				while (index < length)
				{
					unsigned char count = *(m_pCurrent+index);
					index++;
                    Chapter *tChapter = new Chapter;
                    tChapter->m_pChapterName = new unsigned char[count];
                    tChapter->m_nChapterNameSize = count;
                    tChapter->m_nChapterOffset = m_pChapOffset[i++];
                    memcpy(tChapter->m_pChapterName, m_pCurrent+index, count);
                    m_vChapter.push_back(tChapter);
					index += count;
				}
			}
		}
		break;
	}

	changeOffetSet(length);
	//m_pCurrent += length;
}

void UMDDecode::ReadSection(short id, unsigned char b, unsigned char length)
{
	getMoreBuffer(length);
	switch(id)
	{
	case 1:
        m_nPkgSeed = *(unsigned short*)m_pCurrent;
		break;
	case 2:
            if (m_pFileName)
            {
                delete m_pFileName;
            }
            m_pFileName = new unsigned char[length];
            memcpy(m_pFileName, m_pCurrent, length);
            m_nFileNameSize = length;
		PrintLog("书名:%s\n",BUFFER);
		break;
	case 3:
		//WideCharToMultiByte(CP_ACP,0,(wchar_t*)m_pCurrent,length/2,(char*)BUFFER,MAXBUFFERSIZE,NULL,false);
		PrintLog("作者:%s\n",BUFFER);
		break;
	case 4:
		//(CP_ACP,0,(wchar_t*)m_pCurrent,length/2,(char*)BUFFER,MAXBUFFERSIZE,NULL,false);
		PrintLog("出版年份:%s\n",BUFFER);
		break;
	case 5:
		//(CP_ACP,0,(wchar_t*)m_pCurrent,length/2,(char*)BUFFER,MAXBUFFERSIZE,NULL,false);
		PrintLog("出版月份:%s\n",BUFFER);
		break;
	case 6:
		//(CP_ACP,0,(wchar_t*)m_pCurrent,length/2,(char*)BUFFER,MAXBUFFERSIZE,NULL,false);
		PrintLog("出版日子:%s\n",BUFFER);
		break;
	case 7:
		//(CP_ACP,0,(wchar_t*)m_pCurrent,length/2,(char*)BUFFER,MAXBUFFERSIZE,NULL,false);
		PrintLog("作品类型:%s\n",BUFFER);
		break;
	case 8:
		//(CP_ACP,0,(wchar_t*)m_pCurrent,length/2,(char*)BUFFER,MAXBUFFERSIZE,NULL,false);
		PrintLog("发行商:%s\n",BUFFER);
		break;
	case 9:
		break;
	case 10:
		m_nCid = *(unsigned int*)m_pCurrent;
		break;
	case 11:
		m_nContentLength = *(unsigned int*)m_pCurrent;
		break;
	case 12:
		break;
	case 0x81:
	case 0x82:
	case 0x83:
	case 0x84:
		m_nAdditionalCheck = *(unsigned int*)m_pCurrent;
		break;
	}

	changeOffetSet(length);
	//m_pCurrent += length;
}


bool UMDDecode::ParseHeader()
{
	//检查文件头
	getMoreBuffer(4);
	unsigned int magicint = *(unsigned int*)m_pCurrent;
	if (magicint != 0xde9a9b89)
	{
		PrintLog("文件头错误!\n");
		return false;
	}
	changeOffetSet(4);
	//m_pCurrent += 4;

	getMoreBuffer(1);
	char ch = *m_pCurrent;
	while (ch == '#')
	{
		changeOffetSet(1);
		//m_pCurrent += 1;

		getMoreBuffer(2);
		short id = *(short*)m_pCurrent;
		changeOffetSet(2);
		//m_pCurrent += 2;
		getMoreBuffer(1);
		unsigned char b = *m_pCurrent;
		changeOffetSet(1);
		//m_pCurrent += 1;
		getMoreBuffer(1);
		unsigned char len = *m_pCurrent - 5;
		changeOffetSet(1);
		//m_pCurrent += 1;
		ReadSection(id, b, len);

		getMoreBuffer(1);
		ch = (char)*m_pCurrent;
		switch (id)
		{
		case 0xf1:
		case 10:
			id = 0x84;
			break;
		}

		while (ch == '$')
		{
			//m_pCurrent += 1;
			changeOffetSet(1);
			getMoreBuffer(4);
			unsigned long check = *(unsigned long*)m_pCurrent;
			//m_pCurrent+=4;
			changeOffetSet(4);
			getMoreBuffer(4);
			unsigned long num6 = *(unsigned long*)m_pCurrent - 9;
			changeOffetSet(4);
			//m_pCurrent+=4;
			ReadAdditional(id,check,num6);
			getMoreBuffer(1);
			ch = *m_pCurrent;
		}
	}

	return true;
}

void UMDDecode::EntelFilter(unsigned char* p,unsigned int len)
{
	unsigned short* A = (unsigned short*)p;
	for (int i=0;i<len/2;i++)
	{
		if (*(A+i) == 0x2029)
		{
			//黄柯修改
			*(A+i) = 0x000D;
		}
	}
}

void UMDDecode::MinizeZipSeg(unsigned int ZipSegIndex)
{
    for (int i=0; i<m_vZipSeg.size(); i++)
    {
        if (i == ZipSegIndex -1
            || i == ZipSegIndex
            || i == ZipSegIndex + 1)
        {
            
        }
        else
        {
            m_vZipSeg[i]->m_nVildBufferSize = 0;
            delete m_vZipSeg[i]->m_pBuffer;
            m_vZipSeg[i]->m_pBuffer = NULL;
        }
    }
}

bool UMDDecode::ParseContent(unsigned int ZipSegIndex)
{
    try 
    {
        //接下来解析压缩内容
        if (ZipSegIndex >= m_vZipSeg.size()) 
        {
            return false;
        }
        
        unsigned long deslen = m_MAXBUFFERSIZENUMBER * MAXBUFFERSIZE;
        fseek(m_pUMDFile,m_vZipSeg[ZipSegIndex]->m_nAbsoluteOffset,SEEK_SET);
        unsigned char* tBuffer = new unsigned char [m_vZipSeg[ZipSegIndex]->m_nlen];
        if (fread((void*)tBuffer, 1, m_vZipSeg[ZipSegIndex]->m_nlen, m_pUMDFile) != m_vZipSeg[ZipSegIndex]->m_nlen)
        {
            PrintLog("文件读取失败!\n");
            delete tBuffer;
            return false;
        }
        int ret = uncompress(BUFFER,&deslen,tBuffer,m_vZipSeg[ZipSegIndex]->m_nlen);
        if (Z_OK == ret)
        {
            if (ZipSegIndex == 0)
            {
                m_vZipSeg[ZipSegIndex]->m_nRelativeOffet = 0;
            }
            else
            {
                m_vZipSeg[ZipSegIndex]->m_nRelativeOffet = m_vZipSeg[ZipSegIndex - 1]->m_nRelativeOffet + m_vZipSeg[ZipSegIndex - 1]->m_nBufferSize;
            }
            
            EntelFilter(BUFFER,deslen);
            
            delete    m_vZipSeg[ZipSegIndex]->m_pBuffer;
            m_vZipSeg[ZipSegIndex]->m_pBuffer = new unsigned char[deslen];
            memcpy(m_vZipSeg[ZipSegIndex]->m_pBuffer, BUFFER, deslen);
            
            m_vZipSeg[ZipSegIndex]->m_nBufferSize = deslen;
            m_vZipSeg[ZipSegIndex]->m_nVildBufferSize = deslen;
        }
        else
        {
            delete tBuffer;
            throw ret;
        }
    } 
    catch (int ret)
    {
        if (ret == Z_BUF_ERROR)
        {
            delete BUFFER;
            m_MAXBUFFERSIZENUMBER++;
            BUFFER = new unsigned char[m_MAXBUFFERSIZENUMBER * MAXBUFFERSIZE];
            if (BUFFER == NULL)
            {
                throw 0;
            }
            return ParseContent(ZipSegIndex);
        }
    }
	
    
    MinizeZipSeg(ZipSegIndex);
	return true;
}

bool UMDDecode::Parse(const char *pFileName)
{	
	if (pFileName == NULL) return -1;
	FreeMemory();

    m_MAXBUFFERSIZENUMBER = 32;
    BUFFER = new unsigned char [m_MAXBUFFERSIZENUMBER * MAXBUFFERSIZE];
    if (BUFFER == NULL)
    {
        throw 0;
    }
    
	if((m_pUMDFile = fopen(pFileName, "rb")) == NULL)
	{
		PrintLog("文件打开失败!\n");
		return false;
	}

	fseek(m_pUMDFile, 0, SEEK_SET); 

	if (!ParseHeader()) return false;

    
    ParseContent(0);

	return true;
}

int  UMDDecode::findZipSegIndex(unsigned int relativeOffset)
{
    for (int i=0; i<m_vZipSeg.size(); i++)
    {
        //如果小于此段的偏移量，
        if (!m_vZipSeg[i]->m_nRelativeOffet && i != 0)
        {
            ParseContent(i);
        }
        
        int nRelativeOffet = m_vZipSeg[i]->m_nRelativeOffet;
        int length = m_vZipSeg[i]->m_nBufferSize;
        if (relativeOffset >= nRelativeOffet && relativeOffset < nRelativeOffet + length)
        {
            if (m_vZipSeg[i]->m_nVildBufferSize == 0)
            {
                ParseContent(i);
            }
            return i;
        }
    }
    
    return -1;
}
int  UMDDecode::fileLength()
{
    return m_nContentLength;
}
int  UMDDecode::readFile(unsigned int relativeOffset, unsigned char* buffer, unsigned int length)
{
    int ZipSegIndex = findZipSegIndex(relativeOffset);
    if (ZipSegIndex == -1)
    {
        return 0;
    }
    
    int validSize = m_vZipSeg[ZipSegIndex]->m_nBufferSize - (relativeOffset - m_vZipSeg[ZipSegIndex]->m_nRelativeOffet);
    int copySize = validSize < length ? validSize : length;
    if (ZipSegIndex != -1)
    {
        memcpy(buffer, m_vZipSeg[ZipSegIndex]->m_pBuffer + (relativeOffset - m_vZipSeg[ZipSegIndex]->m_nRelativeOffet), copySize);
        if (length > copySize)
        {
            return copySize + readFile(relativeOffset+copySize, buffer+copySize, length-copySize);
        }
        else
        {
            return copySize;
        }
    }
    else
    {
        return 0;
    }
}

void  UMDDecode::getMoreBuffer(unsigned int length)
{

    try 
    {
        if (length > m_MAXBUFFERSIZENUMBER * MAXBUFFERSIZE)
        {
            throw 0;
        }
        else
        {
            memset(BUFFER,0,m_MAXBUFFERSIZENUMBER * MAXBUFFERSIZE);
            m_pCurrent = BUFFER;
            if (fread((void*)BUFFER, sizeof(unsigned char), length, m_pUMDFile) != length)
            {
                PrintLog("文件读取失败!\n");
                return ;
            }
        }
    } 
    catch (int i)
    {
        delete BUFFER;
        m_MAXBUFFERSIZENUMBER++;
        BUFFER = new unsigned char[m_MAXBUFFERSIZENUMBER * MAXBUFFERSIZE];
        if (BUFFER == NULL)
        {
            throw 0;
        }
        return getMoreBuffer(length);
    }
}

void UMDDecode::changeOffetSet(unsigned int offSet)
{
	m_nAbsoluteOffset += offSet;
	m_pCurrent += offSet;
}