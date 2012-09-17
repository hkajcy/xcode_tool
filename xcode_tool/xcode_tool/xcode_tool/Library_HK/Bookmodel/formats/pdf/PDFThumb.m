//
//  PDFThumb.m
//  PDFTest
//
//  Created by heyong on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PDFThumb.h"
#import "macros_for_IOS_hk.h"

//@interface UIImage (scale)  
//
//-(UIImage*)scaleToSize:(CGSize)size;  
//
//@end
//
//@implementation UIImage (scale)  
//
//- (UIImage*)scaleToSize:(CGSize)size  
//{  
//    // 创建一个bitmap的context  
//    // 并把它设置成为当前正在使用的context  
//    UIGraphicsBeginImageContext(size);  
//    
//    //CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
//    
//    // 绘制改变大小的图片  
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];  
//    
//    // 从当前context中创建一个改变大小后的图片  
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
//    
//    // 使当前的context出堆栈  
//    UIGraphicsEndImageContext();  
//    
//    // 返回新的改变大小后的图片  
//    return scaledImage;  
//}  
//
//@end

@implementation NSNumber (MySort)

- (NSComparisonResult)myCompare:(NSString *)other
{
    //int result = ([self intValue] >> 1) - ([other intValue] >> 1);
    NSInteger result = [self integerValue] - [other integerValue];
    return result < 0 ? NSOrderedAscending : result > 0 ? NSOrderedDescending : NSOrderedSame;
}

@end

@implementation PDFThumbItem

@synthesize image;
@synthesize isMarked;
@synthesize pageNumber;
@synthesize rect;

- (void)dealloc
{
    [image release];
    [super dealloc];
}

@end

@interface PDFThumb ()

+ (UIImage *)imageWithPDFDocument:(CGPDFDocumentRef)pdfDocument 
                         withRect:(CGRect)rect 
                    withPageIndex:(NSUInteger)pageIndex;

@property (nonatomic, retain) NSDictionary *itemDict;
@property (nonatomic) CGRect rect;
@property (nonatomic) BOOL isAsyn;
@property (nonatomic, retain) NSString *pdfPath;

- (NSNumber *)getPageIndexAtIndex:(NSUInteger)index;
- (NSNumber *)_getPageIndexAtIndex:(NSUInteger)index;
- (void)delPageIndexAtIndex:(NSUInteger)index;
- (void)delIndexArrayForPageIndex:(NSUInteger)pageIndex;
- (void)updPageIndex:(NSUInteger)pageIndex;

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFPath:(NSString *)path;
- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFDocument:(CGPDFDocumentRef)pdfDocument;

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFPath:(NSString *)path withRect:(CGRect)rect;
- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFDocument:(CGPDFDocumentRef)pdfDocument withRect:(CGRect)rect;

- (void)didUpdateThumbItem:(id)params;
- (void)didErrorOccurred:(NSError *)error;

- (void)run;

- (CGPDFDocumentRef)createPDFDocumentWithFilePath:(NSString *)path;
- (void)releasePDFDocument:(CGPDFDocumentRef *)pdfDoc;

@end

@implementation PDFThumb

@synthesize itemDict;
@synthesize rect;
@synthesize isAsyn;
@synthesize delegate;
@synthesize pdfPath;

+ (PDFThumbItem *)thumbItemWithFilePath:(NSString *)path 
                               withSize:(CGSize)size 
                          withPageIndex:(NSUInteger)pageIndex 
{
    NSURL *pdfURL = nil;
    PDFThumbItem *item = nil;
    CGPDFDocumentRef pdf = NULL;
    
    @try {
        pdfURL = [[NSURL alloc] initFileURLWithPath:path];
        pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        
        UIImage *image = [PDFThumb imageWithPDFDocument:pdf withRect:CGRectMake(0, 0, size.width, size.height) withPageIndex:pageIndex];
        
        item = [[[PDFThumbItem alloc] init] autorelease];
        item.image = image;
        item.pageNumber = pageIndex + 1;
    }
    @catch (NSException *exception) {
        debugLog(@"----获取缩略图错误!");
        debugLog(@"----Exception: %@", [exception name]);
        debugLog(@"----Reason: %@", [exception reason]);
        debugLog(@"----UserInfo: %@", [[exception userInfo] description]);
        item = nil;
    }
    @finally {
        [pdfURL release];
        CGPDFDocumentRelease(pdf);
    }
    
    return item;
}

- (id)initWithPDFPath:(NSString *)path  
             withRect:(CGRect)rt 
       withThumbCount:(NSUInteger)count 
{
    return [self initWithPDFPath:path 
                            withRect:rt 
                      withThumbCount:count 
                              isAsyn:NO];
}

