//
//  UMDBookModel.m
//  docinBookReader
//
//  Created by 黄柯 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UMDBookModel.h"
#import "UMDSpine.h"
#import "UMDBufferStream.h"
#import "macros_for_IOS_hk.h"
#import "book.h"
@interface UMDBookModel ()

@property (nonatomic,retain)UMDSpine* spine;
@property (nonatomic,retain)NSString* fileName;
@end

@implementation UMDBookModel

@synthesize spine;
@synthesize fileName;
- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (UMDSpine*)creadtUmdSpine:(NSString*)fileName_
{
    UMDBufferStream *umd = [[[UMDBufferStream alloc] initWithFileName:fileName_] autorelease];
    NSMutableArray* spineArray_ = [umd spineArray];
    self.spine = [[[UMDSpine alloc] init]autorelease];
    self.spine.spineArray = spineArray_;
    self.myChapterArray = spineArray_;
    return spine;
}

- (NSMutableArray*) bookSpineArray
{
    return spine.spineArray;
}

- (id)initWithFileName:(NSString*)fileName_ CharactorIndex:(int)index BookId:(NSUInteger)bookid
{
    assert(fileName_ != nil);
    self = [super initWithFileName:fileName_ CharactorIndex:index BookId:bookid];
    if (self)
    {
        self.fileName = fileName_;
        // Initialization code here.
        [self creadtUmdSpine:fileName_];
    }
    return self;  
}

- (NSMutableDictionary*)createMetaInfoDic
{
    NSMutableDictionary* metaInfoDic = [[[NSMutableDictionary alloc] init] autorelease];
    
    UMDBufferStream *umd = [[[UMDBufferStream alloc] initWithFileName:fileName] autorelease];
    NSData* coverData = [umd cover];
    UIImage* coverImage = [UIImage imageWithData:coverData];
    if (nil != coverImage)
    {
        [metaInfoDic setObject:coverImage forKey:coverImage_STR];
    }
    
    NSString* title = [umd title];
    if (nil != title)
    {
        [metaInfoDic setObject:title forKey:tittle_STR];
    }
    return metaInfoDic;
}
- (void) dealloc
{
    [spine release];
    [fileName release];
    [super dealloc];
}
@end