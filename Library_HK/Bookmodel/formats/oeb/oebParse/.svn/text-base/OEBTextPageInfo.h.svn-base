//
//  OEBTextPageInfo.h
//  docinBookReader
//
//  Created by 黄柯 on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class OEBLocation;
@class OEBTextModel;
@class accessibilityElement;

@interface OEBTextPageInfo : NSObject
{
}

@property (nonatomic, assign) OEBTextModel* textModel;
@property (nonatomic, readonly) BOOL isValide;
@property (nonatomic, retain) id  paragraphArray;
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

@property (nonatomic, retain) UIFont*  drawFont;
@property (nonatomic, retain) UIColor* drawColor;
@property (nonatomic, assign) float scale;

@property (nonatomic, assign) float lineSpacing;
@property (nonatomic, assign) float paragraphSpacing;


@property (nonatomic, retain) NSMutableArray*         rowInfoArray;

@property (nonatomic, retain) NSMutableArray*         preRowInfoArray;
@property (nonatomic, assign) NSMutableArray*         tempRowInfoArray;
@property (nonatomic, retain) NSMutableArray*         nextRowInfoArray;
@property (nonatomic, retain) NSMutableArray*         tParagraphArray;
@property (nonatomic, retain) NSMutableAttributedString* lastAttributedString;

@property (nonatomic, assign) BOOL isSpan;
@property (nonatomic, assign) BOOL isIndent;

@property (nonatomic, assign) int validLength;

@property (nonatomic, retain) id selectStartLocation;
@property (nonatomic, retain) id selectStopLocation;
@property (nonatomic, assign) bool isSelecting;

@property (nonatomic, retain) accessibilityElement* startSelectingElement;
@property (nonatomic, retain) accessibilityElement* stopSelectingElement;

@property (nonatomic, assign) BOOL didCreateAccessbility;
- (void) prepareForPage;

- (void) reCreateWithStartSpecLoc:(id)startSpecLoc
                  withStopSpecLoc:(id)stopSpecLoc;
- (BOOL) isLocationinThePage:(id)loc ;

- (void) drawPageInContext:(CGContextRef)context
              bookDrawMode:(int)drawMode
           StartPlayingLoc:(id)startPlayingLoc
            StopPlayingLoc:(id)stopPlayingLoc;

- (UIImage *)imageWithPoint:(CGPoint)point;
- (void) createAccessbility;
@end