- (id)initWithPDFPath:(NSString *)path  
             withRect:(CGRect)rt 
       withThumbCount:(NSUInteger)count 
               isAsyn:(BOOL)asyn 
{
    self = [super init];
    if (self) {
        pdfPath = [path retain];
        
        rect = rt;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:count];
        for (NSUInteger i = 0; i < count; ++i) {
            PDFThumbItem *item = [[PDFThumbItem alloc] init];
            item.pageNumber = i + 1;
            item.rect = rt;
            NSString *key = [[NSString alloc] initWithFormat:@"%d", i];
            [dict setObject:item forKey:key];
            [key release];
            [item release];
        }
        itemDict = dict;
        isAsyn = asyn;
        if (asyn) {
            indexArray = [[NSMutableArray alloc] initWithCapacity:count];
            /*
            for (NSUInteger i = 0; i < count; ++i) {
                NSNumber *num = [[NSNumber alloc] initWithInteger:i];
                [indexArray addObject:num];
                [num release];
            }
             */
            thumbCondition = [[NSCondition alloc] init];
            thumbCondition.name = @"PDFThumb-Condition";
            
            thumbThread = [[NSThread alloc] initWithTarget:self
                                                  selector:@selector(run)
                                                    object:nil];
            thumbThread.name = @"PDFThumb-Thread";
            [thumbThread start];
        }
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    //pdfDocument = NULL;
    
    [thumbThread cancel];
    [thumbThread release];
    thumbThread = nil;
    [thumbCondition release];
    [itemDict release];
    [indexArray release];
    
    @synchronized(self) {
        [pdfPath release];
        pdfPath = nil;
    }
    [super dealloc];
}

- (void)didUpdateThumbItem:(id)params
{
    if (nil == params) {
        return;
    }
    NSArray *paramArray = (NSArray *)params;
    if ([paramArray count] < 2) {
        return;
    }
    if (![thumbThread isCancelled] && nil != delegate 
        && [delegate respondsToSelector:@selector(didUpdateThumbItem:atPageIndex:withPDFThumb:)]) {
        //debugLog(@"----updateThumbItem: %d----", [(NSNumber *)[paramArray objectAtIndex:1] integerValue]);
        [delegate didUpdateThumbItem:[paramArray objectAtIndex:0] atPageIndex:[(NSNumber *)[paramArray objectAtIndex:1] integerValue] withPDFThumb:self];
    }
}

- (void)didErrorOccurred:(NSError *)error 
{
    if (nil != delegate) {
        [delegate didErrorOccurred:error withPDFThumb:self];
    }
}

- (void)cancel 
{
    self.delegate = nil;
    [thumbThread cancel];
    [thumbCondition lock];
    [thumbCondition signal];
    [thumbCondition unlock];
}

- (CGPDFDocumentRef)createPDFDocumentWithFilePath:(NSString *)path
{
    NSURL *urlPath = [NSURL fileURLWithPath:path];
    CGPDFDocumentRef pdfDoc = CGPDFDocumentCreateWithURL((CFURLRef)urlPath);
    return pdfDoc;
}

- (void)releasePDFDocument:(CGPDFDocumentRef *)pdfDoc
{
    if (NULL != *pdfDoc) {
        CGPDFDocumentRelease(*pdfDoc);
        *pdfDoc = NULL;
    }
}

