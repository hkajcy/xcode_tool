//
//  txtBuffer.h
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "txtStringStream.h"
#define BUFFER_SIZE (1024 * 1)

@interface txtBufferStream : NSObject
<BufferStream>
{
    char*  buffer;//用于读取内容的buffer
    FILE*  fp;//文件指针
    
    int    hkEncoding;//txt的编码
    int    fileLength;//文件的长度
}

- (id)initWithFileName:(NSString*)fileName;

- (NSString*)readForwardFromCurse:(int*)curseIndex withLength:(int)length;
- (NSString*)readForwardFromCurse:(int*)curseIndex;
- (NSString*)readBackwardFromCurse:(int*)curseIndex;

- (int)findCurseWithStartCurse:(int)startCurse CharactorIndex:(int)chIndex LimitLength:(int)limitLength;

//获取txt文档的编码格式
- (NSStringEncoding)encoding;

- (int)fileLength;

@end
