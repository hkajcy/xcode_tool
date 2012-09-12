//
//  PDFThumb.h
//  PDFTest
//
//  Created by heyong on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPDFTHUMB_ASYNCHRONOUS_SUPPORTED

@interface PDFThumbItem : NSObject {
    UIImage *image;
    BOOL isMarked;
    NSUInteger pageNumber;
    CGRect rect;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic) BOOL isMarked;
@property (nonatomic, assign) CGRect rect;

/* pageNumber页数，从1开始 */
@property (nonatomic) NSUInteger pageNumber;

@end

@class PDFThumb;

@protocol PDFThumbDelegate <NSObject>

@required
- (void)didFinishPDFThumb:(PDFThumb *)pdfThumb;
- (void)didErrorOccurred:(NSError *)error withPDFThumb:(PDFThumb *)pdfThumb;

@optional
- (void)didUpdateThumbItem:(PDFThumbItem *)thumbItem 
               atPageIndex:(NSUInteger)pageIndex 
              withPDFThumb:(PDFThumb *)pdfThumb;

@end

@interface PDFThumb : NSObject {
    NSDictionary *itemDict;
    NSString *pdfPath;
    CGRect rect;
    BOOL isAsyn;
    NSMutableArray *indexArray;
    id<PDFThumbDelegate> delegate;
    
    NSThread* thumbThread;
    NSCondition *thumbCondition;
}

/*
 * 获取缩略图。
 * thumbItemWithFilePath:withSize:withPageIndex:
 *
 * path PDF文件路径
 * size 缩略图大小
 * pageIndex 获取指定页的缩略图，pageIndex从0开始。
 */
+ (PDFThumbItem *)thumbItemWithFilePath:(NSString *)path 
                               withSize:(CGSize)size 
                          withPageIndex:(NSUInteger)pageIndex;

@property (nonatomic, assign) id<PDFThumbDelegate> delegate;

- (id)initWithPDFPath:(NSString *)pdfPath  
                 withRect:(CGRect)rect 
           withThumbCount:(NSUInteger)count;

- (id)initWithPDFPath:(NSString *)pdfPath  
                 withRect:(CGRect)rect 
           withThumbCount:(NSUInteger)count 
                   isAsyn:(BOOL)asyn;

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index;
- (PDFThumbItem *)getThumbItemAtPageIndex:(NSUInteger)index;

- (void)asynThumbItemForPageIndex:(NSUInteger)index;
- (void)asynThumbItemForPageIndex:(NSUInteger)index withRect:(CGRect)rect;

- (NSArray *)getAllPageIndexForBookmarkThumb;
- (void)clearAllBookmark;
- (void)setBookmark:(BOOL)isMarked atPageIndex:(NSUInteger)index;
- (NSUInteger)thumbCount;

- (void)cancel;

@end