- (void)run 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    @try {
        NSString *path = nil;
        @synchronized(self) {
            path = [pdfPath retain];
        }
        
        while (![thumbThread isCancelled]) {
            
            NSNumber *pageIndex = nil;
            @synchronized(indexArray) {
                pageIndex = [[self _getPageIndexAtIndex:0] retain];
            }
            
            while (nil != pageIndex && ![thumbThread isCancelled]) {
                NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
                
                NSString *key = [[NSString alloc] initWithFormat:@"%d", pageIndex.integerValue];
                PDFThumbItem *item = [itemDict objectForKey:key];
                [key release];
                
                if (nil == item.image) {
                    CGPDFDocumentRef pdfDocument = [self createPDFDocumentWithFilePath:path];
                    item = [self thumbItemForPageIndex:pageIndex.integerValue withPDFDocument:pdfDocument withRect:item.rect];
                    [self releasePDFDocument:&pdfDocument];
                }

                if (![thumbThread isCancelled]) {
                    NSArray *params = [[NSArray alloc] initWithObjects:item, pageIndex, nil];
                    [self performSelectorOnMainThread:@selector(didUpdateThumbItem:) withObject:params waitUntilDone:[NSThread isMainThread]];
                    [params release];
                }
                [self delIndexArrayForPageIndex:pageIndex.integerValue];
                
                [pageIndex release];
                pageIndex = nil;
                @synchronized(indexArray) {
                    pageIndex = [[self _getPageIndexAtIndex:0] retain];
                }
                
                [pool2 release];
            }
            [pageIndex release];
            pageIndex = nil;
            
            [thumbCondition lock];
            if (![thumbThread isCancelled]) {
                [thumbCondition wait];
            }
            [thumbCondition unlock];
        }
        
        [path release];
    }
    @catch (NSException *exception) {
        debugLog(@"----%@ has exception!----", thumbThread.name);
        [self performSelectorOnMainThread:@selector(didErrorOccurred:) withObject:nil waitUntilDone:[NSThread isMainThread]];
    }
    @finally {
        debugLog(@"----%@ has finished!----", thumbThread.name);
        if (nil != delegate) {
            [(NSObject *)delegate performSelectorOnMainThread:@selector(didFinishPDFThumb:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        
        [pool release];
    }
}

- (NSNumber *)getPageIndexAtIndex:(NSUInteger)index
{
    @synchronized(indexArray) {
        return [self _getPageIndexAtIndex:index];
    }
}

- (NSNumber *)_getPageIndexAtIndex:(NSUInteger)index
{
    if (index >= [indexArray count]) {
        return nil;
    }
    NSNumber *num = [indexArray objectAtIndex:index];
    return num;
}

- (void)delPageIndexAtIndex:(NSUInteger)index 
{
    @synchronized(indexArray) {
        if (index >= [indexArray count]) {
            return;
        }
        [indexArray removeObjectAtIndex:index];
    }
}

- (void)delIndexArrayForPageIndex:(NSUInteger)pageIndex 
{
    @synchronized(indexArray) {
        NSUInteger index;
        BOOL ret = NO;
        NSUInteger count = [indexArray count];
        for (NSUInteger i = 0; i < count; ++i) {
            NSNumber *num = [indexArray objectAtIndex:i];
            if (num.integerValue == pageIndex) {
                index = i;
                ret = YES;
                break;
            }
        }
        if (ret) {
            [indexArray removeObjectAtIndex:index];
        }
    }
}

- (void)updPageIndex:(NSUInteger)pageIndex
{
    @synchronized(indexArray) {
        //NSUInteger index;
        BOOL ret = NO;
        NSUInteger count = [indexArray count];
        for (NSUInteger i = 0; i < count; ++i) {
            NSNumber *num = [indexArray objectAtIndex:i];
            if (num.integerValue == pageIndex) {
                //index = i;
                ret = YES;
                break;
            }
        }
        if (ret) {
            /*
            NSNumber *num = [indexArray objectAtIndex:index];
            [num retain];
            [indexArray removeObjectAtIndex:index];
            [indexArray insertObject:num atIndex:0];
            [num release];
             */
        } else {
            NSNumber *num = [[NSNumber alloc] initWithInteger:pageIndex];
            //[indexArray addObject:num];
            [indexArray insertObject:num atIndex:0];
            [num release];
        }
        if ([indexArray count] > 0) {
            [thumbCondition lock];
            //debugLog(@"----thumbCondition signal----");
            [thumbCondition signal];
            [thumbCondition unlock];
        }
    }
}

- (NSArray *)getAllPageIndexForBookmarkThumb
{
    NSEnumerator *en = [itemDict keyEnumerator];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:[itemDict count]] autorelease];
    NSString *key;
    while (nil != (key = [en nextObject])) {
        PDFThumbItem *item = [itemDict objectForKey:key];
        if (item.isMarked) {
            [array addObject:[NSNumber numberWithInteger:[key integerValue]]];
        }
    }
    
    NSArray *sortArray = [array sortedArrayUsingSelector:@selector(myCompare:)];
    
    return sortArray;
}

- (NSUInteger)thumbCount
{
    return [itemDict count];
}

- (void)clearAllBookmark {
    NSEnumerator *en = [itemDict objectEnumerator];
    PDFThumbItem *item;
    while (nil != (item = [en nextObject])) {
        item.isMarked = NO;
    }
}

- (void)setBookmark:(BOOL)isMarked atPageIndex:(NSUInteger)index 
{
    if (index >= [itemDict count]) {
        return;
    }
    
    NSString *key = [[NSString alloc] initWithFormat:@"%d", index];
    PDFThumbItem *item = [itemDict objectForKey:key];
    [key release];
    if (nil == item) {
        return;
    }
    item.isMarked = isMarked;
}

