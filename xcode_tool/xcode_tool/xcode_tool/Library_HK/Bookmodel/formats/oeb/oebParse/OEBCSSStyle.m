//
//  OEBTextStyle.m
//  OEBReader
//
//  Created by heyong on 11-10-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBCSSStyle.h"
#import "OEBConstant.h"
#import "macros_for_IOS_hk.h"
#import "UIColor+colorWithName.h"

CG_INLINE OEBRgb OEBRgbMake(CGFloat r, CGFloat g,  CGFloat b, CGFloat a) {
    OEBRgb rgb; 
    rgb.r = r; 
    rgb.g = g;
    rgb.b = b;
    rgb.a = a;
    return rgb;
}

@implementation OEBFont

@synthesize style;
@synthesize fontSize;
@synthesize fontName;

- (id)init
{
    self = [super init];
    if (self) {
        style = OEBFontStyleNone;
        fontSize = -MAXFLOAT;
        fontName = nil;
    }
    return self;
}

- (id)initWithStyle:(OEBFontStyle)fontStyle withFontSize:(CGFloat)size withFontName:(NSString *)name
{
    self = [super init];
    if (self) {
        style = fontStyle;
        fontSize = size;
        fontName = [name retain];
    }
    return self;
}

- (id)initWithOEBFont:(OEBFont *)font
{
    if (nil == font) {
        return [self init];
    } else {
        return [self initWithStyle:font.style withFontSize:font.fontSize withFontName:font.fontName];
    }
}

- (void)dealloc
{
    [fontName release];
    [super dealloc];
}

- (UIFont *)getUIFont
{
    UIFont *font = nil;
    CGFloat size;
    assert(fontSize != 0);
    if (fontSize == -MAXFLOAT) {
        size = kSystemFontDefaultSize;
    } else {
        size = fontSize;
    }
    // 
    if (nil != fontName) {
        font = [UIFont fontWithName:fontName size:size];
    } else {
        switch (style) {
            case OEBFontStyleBoldItalic:
                font = [OEBCSSStyle boldItalicFontOfFont:[UIFont systemFontOfSize:size]];
                if (nil == font) {
                    font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:size];
                }
                break;
            case OEBFontStyleBold:
                font = [UIFont boldSystemFontOfSize:size];
                break;
            case OEBFontStyleItalic:
                font = [UIFont italicSystemFontOfSize:size];
                break;
            case OEBFontStyleNormal:
            case OEBFontStyleNone:
            default:
                font = nil;
                break;
        }
    }


    return font;
}

@end

@interface OEBCSSStyle ()

@end

@implementation OEBCSSStyle

@synthesize textAlign;
@synthesize textFont;
@synthesize textIndent;
@synthesize textColor;
@synthesize fontStyle;

- (NSString*) description
{

    NSString* textAlignStr = [NSString stringWithFormat:@"%d",textAlign];
    NSString* textFontStr = textFont?[textFont description]:@" ";
    NSString* textIndentStr = [NSString stringWithFormat:@"%d",textIndent];
    NSString* textColorStr = textColor?[textColor description]:@" ";

    NSString* str = [[[[NSString stringWithString:textAlignStr] stringByAppendingString:textFontStr] stringByAppendingString:textIndentStr] stringByAppendingString:textColorStr];
    
    return str;
}

- (id)init
{
    self = [super init];
    if (self) {
        textAlign = OEBTextAlignmentNone;
        textIndent = NO;
        textColor = kCSSTextColor_Black;
        fontStyle = [[OEBFont alloc] init];
        textFont = [[fontStyle getUIFont] retain];
    }
    return self;
}

- (id)initWithTextAlign:(OEBTextAlignment)align withFontStyle:(OEBFont *)style withTextIndent:(BOOL)indent withTextColor:(NSString *)color
{
    self = [super init];
    if (self) {
        textAlign = align;
        fontStyle = [[OEBFont alloc] initWithOEBFont:style];
        textFont = [[fontStyle getUIFont] retain];
        if (textFont.pointSize == 0)
        {
            sleep(0);
        }
        textIndent = indent;
        textColor = [color retain];
    }
    return self;
}

- (id)initWithOEBCSSStyle:(OEBCSSStyle *)style
{
    if (nil == style) {
        return [self init];
    } else {
        return [self initWithTextAlign:style.textAlign withFontStyle:style.fontStyle withTextIndent:style.textIndent withTextColor:style.textColor];
    }
}

- (void)dealloc {
    [textFont release];
    [textColor release];
    [fontStyle release];
    [super dealloc];
}

