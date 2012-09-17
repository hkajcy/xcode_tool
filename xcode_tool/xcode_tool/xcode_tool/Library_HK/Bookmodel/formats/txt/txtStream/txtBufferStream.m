//
//  txtBuffer.m
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtBufferStream.h"
#import "uchardet.h"
#import "nscore.h"
#import "macros_for_IOS_hk.h"
@interface txtBufferStream(private)
- (int)detectDataEncoding:(NSData*) data;
@end

@implementation txtBufferStream

- (id)initWithFileName:(NSString*)fileName
{
    if (self = [super init])
    {
        fp = stdin;
        
        buffer = malloc(BUFFER_SIZE);
        
        fp = fopen([fileName fileSystemRepresentation], "r");
        
        if (nil == fp ) 
        {
            assert(0);
        }
        
        int readSize = fread(buffer, 1, BUFFER_SIZE, fp);
        
        NSData* data = [NSData dataWithBytesNoCopy:buffer length:readSize freeWhenDone:NO];
        
        hkEncoding = [self detectDataEncoding:data];
        
        fseek(fp, 0, SEEK_END);
        fileLength = ftello(fp);
    }
    return  self;
}

- (NSStringEncoding)convertoNSStringEncoding: (int)hkEn
{
    NSStringEncoding sEN = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    switch (hkEn) {
        case HK_ENCODING_BIG5:
            sEN = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
            break;
        case HK_ENCODING_GB18030:
            sEN = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        case HK_ENCODING_UNICODE_BIG_ENDIAN:
#if MAC_OS_X_VERSION_10_4 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_2_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
            sEN = NSUTF16BigEndianStringEncoding;          /* NSUTF16StringEncoding encoding with explicit endianness specified */
#endif
            break;
        case HK_ENCODING_UNICODE_LITTLE_ENDIAN:
#if MAC_OS_X_VERSION_10_4 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_2_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
            sEN = NSUTF16LittleEndianStringEncoding;     /* NSUTF16StringEncoding encoding with explicit endianness specified */
#endif
            break;
        case HK_ENCODING_UTF8:
            sEN = NSUTF8StringEncoding;
            break;
        case HK_ENCODING_ENCODING_DEFAULT:
            sEN = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        default:
            
            break;
    }
    return sEN;
}

- (int)analysisBackwardForANSI:(NSData*)data withHKEncoding:(int)hkEn
{
    int retVar = 0;
    assert([data length] != 0);
    int index = 0;
    
    do 
    {
        unsigned char ch;
        [data getBytes:&ch range:NSMakeRange(index, 1)];
        
        if (ch < 128 && index == 0) 
            return 0;
        else if (ch < 128)
            break;
        else
            index++;
    }while (index < [data length]);
    
    NSData* dataTemp = [data subdataWithRange:NSMakeRange(0, index)];
    NSString*  str = [[[NSString alloc] initWithData:dataTemp encoding:[self convertoNSStringEncoding:hkEn]] autorelease];
    
    if (str) 
        retVar = 0;
    else
        retVar = 1;
    
    return retVar;
}

- (int)checkNumberOneInCharactorFromFirst:(unsigned char)ch
{
    int number = 0;
    
    if (ch & 1<<7)
    {
        number++;
        if (ch & 1<<6)
        {
            number++;
            if (ch & 1<<5)
            {
                number++;
                if (ch & 1<<4)
                {
                    number++;
                    if (ch & 1<<3)
                    {
                        number++;
                        if (ch & 1<<2)
                        {
                            number++;
                            if (ch & 1<<1)
                            {
                                number++;
                                if (ch & 1) 
                                {
                                    number++;
                                }
                            }
                                
                        }
                    }
                }
            }
        }
    }
     
    return number;
}

- (int)analysisBackwardForUTF8:(NSData*)data
{
    int index = 0;
    
    for ( index=0; index<[data length]; index++)
    {
        unsigned char ch;
        [data getBytes:&ch range:NSMakeRange(index, 1)];
        
        //如果ch小于0x80说明ch是一个ascii码
        if (ch < 0x80)
            break;
        
        //
        int number = [self checkNumberOneInCharactorFromFirst:ch];
        if (number > 2)
        {
            break;
        }
    }
    
    return index;
}

