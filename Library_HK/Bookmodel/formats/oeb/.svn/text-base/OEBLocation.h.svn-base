//
//  OEBSpineTag.h
//  moonBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "formatLocation.h"

@interface OEBLocation : formatLocation
<NSCoding>
{
    NSString* _href;        // 章节路径
    NSUInteger paragraph;   // 段落索引
    NSUInteger postion;     // 段落中文本起始位置，如果是图片，则postion为0
}

@property (nonatomic,retain) NSString* href;
@property (nonatomic) NSUInteger paragraph;
@property (nonatomic) NSUInteger postion;


- (id) initWithHref:(NSString*)hreft;
- (BOOL)isEqualToOEBLocation:(OEBLocation *)location;
- (void)printLocation;

- (BOOL) isForwardFrom:(OEBLocation *)location;
- (BOOL) isBackwardFrom:(OEBLocation *)location;

- (BOOL) isParagraphEnd;
- (id) preParagraphEndLocation;
- (id) nextParagraphStartLocation;

+ (void) addParagraphArray:(id)array withHref:(NSString*)href;
+ (void) clearWithHref:(NSString*)href;
+ (void) clear;
@end