- (void)appendingCSSStyle:(OEBCSSStyle *)style
{    
    if (nil == style) {
        return;
    }
    if (OEBTextAlignmentNone == textAlign) {
        self.textAlign = style.textAlign;
    }
    
    if (nil != fontStyle && nil != style.fontStyle) {
        if (OEBFontStyleNone == fontStyle.style) {
            fontStyle.style = style.fontStyle.style;
        }
        
        if (nil == fontStyle.fontName) {
            fontStyle.fontName = style.fontStyle.fontName;
        }
        
        if (-MAXFLOAT == fontStyle.fontSize) {
            fontStyle.fontSize = style.fontStyle.fontSize;
        }
        
        self.textFont = [fontStyle getUIFont];
    }
}

- (OEBCSSStyle *)cssStyleByAppendingCSSStyle:(OEBCSSStyle *)style
{
    OEBCSSStyle *newStyle = [[[OEBCSSStyle alloc] initWithOEBCSSStyle:self] autorelease];
    
    if (nil != style) {
        if (OEBTextAlignmentNone == textAlign) {
            newStyle.textAlign = style.textAlign;
        }
        
        if (nil != fontStyle && nil != style.fontStyle) {
            if (OEBFontStyleNone == fontStyle.style) {
                newStyle.fontStyle.style = style.fontStyle.style;
            }
            
            if (nil == fontStyle.fontName) {
                newStyle.fontStyle.fontName = style.fontStyle.fontName;
            }
            
            if (-MAXFLOAT == fontStyle.fontSize) {
                newStyle.fontStyle.fontSize = style.fontStyle.fontSize;
            }
            
            newStyle.textFont = [newStyle.fontStyle getUIFont];
        }
    }
    return newStyle;
}

