//
//  TxtPlugin.m
//  docinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TxtPlugin.h"

#import "txtBookModel.h"
#import "book.h"
#import "txtLocation.h"
#import "txtMetaInfoReader.h"
#import "UMDBookModel.h"
#define TXT_STR     (@"TXT")
#define UMD_STR     (@"UMD")
@implementation TxtPlugin

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (BOOL) acceptsFile:(NSString*)filepath
{
    NSString* externName = [filepath pathExtension];
    
    if (externName)
    {
        return [externName compare:TXT_STR options:NSCaseInsensitiveSearch] == NSOrderedSame
        || [externName compare:UMD_STR options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }
    else
    {
        return false;
    } 
}

- (BOOL) readMetaInfo:(book*) book
{
    if (![book.mystartLocation isKindOfClass:[txtLocation class]])
    {
        book.mystartLocation = nil;
    }
    
    if ([[[[book filePath] pathExtension] uppercaseString] isEqualToString:TXT_STR])
    {
        txtBookModel* tBookModel = [[[txtBookModel alloc] initWithFileName:[book filePath] CharactorIndex:[(txtLocation*)book.mystartLocation charactorIndex] BookId:[book bookID]] autorelease];
        book.myMetaInfoDic = [txtMetaInfoReader createMetaInfoDicWithFilePath:[book filePath]];
        book.myBookModel = tBookModel;
        tBookModel.bookTitle = [book bookTittle];
    }
    else
    {
        UMDBookModel* tBookModel = [[[UMDBookModel alloc] initWithFileName:[book filePath]
                                             CharactorIndex:[(txtLocation*)book.mystartLocation 
                                                             charactorIndex] 
                                                      BookId:[book bookID]] autorelease];
        book.myMetaInfoDic = [tBookModel createMetaInfoDic];
        book.myBookModel = tBookModel;
        tBookModel.bookTitle = [book bookTittle];
    }

    
    
    
    return YES;
}

@end