- (void)asynThumbItemForPageIndex:(NSUInteger)index
{
    [self asynThumbItemForPageIndex:index withRect:self.rect];
}

- (void)asynThumbItemForPageIndex:(NSUInteger)index withRect:(CGRect)rt 
{
    /*
    if (!isAsyn) {
        return;
    }
    PDFThumbItem *item = [self getThumbItemAtPageIndex:index];
    if (nil != item && nil == item.image 
        && ![thumbThread isCancelled] && ![thumbThread isFinished]) {
        
        item.rect = rt;
        
        [self updPageIndex:index];
    } else {
        //debugLog(@"----didUpdateThumbItem22: %d----", index);
        if (nil != delegate && [delegate respondsToSelector:@selector(didUpdateThumbItem:atPageIndex:withPDFThumb:)]) {
            [delegate didUpdateThumbItem:item atPageIndex:index withPDFThumb:self];
        }
    }
     */
    if (!isAsyn) {
        return;
    }
    PDFThumbItem *item = [self getThumbItemAtPageIndex:index];
    if (nil != item && ![thumbThread isCancelled] && ![thumbThread isFinished]) {
        
        item.rect = rt;
        
        [self updPageIndex:index];
    }
}

- (PDFThumbItem *)getThumbItemAtPageIndex:(NSUInteger)index 
{
    if (index >= [itemDict count]) {
        return nil;
    }
    
    NSString *key = [[NSString alloc] initWithFormat:@"%d", index];
    PDFThumbItem *item = [itemDict objectForKey:key];
    [key release];
    return item;
}

static CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect, CGFloat scaleFactor) 
{
    CGAffineTransform scale2 = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale2);
	CGAffineTransform translation = 
    CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return translation;
}

static CGRect scaleRectToFitRect(CGRect rect, CGRect fitRect)
{
    rect.size.height = (fitRect.size.width / rect.size.width) * rect.size.height;
    rect.size.width = fitRect.size.width;
    if (rect.size.height > fitRect.size.height) {
        rect.size.width = (fitRect.size.height / rect.size.height) * rect.size.width;
        rect.size.height = fitRect.size.height;
    }
    return rect;
}