- (int)analysisBackward:(NSData*)data withHKEncoding:(int)hkEn
{
    int bytesBackward = 0;
    switch (hkEn) {
        case HK_ENCODING_BIG5:
        case HK_ENCODING_GB18030:
            bytesBackward = [self analysisBackwardForANSI:data withHKEncoding:hkEn];
            break;
        case HK_ENCODING_UTF8:
            bytesBackward = [self analysisBackwardForUTF8:data];
            break;
        default:
            break;
    }
    return bytesBackward;
}

- (int)analysisForANSI:(NSData*)data withHKEncoding:(int)hkEn
{
    for (int i=0; i<[data length]; i++)
    {
        NSString*  str = [[[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, [data length]-i)] encoding:[self convertoNSStringEncoding:hkEn]] autorelease];
        
        if (str)
        {
            return i;
        }
    }
    return [data length];
}

- (int)analysisForUTF8:(NSData*)data
{
    int index = 0;
    
    for ( index = [data length] - 1; index >= 0; index--)
    {
        unsigned char ch;
        [data getBytes:&ch range:NSMakeRange(index, 1)];
        
        //如果ch小于0x80说明ch是一个ascii码
        if (ch < 0x80)
            return [data length] - index - 1;
        
        //获取这个字符是多少个字符的开头；
        int number = [self checkNumberOneInCharactorFromFirst:ch];
        
        int rNumber = [data length] - index;
        
        //大于等于2说明这是一个开始字符
        if (number >= 2)
        {
            if (number > rNumber)
            {
                return rNumber;
            }
            else
            {
                return rNumber - number;
            }
        }
    }
    
    return [data length];
}

- (int)analysis:(NSData*)data withHKEncoding: (int)hk_encoding
{
    int bytesBack = 0;
    switch (hk_encoding) {
        case HK_ENCODING_BIG5:
        case HK_ENCODING_GB18030:
            bytesBack = [self analysisForANSI:data withHKEncoding:hk_encoding];
            break;
        case HK_ENCODING_UNICODE_BIG_ENDIAN:
        case HK_ENCODING_UNICODE_LITTLE_ENDIAN:
            bytesBack = [data length] % 2;
            break;
        case HK_ENCODING_UTF8:
            bytesBack = [self analysisForUTF8:data];
            break;
        case HK_ENCODING_ENCODING_DEFAULT:
            debugLog(@"default analysis as HK_ENCODING_GB18030");
            bytesBack = [self analysisForANSI:data withHKEncoding:hk_encoding];
            break;
        default:
            break;
    }
    return bytesBack;
}

- (int)detectDataEncoding:(NSData*) data
{
	uchardet_t handle = uchardet_new();
    
    uchardet_handle_data(handle, (const char*)[data bytes], [data length]);
    
	uchardet_data_end(handle);
    
	int HK_encoding = uchardet_get_charset(handle);
    
	uchardet_delete(handle);
    
	return HK_encoding;
}

- (bool)isUTFBOMWithFirst:(unsigned char)ch1 Seconde:(unsigned char)ch2 Third:(unsigned char)ch3
{
    if (ch1 == 0xEF && ch2 == 0xBB && ch3 == 0xBF) 
        return true;
    else
        return false;
}

- (bool)isUnicodeBOMWithFirst:(unsigned char)ch1 Seconde:(unsigned char)ch2
{
    if ((ch1 == 0xFE && ch2 == 0xFF)
        || (ch1 == 0xFF && ch2 == 0xFE))
    {
        return true;
    }
    else
        return false;
}

- (bool)isBOMWithFirst:(unsigned char)ch1 Seconde:(unsigned char)ch2 Third:(unsigned char)ch3
{
    if (ch3 == 0)
    {
        return [self isUnicodeBOMWithFirst:ch1 Seconde:ch2];
    }
    else
    {
        if (ch3 == 0xBF)
            return [self isUTFBOMWithFirst:ch1 Seconde:ch2 Third:ch3];
        else
            return [self isUnicodeBOMWithFirst:ch1 Seconde:ch2];
    }
}

