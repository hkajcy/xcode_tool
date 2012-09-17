//
//  UIColor+colorWithName.m
//  DocinBookiPad
//
//  Created by  on 12-9-5.
//  Copyright (c) 2012年 Docin Ltd. All rights reserved.
//

#import "UIColor+colorWithName.h"
#import "HashTools.h"
@implementation UIColor (colorWithName)

+ (UIColor*) colorWithColorName:(NSString*)colorName
{
    const struct NamedColor* color = findColor([colorName UTF8String], [colorName length]);
    
    if (color) 
    {
        CGFloat r = redChannel(color->ARGBValue) / 255.f;
        CGFloat g = greenChannel(color->ARGBValue) / 255.f;
        CGFloat b = blueChannel(color->ARGBValue) / 255.f;
        CGFloat a = alphaChannel(color->ARGBValue) / 255.f;
        
        return  [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    else
    {
        return nil;
    }
}

@end
