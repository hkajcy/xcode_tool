//
//  txtPageInfo.h
//  docinBookReader
//
//  Created by 黄柯 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "book.h"
@class txtStringStream;
@class accessibilityElement;
@interface txtPageInfo : NSObject
{
    CTFrameRef              frame;
    CGMutablePathRef        path;
    CTFramesetterRef        frameSetter;
    
    NSMutableArray*         rowInfoArray;
    NSMutableArray*         preRowInfoArray;
    NSMutableArray*         nextRowInfoArray;
}
@property (nonatomic, assign) txtStringStream* string;
@property (nonatomic, assign) int startIndex;
@property (nonatomic, readonly) BOOL isValide;
@property (nonatomic, assign) int stopIndex;
@property (nonatomic, assign) int startPlayingIndex;
@property (nonatomic, assign) int stopPlayingIndex;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, retain) NSString* drawStr;
@property (nonatomic, assign) float drawOriginalX;
@property (nonatomic, assign) float drawOriginalY;
@property (nonatomic, assign) float drawTextWidth;
@property (nonatomic, assign) float drawTextHeight;
@property (nonatomic, assign) float drawViewWidth;
@property (nonatomic, assign) float drawViewHeight;
@property (nonatomic, retain) UIFont* drawFont;
@property (nonatomic, assign) float lineSpacing;
@property (nonatomic, assign) float paragraphSpacing;
@property (nonatomic, retain) UIColor* drawColor;
@property (nonatomic, retain) NSMutableArray*         preRowInfoArray;
@property (nonatomic, assign) NSMutableArray*         tempRowInfoArray;
@property (nonatomic, retain) NSMutableArray*         nextRowInfoArray;

@property (nonatomic, retain) NSMutableAttributedString*     preStr;
@property (nonatomic, retain) NSMutableAttributedString*     nextStr;

@property (nonatomic, retain) id selectStartLocation;
@property (nonatomic, retain) id selectStopLocation;
@property (nonatomic, assign) bool isSelecting;

@property (nonatomic, retain) accessibilityElement* startSelectingElement;
@property (nonatomic, retain) accessibilityElement* stopSelectingElement;

@property (nonatomic, assign) BOOL didCreateAccessbility;

- (void) sythe;

- (int ) chIndexWithPoint:(CGPoint)point;
- (void) drawPageInContext:(CGContextRef)context
              bookDrawMode:(bookDrawMode)drawMode
         StartPlayingIndex:(int)startPlayingIndex
          StopPlayingIndex:(int)stopPlayingIndex;

- (void) reCreateWithStartSpecIndex:(int)startSpecIndex
                  withStopSpecIndex:(int)stopSpecIndex;

- (id) sentenceStartLocationWithPoint:(CGPoint)point;
- (id) sentenceStoptLocationWithPoint:(CGPoint)point;
- (id) startLocationWithPoint:(CGPoint)point;
- (id) stopLocationWithPoint:(CGPoint)point;

- (id) accessbilityWithPoint:(CGPoint)point;

- (id) sentenceStartLocationWithLocation:(id)location;  //有可能找到的这个location是visibleIndex，要转化成startIndex
@end
