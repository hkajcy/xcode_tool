//
//  OEBTextStyle.h
//  OEBReader
//
//  Created by heyong on 11-10-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OEBFontStyleNone = 0x100,
    OEBFontStyleNormal,
    OEBFontStyleBold,
    OEBFontStyleItalic,
    OEBFontStyleBoldItalic
} OEBFontStyle;

typedef struct {
    CGFloat a;  // alpha
    CGFloat r;  // red
    CGFloat g;  // green
    CGFloat b;  // blue
} OEBRgb;

typedef enum {
    OEBTextAlignmentNone = 0x100,
    OEBTextAlignmentLeft,
    OEBTextAlignmentCenter,
    OEBTextAlignmentRight,
} OEBTextAlignment;

CG_INLINE OEBRgb OEBRgbMake(CGFloat r, CGFloat g,  CGFloat b, CGFloat a);

@interface OEBFont : NSObject {
    OEBFontStyle style;
    CGFloat fontSize;
    NSString *fontName;
}

@property (nonatomic) OEBFontStyle style;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontName;

- (id)initWithStyle:(OEBFontStyle)fontStyle withFontSize:(CGFloat)size withFontName:(NSString *)name;
- (id)initWithOEBFont:(OEBFont *)font;

- (UIFont *)getUIFont;

@end

@interface OEBCSSStyle : NSObject {
    OEBTextAlignment textAlign;
    UIFont *textFont;
    OEBFont *fontStyle;
    
    NSString *textColor;
    BOOL textIndent;
}

@property (nonatomic) OEBTextAlignment textAlign;
/* 文本的水平对齐方式，默认为左对齐：UITextAlignmentLeft */

@property (nonatomic, retain) UIFont *textFont;

@property (nonatomic, retain) OEBFont *fontStyle;

@property (nonatomic) BOOL textIndent;

@property (nonatomic, copy) NSString *textColor;

- (id)initWithTextAlign:(OEBTextAlignment)align 
          withFontStyle:(OEBFont *)style
         withTextIndent:(BOOL)indent
          withTextColor:(NSString *)color;
- (id)initWithOEBCSSStyle:(OEBCSSStyle *)style;

- (UIColor *)getUIColor;

- (void)appendingCSSStyle:(OEBCSSStyle *)style;
- (OEBCSSStyle *)cssStyleByAppendingCSSStyle:(OEBCSSStyle *)style;

+ (OEBRgb)getRGBInUIColor:(UIColor *)color;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (NSString *)nearnessFontNameForFamilyName:(NSString *)familyName withFontStyle:(OEBFontStyle)style;
+ (NSString *)nearnessFontNameForFontName:(NSString *)fontName withFontStyle:(OEBFontStyle)style;
+ (UIFont *)boldFontOfFont:(UIFont *)font;
+ (UIFont *)italicFontOfFont:(UIFont *)font;
+ (UIFont *)boldItalicFontOfFont:(UIFont *)font;

@end