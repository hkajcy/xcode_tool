//
//  FormatSpine.h
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//opf
#define SpineID_STR                                  (@"SpineID")
#define SpineTittle_STR                              (@"SpineTittle")
#define SpineSummary_STR                             (@"SpineSummary")
#define SpineLocation_STR                            (@"SpineLocation")
#define SpineIsInNCX_STR                             (@"SpineIsInNCX")
#define NcxReadFinished_STR                          (@"NcxReadFinished")

@class formatLocation;

@protocol FormatSpineProtocol <NSObject>

- (id) firstChapter;
- (id) lastChapter;
- (id) previousChapter:(id)currentChapter;
- (id) nextChapter:(id)currentChapter;

@end

@interface formatSpine : NSObject
{
    NSMutableArray* _spineArray;
}

@property (nonatomic,retain) NSMutableArray* spineArray;

- (id) initWithSpineArray:(NSMutableArray*)spineArray;


@end