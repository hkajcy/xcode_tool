//
//  OEBTextRowInfo.h
//  docinBookReader
//
//  Created by 黄柯 on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class OEBLocation;
@class accessibilityElement;
@class OEBTextModel;
@interface OEBTextRowInfo : NSObject
{
    CTLineRef lineRef;
    CTLineRef colorLineRef;
    CTLineRef drawLineRef;
}

@property (nonatomic, assign) OEBTextModel* textModel;

@property (nonatomic, retain) id content;
@property (nonatomic, retain) OEBLocation*  startLoc;
@property (nonatomic, retain) OEBLocation*  stopLoc;
@property (nonatomic, retain) OEBLocation*  startPlayingLocx;
@property (nonatomic, retain) OEBLocation*  stopPlayingLoc;

@property (nonatomic, assign) float drawOriginalX;
@property (nonatomic, assign) float drawOriginalY;
@property (nonatomic, assign) float drawTextWidth;
@property (nonatomic, assign) float drawTextHeight;
@property (nonatomic, assign) float drawViewWidth;
@property (nonatomic, assign) float drawViewHeight;
@property (nonatomic, assign) float scale;

@property (nonatomic, retain) UIColor* drawColor;
@property (nonatomic, retain) UIFont* drawFont;
@property (nonatomic, retain) UIImage* drawImage;

@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, retain) NSMutableArray* accessibilityArray;

@property (nonatomic, assign) BOOL isRecreated;
@property (nonatomic, assign) BOOL isIndent;

@property (nonatomic, retain) id selectStartLocation;
@property (nonatomic, retain) id selectStopLocation;
@property (nonatomic, assign) bool isSelecting;

@property (nonatomic, retain) accessibilityElement* startSelectingElement;
@property (nonatomic, retain) accessibilityElement* stopSelectingElement;

- (void) setLine:(CTLineRef)line;

- (void) drawInContext:(CGContextRef)context;

- (void) reCreateWithStartSpecLoc:(id)startSpecLoc
                  withStopSpecLoc:(id)stopSpecLoc;
@end
