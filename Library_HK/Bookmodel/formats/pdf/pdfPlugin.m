//
//  pdfPlugin.m
//  DocinBookReader
//
//  Created by 黄柯 on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "pdfPlugin.h"
#import "book.h"
#import "pdfBookModel.h"
#import "PDFLocation.h"

#define pdf_STR  (@"pdf")
#define DOC_STR    (@"DOC")
@implementation pdfPlugin

- (BOOL) acceptsFile:(NSString*)filepath
{
    NSString* externName = [filepath pathExtension];
    
    if (externName)
    {
        return [externName compare:pdf_STR options:NSCaseInsensitiveSearch] == NSOrderedSame
        || [externName compare:DOC_STR options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }
    else
    {
        return false;
    } 
}

- (NSMutableDictionary*)createMetaInfoDic:(NSString*)filePath
{
    NSMutableDictionary* metaInfoDic = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSArray* componetsArray = [filePath pathComponents];
    
    NSString* title = [componetsArray lastObject];
    
    NSRange range = [title rangeOfString:[@"." stringByAppendingString:[title pathExtension]]];
    title = [title substringToIndex:range.location];
    if (nil != title)
    {
        [metaInfoDic setObject:title forKey:tittle_STR];
    }
    return metaInfoDic;
}

- (BOOL) readMetaInfo:(book*) book
{
    int index = ((PDFLocation*)book.mystartLocation).pageIndex;
    pdfBookModel* tPdfModel = [[[pdfBookModel alloc] initWithFilePath:[book filePath] PageIndex:index BookId:book.bookID] autorelease];

    book.myMetaInfoDic = [self createMetaInfoDic:[book filePath]];
    tPdfModel.bookTitle = [book bookTittle];
    book.myBookModel = tPdfModel;
    
    return YES;
}


@end
