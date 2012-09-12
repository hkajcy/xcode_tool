//
//  bookChapter.h
//  RegxDemo
//
//  Created by zhao liang on 11-8-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormatSpine.h"

@class txtStringStream;

@interface txtBookChapter : formatSpine
{
    NSMutableArray *chapterArray;  
    NSString *oldString;    
    NSString *separateTitleString;//章节题目被分离后的前半部分
    BOOL isSeparate;//章节题目是否分离
    NSUInteger baseLocation ;
    BOOL isNull;  //章节和章节题目是否分离
    NSMutableArray *title;
    BOOL isFinish;
}

@property (retain, nonatomic) NSMutableArray *chapterArray;
@property (retain, nonatomic) NSString* oldString;
@property (retain, nonatomic) NSString* separateTitleString;

- (void)createChapter:(txtStringStream *)stringStream WithBookid:(NSUInteger) bookid;
@end
