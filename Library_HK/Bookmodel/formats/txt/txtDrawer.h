//
//  txtDrawer.h
//  docinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "book.h"
@interface txtDrawer : NSObject

+ (void) drawWithPageInfo:(id)pageInfo_
         withBookDrawMode:(bookDrawMode)drawMode
           StartSpecIndex:(int)startSpecIndex
            StopSpecIndex:(int)stopSpecIndex
                inContext:(CGContextRef)context;
@end
