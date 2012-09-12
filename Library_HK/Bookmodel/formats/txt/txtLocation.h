//
//  txtLocation.h
//  docinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "formatLocation.h"

@interface txtLocation : formatLocation
<formatLocationProtocol,NSCoding>
{
    int charactorIndex;
}

@property (nonatomic,assign) int charactorIndex;

+ (txtLocation*) txtLocationWithIndex:(int)index;

@end
