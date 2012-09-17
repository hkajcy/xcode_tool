//
//  UIColor+colorWithName.h
//  DocinBookiPad
//
//  Created by  on 12-9-5.
//  Copyright (c) 2012年 Docin Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//颜色
#define PAPER_NIGHT_COLOR                           [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0]
#define PAPER_NIGHT_COLOR_REF                       PAPER_NIGHT_COLOR.CGColor
#define PAPER_NIGHT_ALPHA_COLOR_REF                 [PAPER_NIGHT_COLOR colorWithAlphaComponent:0.3].CGColor

#define PAPER_COLOR [UIColor colorWithRed:240.0/255.0 green:232.0/255.0 blue:209.0/255.0 alpha:1.0] //docin
//#define PAPER_COLOR [UIColor colorWithRed:246.0/255.0 green:245.0/255.0 blue:241.0/255.0 alpha:1.0]
#define PAPER_COLOR_REF PAPER_COLOR.CGColor
#define PAPER_AlPHA_COLOR_REF [PAPER_COLOR colorWithAlphaComponent:0.8].CGColor

#define PRE_PAPER_LIGHT_COLOR [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:0.9]
#define PRE_PAPER_NIGHT_COLOR [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.9]
// 设置界面
#define FONTCOLOR [UIColor colorWithRed:108.0/255.0 green:71.0/255.0 blue:42.0/255.0 alpha:0.9]
#define SETTING_FONTSIZE [UIFont  boldSystemFontOfSize:14.0f]

#define YANGPIZHI_BACKGROUND_COLOR  [UIColor colorWithRed:226.0f/255.0f green:212.0f/255.0f blue:179.0f/255.0f alpha:1.0]
#define ZIPIZHI_BACKGROUND_COLOR    [UIColor colorWithRed:164.0f/255.0f green:178.0f/255.0f blue:215.0f/255.0f alpha:1.0]
#define DOUSHALV_BACKGROUND_COLOR   [UIColor colorWithRed:199.0f/255.0f green:237.0f/255.0f blue:204.0f/255.0f alpha:1.0]

@interface UIColor (colorWithName)

//如果名字不对的话，将返回nil
+ (UIColor*) colorWithColorName:(NSString*)colorName;

@end
