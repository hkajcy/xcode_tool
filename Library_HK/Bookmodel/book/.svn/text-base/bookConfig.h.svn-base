//
//  bookConfig.h
//  DocInBookReader
//
//  Created by juan howard on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define bookConfigInstance  [bookConfig sharedInstance]

enum enviromentType
{
    enviromentType_night = 0,
    enviromentType_light = 1,
    enviromentType_yangpizhi = 2,
    enviromentType_zipizhi = 3,
    enviromentType_doushalv = 4,
};

@interface bookConfig : NSObject {
    UIFont* font;
    NSString* fontName;
    CGFloat fontSize;
    CGFloat lineSpacing;
    CGFloat paragraphSpacing;
    CGFloat alphaValue;
    enum enviromentType enviromentType;
    enum enviromentType oldEnviromentType;
    
    //CGFloat textDrawAreaY;
    //CGFloat textDrawAreaH;
    CGRect  textDrawArea;
    
    CGFloat oebFontScale;
    
    BOOL    isBackground;
    BOOL    isPlaying;
    CGFloat eVoicePlayTime;  
    int     turnPageMode; //0：仿真翻页 1：左右滑动
    
    BOOL    isFullMode;
    int     maxLengthInALine;//一行里面最多可以容纳的字符数
    int     maxLengthInALine_LandScape;
    int     maxLengthInAFrame;
    float   fontHeight;
}
@property(nonatomic,retain) UIFont*         font;
@property (nonatomic,retain) NSString*      fontName;
@property(nonatomic,assign) CGFloat         fontSize;
@property(nonatomic,assign) CGFloat         lineSpacing;
@property(nonatomic,assign) CGFloat paragraphSpacing;
@property(nonatomic, assign) CGFloat         oebFontScale;
@property (assign) CGFloat alphaValue;
@property(nonatomic,assign) enum enviromentType enviromentType;
@property (assign,nonatomic) CGRect textDrawArea;
@property (assign,nonatomic) BOOL    isBackground;
@property (nonatomic,assign) BOOL    isPlaying;
@property (nonatomic) CGFloat eVoicePlayTime;
@property (nonatomic,assign) int     turnPageMode;
@property (nonatomic,assign) BOOL    isTuchTurn;
@property (nonatomic,assign) BOOL       isFullMode;
@property (nonatomic,readonly) int     maxLengthInALine;//一行里面最多可以容纳的字符数
@property (nonatomic,readonly) int     maxLengthInALine_LandScape;
@property (nonatomic,readonly) int     maxLengthInAFrame;
@property (nonatomic,readonly) float     fontHeight;
@property (nonatomic,retain) UIColor* backGrounColor;
@property (nonatomic,assign) BOOL   isNOAd;
@property (nonatomic, retain) NSMutableArray* enviromentArray;
@property (nonatomic,assign) enum enviromentType oldEnviromentType;
+ (bookConfig*) sharedInstance;
- (void) saveBookConfig;

- (id) dicWithEnviromentType:(enum enviromentType)type;
- (UIColor*) backgrounColorWithEnviromentType:(enum enviromentType)type;
- (enum enviromentType) enviromentTypeWithBackgrounColor:(UIColor*)backgrounColor;
@end
