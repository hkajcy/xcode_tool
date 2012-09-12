//
//  UMDBufferStream.mm
//  docinBookReader
//
//  Created by 黄柯 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UMDBufferStream.h"
#import "UMDDecode.h"
#import "txtLocation.h"
#import "FormatSpine.h"
#define BUFFER_SIZE  (1024)

@implementation UMDBufferStream

- (id)initWithFileName:(NSString*)fileName
{
    self = [super init];
    if (self)
    {
        if (decoder == NULL)
        {
            decoder = new UMDDecode;
        }
        
        if (!decoder->Parse([fileName UTF8String]))
        {
            delete decoder;
            [self release];
            return nil;
        } 
    }
    return self;
}


- (NSString*)readForwardFromCurse:(int*)curseIndex
{
    int readNumber = decoder->readFile(*curseIndex, buffer, BUFFER_SIZE);
    if (readNumber != 0)
    {
        NSData* data = [NSData dataWithBytesNoCopy:buffer length:readNumber freeWhenDone:NO];
        NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding] autorelease];
        assert(str);
        *curseIndex += readNumber;
        return str;
    }
    
    return nil;
}
- (NSString*)readBackwardFromCurse:(int*)curseIndex
{
    if (*curseIndex <= 0)
    {
        return nil;
    }
    
    int readSize = *curseIndex - BUFFER_SIZE > 0 ? BUFFER_SIZE : *curseIndex;
    *curseIndex -= readSize;
    
    int readNumber = decoder->readFile(*curseIndex, buffer, readSize);
    if (readNumber != 0)
    {
        NSData* data = [NSData dataWithBytesNoCopy:buffer length:readNumber freeWhenDone:NO];
        NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding] autorelease];
        assert(str);
        return str;
    }
    
    return nil;
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
            retStr = [str stringByAppendingString:retStr];
        }
        
        if ([retStr length] > limitLength)
        {
            break;
        }
    }
    
    return retStr;
}

- (int)findCurseWithStartCurse:(int)startCurse CharactorIndex:(int)chIndex LimitLength:(int)limitLength
{
    return chIndex*2;
}

- (int)fileLength
{
    return decoder->fileLength();
}

- (NSStringEncoding)encoding
{
    return NSUnicodeStringEncoding;
}

- (NSMutableArray*) spineArray
{
    NSMutableArray* spineArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (int i=0; i<decoder->m_vChapter.size(); i++)
    {
        NSData* data = [NSData dataWithBytes:decoder->m_vChapter[i]->m_pChapterName length:decoder->m_vChapter[i]->m_nChapterNameSize];
        NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding] autorelease];
        
        NSMutableDictionary* dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setValue:str forKey:SpineTittle_STR];
        [dic setValue:[NSNumber numberWithBool:YES] forKey:SpineIsInNCX_STR];
        [dic setValue:[txtLocation txtLocationWithIndex:decoder->m_vChapter[i]->m_nChapterOffset / 2] forKey:SpineLocation_STR];
        [spineArray addObject:dic];
    }
    
    return spineArray;
}

- (NSData*)cover
{
    NSData* data = [NSData dataWithBytes:decoder->m_pCover length:decoder->m_nCoverLength];
    return data;
}

- (NSString*) title
{
    NSData* data = [NSData dataWithBytes:decoder->m_pFileName length:decoder->m_nFileNameSize];
    NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding] autorelease];
    return str;
}

- (NSString*) auther {
    return nil;
}
- (void) dealloc
{
    delete decoder;
    decoder = NULL;
    [super dealloc];
}
@end
