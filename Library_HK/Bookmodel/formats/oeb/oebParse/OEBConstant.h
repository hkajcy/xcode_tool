//
//  OEBConstant.h
//  OEBReader
//
//  Created by heyong on 11-11-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define kSystemFontDefaultSize  12

#define kCSSFontSize_Medium     kSystemFontDefaultSize
#define kCSSFontSize_XXSmall    (kCSSFontSize_Medium - 6)
#define kCSSFontSize_XSmall     (kCSSFontSize_Medium - 4)
#define kCSSFontSize_Small      (kCSSFontSize_Medium - 2)

#define kCSSFontSize_Large      (kCSSFontSize_Medium + 2)
#define kCSSFontSize_XLarge     (kCSSFontSize_Medium + 4)
#define kCSSFontSize_XXLarge    (kCSSFontSize_Medium + 6)

/*
 + (UIColor *)blackColor;      // 0.0 white 
 + (UIColor *)darkGrayColor;   // 0.333 white 
 + (UIColor *)lightGrayColor;  // 0.667 white 
 + (UIColor *)whiteColor;      // 1.0 white 
 + (UIColor *)grayColor;       // 0.5 white 
 + (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB 
 + (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB 
 + (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB 
 + (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB 
 + (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB 
 + (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB 
 + (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB 
 + (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB 
 + (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB 
 */

#define kCSSTextColor_Red @"red"
#define kCSSTextColor_Green @"green"
#define kCSSTextColor_Yellow @"yellow"
#define kCSSTextColor_Black @"black"
#define kCSSTextColor_Blue @"blue"
#define kCSSTextColor_White @"white"
#define kCSSTextColor_DarkGray @"darkgray"
#define kCSSTextColor_LightGray @"lightgray"
#define kCSSTextColor_Gray @"gray"
#define kCSSTextColor_Cyan @"cyan"
#define kCSSTextColor_Magenta @"magenta"
#define kCSSTextColor_Orange @"orange"
#define kCSSTextColor_Purple @"purple"
#define kCSSTextColor_Brown @"brown"

// 默认的首行缩进字符数
#define kCSSTextIndentDefaultCharacterNumber 2

// 默认的段间距字符数
#define kCSSParagraphHeightDefaultCharacterNumber 1

// 默认文字行间距
//#define kCSSLineHeightDefault 10

// 默认字体颜色
#define kCSSFontColorDefault ([UIColor blackColor])

#define kOEBLineBreakMode UILineBreakModeWordWrap 
//#define kOEBLineBreakMode UILineBreakModeCharacterWrap

// 是否支持超链接
#define SUPPORT_HYPERLINK

// 支持CSS内联样式
//#define SUPPORT_INLINE_CSS_STYLE
// 支持CSS内部样式
#define SUPPORT_INTERNAL_CSS_STYLE
// 支持CSS外部样式
#define SUPPORT_EXTERNAL_CSS_STYLE

// 计算代码执行效率
#define TIME_CALCULATED

// 
#define kOEBErrorLoadChapterDataFailed @"章节数据已损坏。"

static NSString *const kHTMLTag_Link = @"link";
static NSString *const kHTMLTag_Title = @"title";
static NSString *const kHTMLTag_P = @"p";
static NSString *const kHTMLTag_Div = @"div";
static NSString *const kHTMLTag_Li = @"li";
static NSString *const kHTMLTag_Ul = @"ul";
static NSString *const kHTMLTag_Text = @"text";
static NSString *const kHTMLTag_Img = @"img";
static NSString *const kHTMLTag_Br = @"br";
static NSString *const kHTMLTag_Span = @"span";
static NSString *const kHTMLTag_Strong = @"strong";
static NSString *const kHTMLTag_B = @"b";
static NSString *const kHTMLTag_I = @"i";
static NSString *const kHTMLTag_A = @"a";
static NSString *const kHTMLTag_H1 = @"h1";
static NSString *const kHTMLTag_H2 = @"h2";
static NSString *const kHTMLTag_H3 = @"h3";
static NSString *const kHTMLTag_H4 = @"h4";
static NSString *const kHTMLTag_H5 = @"h5";
static NSString *const kHTMLTag_H6 = @"h6";
static NSString *const kHTMLTag_Svg = @"svg";
static NSString *const kHTMLTag_Image = @"image";
static NSString *const kHTMLTag_Style = @"style";
static NSString *const kHTMLAttribute_Rel = @"rel";
static NSString *const kHTMLAttribute_Type = @"type";
static NSString *const kHTMLAttribute_Href = @"href";
static NSString *const kHTMLAttribute_Class = @"class";
static NSString *const kHTMLAttribute_Src = @"src";
static NSString *const kHTMLAttribute_xlinkHref = @"xlink:href";