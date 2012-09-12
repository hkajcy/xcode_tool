//
//  UMDBufferStream.h
//  docinBookReader
//
//  Created by 黄柯 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "txtStringStream.h"

class UMDDecode;
@interface UMDBufferStream : NSObject
<BufferStream>
{
    unsigned char buffer[1024];
    UMDDecode* decoder;
}

- (NSData*) cover;
- (NSString*) auther;
- (NSString*) title;
- (NSMutableArray*) spineArray;
@end
