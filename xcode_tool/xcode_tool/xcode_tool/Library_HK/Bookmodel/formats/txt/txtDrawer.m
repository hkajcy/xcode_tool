//
//  txtDrawer.m
//  docinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtDrawer.h"
#import "bookConfig.h"
#import <CoreText/CoreText.h>
#import "txtPageInfo.h"

@implementation txtDrawer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (void) drawWithPageInfo:(id)pageInfo_
         withBookDrawMode:(bookDrawMode)drawMode
        StartSpecIndex:(int)startSpecIndex
         StopSpecIndex:(int)stopSpecIndex
                inContext:(CGContextRef)context
{
    txtPageInfo* pageInfo = pageInfo_;
    [pageInfo drawPageInContext:context
                   bookDrawMode:drawMode 
              StartPlayingIndex:startSpecIndex
               StopPlayingIndex:stopSpecIndex];
}
@end