- (int)findCurseWithStartCurse:(int)startCurse 
                CharactorIndex:(int)chIndex 
{
    int limitLength = BUFFER_SIZE;
    limitLength = MIN(limitLength, BUFFER_SIZE);
    int readNumber;
    
    do {
        fseek(fp, startCurse, SEEK_SET);
        readNumber = fread(buffer, 1, limitLength, fp);
        
        if (readNumber)
        {
            int strLen = 0;
            for (int i=0; i<readNumber; i++)
            {
                NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
                NSData* data = [NSData dataWithBytesNoCopy:buffer length:i+1 freeWhenDone:NO];
                int rIndex = [self analysis:data withHKEncoding:hkEncoding];
                
                //如果有多余的字节的话，就没有必要计算了
                if (rIndex != 0)
                {
                    [pool release];
                    continue;
                }
                
                data = [NSData dataWithBytesNoCopy:buffer length:i+1-rIndex freeWhenDone:NO];
                NSString* str = [[[NSString alloc] initWithData:data encoding:[self convertoNSStringEncoding:hkEncoding]] autorelease];
                
                if (!str)
                {
                    debugLog(@"%@",data);
                    assert(str);
                };
                
                if ([str length] - chIndex == 0)
                {
                    int retNumber = startCurse + [data length];
                    [pool release];
                    return retNumber;
                }
                
                int len = [str length];
                assert(len < chIndex);
                
                //有可能出现BOM的情况
                bool isBOM = false;
                if (i > 1)
                {
                    //isBOM = [self isBOMWithFirst:buffer[i-2] Seconde:buffer[i-1] Third:buffer[i]];
                }
                else if (i == 1)
                {
                    //isBOM = [self isBOMWithFirst:buffer[i-1] Seconde:buffer[i] Third:0];
                }
                else if (!isBOM) 
                {
                    if(!(len == ++strLen))
                    {
                        debugLog(@"%@",data);
                        assert(0);
                    }
                }
                
                
                
                [pool release];
            }
            
            NSData* data = [NSData dataWithBytesNoCopy:buffer length:readNumber freeWhenDone:NO];
            int rIndex = [self analysis:data withHKEncoding:hkEncoding];
            NSData* newData = [NSData dataWithBytesNoCopy:buffer + rIndex length:readNumber- rIndex freeWhenDone:NO];
            
            NSString* str = [[[NSString alloc] initWithData:newData encoding:[self convertoNSStringEncoding:hkEncoding]] autorelease];
            
            chIndex -= [str length];
            assert(chIndex > 0);
            startCurse += limitLength - rIndex;
            
        }
        
    } while (readNumber);
    
    return fileLength;

}
- (int)findCurseWithStartCurse:(int)startCurse
                CharactorIndex:(int)chIndex
                   LimitLength:(int)limitLength;
{
    NSString* checkStr = nil;
    int oldCurse = fileLength;
    while (1)
    {
        oldCurse = startCurse;
        checkStr = [self readForwardFromCurse:&startCurse];
        
        //如果读取到数据
        if (checkStr && [checkStr length])
        {
            //如果读取到的字符小于chIndex 继续
            if ([checkStr length] < chIndex)
            {
                chIndex -= [checkStr length];
                continue;
            }
            else
            {
                break;
            }
        }
        else
        {
            oldCurse = fileLength;
            break;
        }
    }
    
    return [self findCurseWithStartCurse:oldCurse CharactorIndex:chIndex];
}

