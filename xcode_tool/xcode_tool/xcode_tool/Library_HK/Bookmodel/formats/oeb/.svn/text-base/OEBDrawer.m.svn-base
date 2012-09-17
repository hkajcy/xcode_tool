//
//  OEBDrawer.m
//  moonBookReader
//
//  Created by  on 11-11-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBDrawer.h"
#import "OEBRow.h"
#import "ZipArchive.h"
#import "bookConfig.h"
#import "OEBLocation.h"
#import "OEBConstant.h"

@interface OEBDrawer ()

+ (void)setDrawerColor;

@end

@implementation OEBDrawer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (void)setDrawerColor {
    if (1 != [bookConfig sharedInstance].enviromentType) {
        [[UIColor blackColor] set];
    } else {
        [[UIColor whiteColor] set];
    }
}

+ (void) drawPage:(NSArray*)rows 
        isPlaying:(BOOL)isPlaying 
          withZip:(ZipArchive*)zipArchive
withStartPlayingLocation:(OEBLocation*)startLocation
withStopPlayingLocation:(OEBLocation*)stopLocation
      WithContext:(CGContextRef)context

{
    
    NSUInteger rowCount = [rows count];
    
    if (0 == rowCount) {
        return;
    }
    
    if (isPlaying) {
        assert(nil != startLocation);
        assert(nil != stopLocation);
    }
    
    [OEBDrawer setDrawerColor];
    
    for (NSUInteger i = 0; i < rowCount; ++i) {
        NSArray *cells = [rows objectAtIndex:i];
        NSUInteger cellCount = [cells count];
        
        for (NSUInteger j = 0; j < cellCount; ++j) {
            OEBRow *row = [cells objectAtIndex:j];
            
            // 绘制文字
            if (OEBRowTypeText == row.type) {
                
                OEBTextRow *textPow = (OEBTextRow *)row;
                NSString *content = [[(OEBTextParagraph *)textPow.paragraph content] substringWithRange:textPow.textRange];
                OEBTextParagraph *textParagraph = (OEBTextParagraph *)textPow.paragraph;
                //[[[textParagraph textStyle] getUIColor] set];
                [content drawInRect:textPow.rect 
                           withFont:[textParagraph textStyle].textFont 
                      lineBreakMode:kOEBLineBreakMode 
                          alignment:[textParagraph textStyle].textAlign];
            
            // 绘制图片
            } else if (OEBRowTypeImage == row.type) {
                // 
                OEBImageRow *imageRow = (OEBImageRow *)row;
                NSString *path = [(OEBImageParagraph *)imageRow.paragraph imagePath];
                NSData *imageData = [zipArchive readFileWithPath:path];
                UIImage *img = [[UIImage alloc] initWithData:imageData];
                [img drawInRect:imageRow.rect];
                [img release];
                
            // 绘制超链接
            } else if (OEBRowTypeHyperlink == row.type) {
                [[UIColor blueColor] set];
                
                OEBHyperlinkRow *textPow = (OEBHyperlinkRow *)row;
                OEBHyperlinkParagraph *hyperlinkParagraph = (OEBHyperlinkParagraph *)textPow.paragraph;
                //[[[hyperlinkParagraph textStyle] getUIColor] set];
                
                NSString *content = [[hyperlinkParagraph content] substringWithRange:textPow.textRange];
                [content drawInRect:textPow.rect 
                           withFont:[hyperlinkParagraph textStyle].textFont 
                      lineBreakMode:kOEBLineBreakMode 
                          alignment:[hyperlinkParagraph textStyle].textAlign];
                
                CGRect rect = textPow.rect;
                CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
                CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
                CGContextClosePath(context);
                CGContextStrokePath(context);
                
                [OEBDrawer setDrawerColor];
            }
        }
    }
    
    [OEBDrawer setDrawerColor];
}

- (void)dealloc
{
    [super dealloc];
}

@end
