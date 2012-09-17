//
//  OEBTypeSetting.h
//  OEBReader
//
//  Created by heyong on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookModel.h"

@class OEBCSSStyle;
@class ZipArchive;
@class OEBParagraph;
@class OEBLocation;
@class OEBTextModel;
@class accessibilityElement;

@interface OEBTextModel : bookModel 

@property (nonatomic, retain) NSArray *paragraphs;
@property (nonatomic, retain) ZipArchive *zipArchive;

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *basePath;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSMutableDictionary *pageFromIndexDic;
@property (nonatomic, retain) NSMutableDictionary* pageStartLocFromIndexDic;

@property (nonatomic, assign) float drawOriginalX;
@property (nonatomic, assign) float drawOriginalY;
@property (nonatomic, assign) float drawTextWidth;
@property (nonatomic, assign) float drawTextHeight;
@property (nonatomic, assign) float drawViewWidth;
@property (nonatomic, assign) float drawViewHeight;
@property (nonatomic, assign) float lineSpacing;
@property (nonatomic, assign) float paragraphSpacing;
@property (nonatomic, assign) float sacle;
@property (nonatomic, retain) UIColor* drawColor;
@property (nonatomic, retain) UIFont* drawFont;

@property (nonatomic, assign) int bookId;

//@property (nonatomic, retain) OEBLocation* selectStartLocation;
//@property (nonatomic, retain) OEBLocation* selectStopLocation;
//@property (nonatomic, assign) bool isSelecting;

- (id)initWithBasePath:(NSString *)bPath 
          withFileName:(NSString *)fileName 
        withZipArchive:(ZipArchive *)file;

- (NSInteger)pageIndexWithLocation:(OEBLocation *)location; //这个location在这一章内处于多少页。
- (id) pageWithPageIndex:(int)pageIndex;

- (NSUInteger)pageCount;
- (UIImage *)imageWithPoint:(CGPoint)point withPageIndex:(NSInteger)index;

- (UIImage*) imageWithPath:(NSString*)path;
- (void) parse;
- (void) drawPage:(int)pageIndex
         drawMode:(int)drawMode 
  StartPlayingLoc:(id)startPlayingLoc
   StopPlayingLoc:(id)stopPlayingLoc
      WithContext:(CGContextRef)context;

- (NSString *)strForwardWithLocation:(OEBLocation *)location limitNumber:(NSInteger)number ;
- (NSString *)strBackwardWithLocation:(OEBLocation *)location limitNumber:(NSInteger)number ;
- (NSString*) strBetweenLocation:(id)startLocation andLocation:(id)stopLocation;

- (OEBLocation *)startLocationWithPageIndex:(NSInteger)pageIndex;
- (OEBLocation *)endLocationWithPageIndex:(NSInteger)pageIndex;
- (OEBLocation *) locationForForward:(OEBLocation *)location withLength:(NSInteger)strLength ;
- (OEBLocation *)locationForBackward:(OEBLocation *)location withLength:(NSInteger)length ;
- (NSInteger) stringLengthFromLocation:(OEBLocation *)start toLocation:(OEBLocation *)end ;

- (void) clearCach;
@end
