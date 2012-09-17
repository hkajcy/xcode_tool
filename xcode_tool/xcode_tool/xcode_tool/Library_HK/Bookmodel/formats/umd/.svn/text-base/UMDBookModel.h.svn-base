//
//  UMDBookModel.h
//  docinBookReader
//
//  Created by 黄柯 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "txtBookModel.h"

@class UMDSpine;
@interface UMDBookModel :txtBookModel
{
    UMDSpine* spine;
    NSString* fileName;
}

- (id)initWithFileName:(NSString*)fileName CharactorIndex:(int)index BookId:(NSUInteger)bookid;

- (NSMutableDictionary*)createMetaInfoDic;
@end
