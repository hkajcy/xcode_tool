//
//  FormatSpineTag.h
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "macros_for_IOS_hk.h"

@class formatLocation;
@protocol formatLocationProtocol <NSObject>

@optional
- (BOOL) isEqualLocation:(id)object;
- (BOOL) isEqualChapter:(id)object;
- (BOOL) isParagraphEnd;
- (id) preParagraphEndLocation;
- (id) nextParagraphStartLocation;
@end

@interface formatLocation : NSObject
<formatLocationProtocol,NSCoding>

@end
