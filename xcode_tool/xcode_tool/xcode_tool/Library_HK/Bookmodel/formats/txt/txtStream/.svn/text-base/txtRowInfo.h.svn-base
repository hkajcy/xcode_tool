//
//  txtRowInfo.h
//  docinBookReader
//
//  Created by 黄柯 on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class accessibilityElement;
@interface txtRowInfo : NSObject
{
    CTLineRef lineRef;
    CTLineRef drawLineRef;
    CTLineRef colorLineRef;
    NSMutableArray* txtAccessibilityArray;
}

@property (nonatomic, assign) int maxLengthInALine;
@property (nonatomic, retain) NSMutableAttributedString* drawStr;
@property (nonatomic, assign) int   startIndex;
@property (nonatomic, assign) int   visibleStartIndex;
@property (nonatomic, assign) int   length;
@property (nonatomic, assign) int   stopIndex;
@property (nonatomic, assign) float drawOriginalX;
@property (nonatomic, assign) float drawOriginalY;
@property (nonatomic, assign) float drawTextWidth;
@property (nonatomic, assign) float drawTextHeight;
@property (nonatomic, assign) float drawViewWidth;
@property (nonatomic, assign) float drawViewHeight;
@property (nonatomic, retain) UIFont* drawFont;
@property (nonatomic, assign) BOOL  isParagraphEnd;
@property (nonatomic, readonly) BOOL isSeparetedByLineBreake;
@property (nonatomic, assign) BOOL isIndent;


@property (nonatomic, assign) int startPlayingIndex;
@property (nonatomic, assign) int stopPlayingIndex;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, retain) UIColor* drawColor;

@property (nonatomic, retain) id selectStartLocation;
@property (nonatomic, retain) id selectStopLocation;
@property (nonatomic, assign) bool isSelecting;

@property (nonatomic, retain) accessibilityElement* startSelectingElement;
@property (nonatomic, retain) accessibilityElement* stopSelectingElement;

+ (BOOL) removeIndentWithString:(NSMutableString*)str;

- (void) setCTlineRef:(CTLineRef)lineref;
- (void) reCreateWithStartSpecIndex:(int)startSpecIndex
                  withStopSpecIndex:(int)stopSpecIndex;
- (void) createAccessbility;
- (void) drawInContext:(CGContextRef)context;
- (BOOL) isPointInTheRow:(CGPoint)point;
- (int ) chIndexWithPoint:(CGPoint)point;
@end
