//
//  txtRow.h
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class txtStringStream;
@interface txtRowStream : NSObject
{
    NSMutableArray* rowCach;
    int firstRowIndex;
    txtStringStream* string;
    
    int originaCharactorIndex;
    int firstCharactorIndex;
    int lastCharactorIndex;
    
    UIFont* font;
    int width;
    
    BOOL isOnlyReback; //这是只有‘\r’的文章
}

@property (nonatomic, readonly) txtStringStream* string;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, assign) int width;
@property (nonatomic, retain) NSMutableArray* rowCach;

- (id)initWithFileName:(NSString*)fileName;
- (void)rowReset;
- (NSArray*)rowsWithRange:(NSRange)range;
- (void)setCharactorIndex:(int)index;

@end