+ (UIImage *)imageWithPDFDocument:(CGPDFDocumentRef)pdfDocument 
                         withRect:(CGRect)rect 
                    withPageIndex:(NSUInteger)pageIndex
{
    /*
     UIImage* thumbnailImage = nil;
     
     if (NULL == pdfDocument) {
     return thumbnailImage;
     }
     
     CGPDFPageRef page;
     UIGraphicsBeginImageContext(rect.size);
     CGContextRef curContext = UIGraphicsGetCurrentContext();
     
     CGContextSaveGState(curContext);
     CGContextTranslateCTM(curContext, 0.0, rect.size.height);
     CGContextScaleCTM(curContext, 1.0, -1.0);
     
     CGContextSetGrayFillColor(curContext, 1.0, 1.0);
     CGContextFillRect(curContext, rect);
     
     
     // Grab the first PDF page
     page = CGPDFDocumentGetPage(pdfDocument, pageIndex + 1);
     CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, rect, 0, true);
     // And apply the transform.
     CGContextConcatCTM(curContext, pdfTransform);
     
     CGContextDrawPDFPage(curContext, page);
     
     // Create the new UIImage from the context
     thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
     
     //Use thumbnailImage (e.g. drawing, saving it to a file, etc)
     
     CGContextRestoreGState(curContext);
     
     UIGraphicsEndImageContext();
     
     return thumbnailImage;
     */
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument,  pageIndex + 1);
    
    CGRect cropBoxRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGRect mediaBoxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGRect pageRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
    int rotationAngle = CGPDFPageGetRotationAngle(page);
    
    CGRect drawRect;
    if (90 == rotationAngle || 270 == rotationAngle) {
        drawRect = scaleRectToFitRect(CGRectMake(pageRect.origin.x, pageRect.origin.y, pageRect.size.height, pageRect.size.width), rect);
    } else {
        drawRect = scaleRectToFitRect(pageRect, rect);
    }
    CGPDFPageRetain(page);
    
    UIImage* thumbnailImage = nil;
    UIGraphicsBeginImageContext(drawRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, drawRect);		
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,  0, drawRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //CGContextTranslateCTM(context, 0, rcPage.origin.y);
    CGContextTranslateCTM(context, drawRect.origin.x, drawRect.origin.y);
    CGFloat scaleFactor = 1.0;
    CGAffineTransform transform;
    
    switch (rotationAngle) {
        case 90:
            scaleFactor =  MIN(drawRect.size.width / pageRect.size.height, drawRect.size.height / pageRect.size.width);
            transform = aspectFit(CGRectMake(pageRect.origin.x, pageRect.origin.y, pageRect.size.height, pageRect.size.width),
                                  drawRect,scaleFactor);
            if (transform.tx < 0) {
                transform.tx = 0;
            }
            if (transform.ty < 0) {
                transform.ty = 0;
            }
            CGContextConcatCTM(context, transform);
            CGContextScaleCTM(context, scaleFactor, scaleFactor);
            CGContextRotateCTM(context, -M_PI / 2);
            CGContextTranslateCTM(context, -CGRectGetMaxX(pageRect), -CGRectGetMinY(pageRect));
            break;
        case 180:
            scaleFactor =  MIN(drawRect.size.width / pageRect.size.width, drawRect.size.height / pageRect.size.height);
            transform = aspectFit(pageRect, drawRect, scaleFactor);
            if (transform.tx < 0) {
                transform.tx = 0;
            }
            if (transform.ty < 0) {
                transform.ty = 0;
            }
            CGContextConcatCTM(context, transform);
            CGContextScaleCTM(context,scaleFactor,scaleFactor);
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -CGRectGetMaxX(pageRect), -CGRectGetMaxY(pageRect));
            break;
        case 270:
            scaleFactor =  MIN(drawRect.size.width / pageRect.size.height, drawRect.size.height / pageRect.size.width);
            transform = aspectFit(CGRectMake(pageRect.origin.x, pageRect.origin.y, pageRect.size.height, pageRect.size.width),
                                  drawRect,scaleFactor);
            if (transform.tx < 0) {
                transform.tx = 0;
            }
            if (transform.ty < 0) {
                transform.ty = 0;
            }
            scaleFactor =  MIN(drawRect.size.width / pageRect.size.height, drawRect.size.height / pageRect.size.width);
            CGContextScaleCTM(context, scaleFactor, scaleFactor);
            CGContextRotateCTM(context, M_PI / 2);
            CGContextTranslateCTM(context, -CGRectGetMinX(pageRect), -CGRectGetMaxY(pageRect));
            break;
        default:
            scaleFactor =  MIN(drawRect.size.width / pageRect.size.width, drawRect.size.height / pageRect.size.height);
            transform = aspectFit(pageRect, drawRect, scaleFactor);
            if (transform.tx < 0) {
                transform.tx = 0;
            }
            if (transform.ty < 0) {
                transform.ty = 0;
            }
            CGContextConcatCTM(context, transform);
            CGContextScaleCTM(context, scaleFactor, scaleFactor);
            CGContextTranslateCTM(context, -CGRectGetMinX(pageRect), -CGRectGetMinY(pageRect));
            break;
    }
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, page);
    
    // Create the new UIImage from the context
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    CGPDFPageRelease(page);
    
    UIGraphicsEndImageContext();
    
    return thumbnailImage;//[thumbnailImage scaleToSize:rect.size];
}

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFDocument:(CGPDFDocumentRef)pdfDocument
{
    return [self thumbItemForPageIndex:index withPDFDocument:pdfDocument withRect:self.rect];
}

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFDocument:(CGPDFDocumentRef)pdfDocument withRect:(CGRect)rt
{
    if (index >= [itemDict count]) {
        return nil;
    }
    
    NSString *key = [[NSString alloc] initWithFormat:@"%d", index];
    PDFThumbItem *item = [itemDict objectForKey:key];
    [key release];
    if (nil == item) {
        return item;
    }
    if (nil != item.image) {
        return item;
    }
    
    if (NULL == pdfDocument) {
        return item;
    }
    
    NSUInteger totalNum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (index >= totalNum) {
        return item;
    }
    
    UIImage* thumbnailImage = [PDFThumb imageWithPDFDocument:pdfDocument withRect:rt withPageIndex:index]; 
    
    if (nil != thumbnailImage) {
        item.image = thumbnailImage;
    }
    return item;
}

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFPath:(NSString *)path
{
    return [self thumbItemForPageIndex:index withPDFPath:path withRect:self.rect];
}

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index withPDFPath:(NSString *)path withRect:(CGRect)rt
{
    CGPDFDocumentRef pdf = [self createPDFDocumentWithFilePath:path];
    PDFThumbItem *item = [self thumbItemForPageIndex:index withPDFDocument:pdf withRect:rt];
    [self releasePDFDocument:&pdf];
    return item;
}

- (PDFThumbItem *)thumbItemForPageIndex:(NSUInteger)index 
{
    return [self thumbItemForPageIndex:index withPDFPath:self.pdfPath];
}

@end
