//
//  txtPage.h
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class txtLocation;
@class txtRowStream;
@class txtStringStream;
@class txtPageInfo;
@interface txtPageStream : NSObject
{
    txtStringStream* string;
    txtRowStream* row;
    int rows;
    CGSize drawSize;
    int needLastRow;
    NSMutableDictionary* pageTochIndexDic;
    
    int originaCharactorIndex;
    int firstCharactorIndex;
    int lastCharactorIndex;
    
    NSMutableDictionary* pageInfoDic;
}

@property (nonatomic,readonly) NSMutableDictionary* pageTochIndexDic;
@property (nonatomic, assign) int needLastRow;
@property (nonatomic,readonly) txtRowStream* row;
@property (nonatomic,readonly) txtStringStream* string;

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

@property (nonatomic, retain) id selectStartLocation;
@property (nonatomic, retain) id selectStopLocation;
@property (nonatomic, assign) bool isSelecting;
- (id)initWithFileName:(NSString*)fileName;
- (void)pageReset;

- (int) charactor:(int)charactorIndx InPage:(int)pageIndex;
- (void) setCharactor:(int)charactorIndx;

- (NSArray*)pageAtIndex:(int)pageIndex;
- (txtPageInfo*) pageInfoAtIndex:(int)pageIndex;

- (void) rowIndexAtPageIndex:(int)index 
                withStrIndex:(int)strIndex
                    rowIndex:(int*)rowIndex
            strIndexInTheRow:(int*)strIndexInTheRow;

- (int)firstCharactorIndexOfPage:(int)pageIndex;
- (int)lastCharactorIndexOfPage:(int)pageIndex;

- (int)charactorIndexOfPage:(int)pageInex WithPoint:(CGPoint)point;

- (void) reCreateWithStartSpecIndex:(int)startSpecIndex
                  withStopSpecIndex:(int)stopSpecIndex;

- (NSString*) strBetweenLocation:(txtLocation*)startLocation andLocation:(txtLocation*)stopLocation;
- (NSString*)readForwardFromCharactorIndex:(int)charactorIndex limitCharNum:(int) chNumber;
- (NSString*)readForwardFromCharactorIndex:(int)charactorIndex;
- (NSString*)readBackwardFromCharactorIndex:(int)charactorIndex limitCharNum:(int) chNumber;
- (NSString*)readBackwardFromCharactorIndex:(int)charactorIndex;
@end