+ (OEBRgb)getRGBInUIColor:(UIColor *)color {
    OEBRgb rgb = OEBRgbMake(0, 0, 0, 1);
    if (nil == color) {
        return rgb;
    }
    
    CGColorRef ref = [color CGColor];
    if (4 == CGColorGetNumberOfComponents(ref)) {
        const CGFloat *components = CGColorGetComponents(ref);
        rgb.r = components[0];
        rgb.g = components[1];
        rgb.b = components[2];
        rgb.a = components[3];
    }
    return rgb;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }

    
    if ([cString length] < 6) 
    {
        NSString* newStr = @"";
        newStr = [newStr stringByAppendingString:[cString substringWithRange:NSMakeRange(0, 1)]];
        newStr = [newStr stringByAppendingString:[cString substringWithRange:NSMakeRange(0, 1)]];
        newStr = [newStr stringByAppendingString:[cString substringWithRange:NSMakeRange(1, 1)]];
        newStr = [newStr stringByAppendingString:[cString substringWithRange:NSMakeRange(1, 1)]];
        newStr = [newStr stringByAppendingString:[cString substringWithRange:NSMakeRange(2, 1)]];
        newStr = [newStr stringByAppendingString:[cString substringWithRange:NSMakeRange(2, 1)]];
        cString = newStr;
    }
    
    if ([cString length] != 6) {
        return kCSSFontColorDefault;
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (UIColor *)getUIColor {
    NSString *color = [textColor lowercaseString];
    color = [color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([color hasPrefix:@"#"]) {
        return [OEBCSSStyle colorWithHexString:color];
    }
    
    if ([color hasPrefix:@"rgb"]) {
        NSRange r1 = [color rangeOfString:@"("];
        NSRange r2 = [color rangeOfString:@")"];
        
        if (r1.length > 0 && r2.length > 0 && r2.location > r1.location + 1) {
            NSString *subStr = [color substringWithRange:NSMakeRange(
                            r1.location + 1, r2.location - r1.location - 1)];
            NSArray *values = [subStr componentsSeparatedByString:@","];
            if (3 == [values count]) {
                NSInteger red = [[[values objectAtIndex:0] 
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
                NSInteger green = [[[values objectAtIndex:1] 
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
                NSInteger blue = [[[values objectAtIndex:2] 
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
                return [UIColor colorWithRed:(CGFloat)(red & 0xFF0000) / 255.0 
                                       green:(CGFloat)(green & 0x00FF00) / 255.0 
                                        blue:(CGFloat)(blue & 0x0000FF) / 255.0 
                                       alpha:1.0];
            }
        }
    }
    
    UIColor* retColor =  [UIColor colorWithColorName:color];
    if (retColor == nil) 
    {
        retColor = kCSSFontColorDefault;
    }
    return retColor;
}

+ (NSString *)nearnessFontNameForFamilyName:(NSString *)familyName withFontStyle:(OEBFontStyle)style {
    // 
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSString *fontName = nil;
    familyName = [familyName lowercaseString];
    // 
    for (NSString *name in familyNames) {
        if ([[name lowercaseString] isEqualToString:familyName]) {
            // 
            NSArray *fontNames = [UIFont fontNamesForFamilyName:name];
            switch (style) {
                case OEBFontStyleBoldItalic:                    
                    for (NSString *name in fontNames) {
                        NSString *newName = [name lowercaseString];
                        if ([newName rangeOfString:@"bolditalic"].length > 0 
                            || [newName rangeOfString:@"boldoblique"].length > 0) {
                            fontName = name;
                            break;
                        }
                    }
                    
                    break;
                case OEBFontStyleBold:
                    for (NSString *name in fontNames) {
                        NSString *newName = [name lowercaseString];
                        if ([[newName lowercaseString] rangeOfString:@"bold"].length > 0 
                            && ([newName rangeOfString:@"italic"].length == 0 
                            && [newName rangeOfString:@"oblique"].length == 0)) {
                            fontName = name;
                            break;
                        }
                    }
                    break;
                case OEBFontStyleItalic:
                    for (NSString *name in fontNames) {
                        NSString *newName = [name lowercaseString];
                        if ([newName rangeOfString:@"bold"].length == 0 
                            && ([newName rangeOfString:@"italic"].length > 0 
                            || [newName rangeOfString:@"oblique"].length > 0)) {
                            fontName = name;
                            break;
                        }
                    }
                    break;
                case OEBFontStyleNormal:
                default:
                    for (NSString *name in fontNames) {
                        NSString *newName = [name lowercaseString];
                        if ([newName rangeOfString:@"bold"].length == 0 
                            && [newName rangeOfString:@"italic"].length == 0 
                            && [newName rangeOfString:@"oblique"].length == 0) {
                            fontName = name;
                            break;
                        }
                    }
                    break;
            }
            break;
        }
    }
    [familyNames release];
    return fontName;
}

+ (NSString *)nearnessFontNameForFontName:(NSString *)fName withFontStyle:(OEBFontStyle)style{
    // 
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSString *fontName = nil;
    // 
    for (NSString *name in familyNames) {
        // 
        NSArray *fontNames = [UIFont fontNamesForFamilyName:name];
        switch (style) {
            case OEBFontStyleBoldItalic:                    
                for (NSString *name in fontNames) {
                    NSString *newName = [name lowercaseString];
                    if ([newName rangeOfString:@"bolditalic"].length > 0 
                        || [newName rangeOfString:@"boldoblique"].length > 0) {
                        fontName = name;
                        break;
                    }
                }
                
                break;
            case OEBFontStyleBold:
                for (NSString *name in fontNames) {
                    NSString *newName = [name lowercaseString];
                    if ([[newName lowercaseString] rangeOfString:@"bold"].length > 0 
                        && ([newName rangeOfString:@"italic"].length == 0 
                            && [newName rangeOfString:@"oblique"].length == 0)) {
                            fontName = name;
                            break;
                        }
                }
                break;
            case OEBFontStyleItalic:
                for (NSString *name in fontNames) {
                    NSString *newName = [name lowercaseString];
                    if ([newName rangeOfString:@"bold"].length == 0 
                        && ([newName rangeOfString:@"italic"].length > 0 
                            || [newName rangeOfString:@"oblique"].length > 0)) {
                            fontName = name;
                            break;
                        }
                }
                break;
            case OEBFontStyleNormal:
            default:
                for (NSString *name in fontNames) {
                    NSString *newName = [name lowercaseString];
                    if ([newName rangeOfString:@"bold"].length == 0 
                        && [newName rangeOfString:@"italic"].length == 0 
                        && [newName rangeOfString:@"oblique"].length == 0) {
                        fontName = name;
                        break;
                    }
                }
                break;
        }
        break;
    }
    [familyNames release];
    return fontName;
}

+ (UIFont *)boldFontOfFont:(UIFont *)font {
    NSString *fontName = [self nearnessFontNameForFamilyName:[font familyName] withFontStyle:OEBFontStyleBold];
    return [UIFont fontWithName:fontName size:font.pointSize];
}

+ (UIFont *)italicFontOfFont:(UIFont *)font {
    NSString *fontName = [self nearnessFontNameForFamilyName:[font familyName] withFontStyle:OEBFontStyleItalic];
    return [UIFont fontWithName:fontName size:font.pointSize];
}

+ (UIFont *)boldItalicFontOfFont:(UIFont *)font {
    NSString *fontName = [self nearnessFontNameForFamilyName:[font familyName] withFontStyle:OEBFontStyleBoldItalic];
    return [UIFont fontWithName:fontName size:font.pointSize];
}

@end
