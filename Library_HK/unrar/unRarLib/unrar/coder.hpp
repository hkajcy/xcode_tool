/****************************************************************************
 *  Contents: 'Carryless rangecoder' by Dmitry Subbotin                     *
 ****************************************************************************/


// (int) cast before "low" added only to suppress compiler warnings.
#ifndef __CODER_HPP__
#define __CODER_HPP__

#define ARI_DEC_NORMALIZE(code,low,range,read)									\
{																				\
	while ((low^(low+range))<TOP || range<BOT && ((range=-(int)low&(BOT-1)),1)) \
	{																			\
		code=(code << 8) | read->GetChar();										\
		range <<= 8;															\
		low <<= 8;																\
	}																			\
}

const uint TOP=1 << 24, BOT=1 << 15;

class RangeCoder
{
  public:
//    void InitDecoder(Unpack *UnpackRead);
//    inline int GetCurrentCount();
//    inline uint GetCurrentShiftCount(uint SHIFT);
//    inline void Decode();
//    inline void PutChar(unsigned int c);
//    inline unsigned int GetChar();

    uint low, code, range;
    struct SUBRANGE 
    {
      uint LowCount, HighCount, scale;
    } SubRange;

    Unpack *UnpackRead;
    
    inline unsigned int GetChar()
    {
        return 0;
        //return(UnpackRead->GetChar());
    }
    
    
    void InitDecoder(Unpack *UnpackRead)
    {
        RangeCoder::UnpackRead=UnpackRead;
        
        low=code=0;
        range=uint(-1);
        for (int i=0;i < 4;i++)
            code=(code << 8) | GetChar();
    }
    
    inline int GetCurrentCount() 
    {
        return (code-low)/(range /= SubRange.scale);
    }
    
    
    inline uint GetCurrentShiftCount(uint SHIFT) 
    {
        return (code-low)/(range >>= SHIFT);
    }
    
    
    inline void Decode()
    {
        low += range*SubRange.LowCount;
        range *= SubRange.HighCount-SubRange.LowCount;
    }
};


#endif