//
//  txtBookModel.h
//  UniversalCharDet
//
//  Created by  on 11-8-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "bookModel.h"

@class txtBookChapter;
@class txtPageStream;
@class bookMark;
@class txtPostion;
@class txtStream;
@class txtStringStream;
@class txtRowStream;

@interface txtBookModel : bookModel
<BookModelProtocol>
{
    NSString* bookTitle;
    NSMutableArray* dicArray;
    int charactorIndex;
    
    int rows;
    UIFont* font;
    CGSize drawSize;
    NSUInteger bookId;
    
    txtPageStream* page;
    txtBookChapter* myBookChapter;
    
    int startPlayingIndex;
    int stopPlayingIndex;
    
    NSMutableArray* myChapterArray;
    
    txtStringStream* sonOfPage;
}

@property (nonatomic, retain)NSMutableArray* myChapterArray;
@property (nonatomic, copy)  NSString* bookTitle;
@property (nonatomic, retain)UIFont* font;
@property (nonatomic, retain)NSMutableArray* dicArray;
@property (nonatomic, assign)NSUInteger bookId;
@property (nonatomic, assign)BOOL isPlaying;



- (id)initWithFileName:(NSString*)fileName CharactorIndex:(int)index BookId:(NSUInteger) bookid;

- (int)tottalCharactor;

- (void)reset;//重置

- (void)setCharactorIndex:(int)chIndex;//跳转功能

- (NSMutableArray*) bookSpineArray;

- (void)createChapter;

- (int)firstCharactorIndexOfPage:(int)pageIndex;
- (int)lastCharactorIndexOfPage:(int)pageIndex;

- (void) parseAll;
@end
