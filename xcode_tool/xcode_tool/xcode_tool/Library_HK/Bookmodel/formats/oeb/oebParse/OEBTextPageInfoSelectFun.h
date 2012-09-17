//
//  OEBTextPageInfoSelectFun.h
//  DocinBookReader
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEBTextPageInfo.h"

@class OEBTextRowInfo;
@interface OEBTextPageInfo (select)

- (void) setSelectElementWithRowInfo:(OEBTextRowInfo*) rowInfo;

- (id) sentenceStartLocationWithLocation:(id)location ;
- (id) sentenceStoptLocationWithLocation:(id)location ;
- (id) startLocationWithPoint:(CGPoint)point ;
- (id) stopLocationWithPoint:(CGPoint)point ;

- (id) accessbilityWithPoint:(CGPoint)point ;
@end