- (NSString*)readForwardFromCurse:(int*)curseIndex withLength:(int)length
{
    void* pBuffer = nil;
    if (length <= BUFFER_SIZE)
    {
        pBuffer = buffer;
    }
    else
    {
        pBuffer = malloc(length);
        assert(pBuffer);
    }
    
    NSString* str = nil;
    fseek(fp, *curseIndex, SEEK_SET);
    int readNumber = fread(pBuffer, 1, length, fp);
    
    //如果读出数据
    if (readNumber != 0)
    {
        
        NSData* data = [NSData dataWithBytesNoCopy:pBuffer length:readNumber freeWhenDone:NO];
        int rIndex = [self analysis:data withHKEncoding:hkEncoding];
        NSData* newData = [NSData dataWithBytesNoCopy:pBuffer length:readNumber - rIndex freeWhenDone:NO];
        if ([newData length])
        {
            str = [[[NSString alloc] initWithData:newData encoding:[self convertoNSStringEncoding:hkEncoding]] autorelease];
            
            if (!str) 
            {
                debugLog(@"%@", @"文章最后有不可解析的字符");
                str = nil;
            }
            else
            {
                assert(str);
                
                *curseIndex += [newData length];
            }

        }
    }
    
    if (length > BUFFER_SIZE)
    {
        free(pBuffer);
    }
    
    return str;
}

- (NSString*)readForwardFromCurse:(int*)curseIndex
{
    int length = BUFFER_SIZE;
    return [self readForwardFromCurse:curseIndex withLength:length];
}

- (NSString*)readBackwardFromCurse:(int*)curseIndex
{
    if (*curseIndex <=0 )
    {
        return nil;
    }
    NSString* str = nil;
    
    int readSize = *curseIndex - BUFFER_SIZE > 0 ? BUFFER_SIZE : *curseIndex;
    *curseIndex -= readSize;
    
    fseeko(fp, *curseIndex, SEEK_SET);
    int readNumber = fread(buffer, 1, readSize, fp);
    assert(readNumber <= BUFFER_SIZE);
    
    if (readNumber != 0)
    {
        NSData* data = [NSData dataWithBytesNoCopy:buffer length:readNumber freeWhenDone:NO];
        int rIndex = [self analysisBackward:data withHKEncoding:hkEncoding];
        NSData* newData = [NSData dataWithBytesNoCopy:buffer + rIndex length:readNumber - rIndex freeWhenDone:NO];
        *curseIndex += rIndex;
        if ([newData length])
        {
            str = [[[NSString alloc] initWithData:newData encoding:[self convertoNSStringEncoding:hkEncoding]] autorelease];
            if (!str)
            {
                debugLog(@"%@", newData);
                return nil;
            }
            assert(str);
        }
    }
    
    return str;
}

- (int)fileLength
{
    return fileLength;
}

- (NSStringEncoding)encoding
{
    return [self convertoNSStringEncoding:hkEncoding];
}

- (NSString*)readForwardFromCurse:(int*)curseIndex limitLength:(int)limitLength
{
    if (*curseIndex < 0) {
        assert(*curseIndex >= 0);
    }
    
    NSString* retStr = nil;
    while (1)
    {
        NSString* str = [self readForwardFromCurse:curseIndex];
        
        if (str == Nil || [str length] == 0)
        {
            break;
        }
        
        if (retStr == Nil)
        {
            retStr = str;
        }
        else
        {
            assert(str);
            retStr = [retStr stringByAppendingString:str];
        }
        
        if ([retStr length] > limitLength)
        {
            break;
        }
    }
    
    return retStr;
}

- (NSString*)readBackwardFromCurse:(int*)curseIndex limitLength:(int)limitLength
{
    if (*curseIndex < 0) {
        assert(*curseIndex >= 0);
    }
    NSString* retStr = nil;
    while (1)
    {
        NSString* str = [self readBackwardFromCurse:curseIndex];
        
        if (str == Nil || [str length] == 0)
        {
            break;
        }
        
        if (retStr == Nil)
        {
            retStr = str;
        }
        else
        {
            assert(str);
            retStr = [str stringByAppendingString:retStr];
        }
        
        if ([retStr length] > limitLength)
        {
            break;
        }
    }
    
    return retStr;
}

- (void)dealloc
{
    free(buffer);
    [super dealloc];
}
@end
