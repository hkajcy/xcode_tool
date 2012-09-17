//
//  bookConfig.m
//  DocInBookReader
//
//  Created by juan howard on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "bookConfig.h"
#import "macros_for_IOS_hk.h"
#import <CoreText/CoreText.h>
#import "BookSaveFile.h"
#import "UIColor+colorWithName.h"
static bookConfig* instance = nil;


#define kEnviromentBackgoundColor                   (@"kEnviromentBackgoundColor")
#define kEnviromentBackgoundName                    (@"kEnviromentBackgoundName")
#define kEnviromentBackgoundType                    (@"kEnviromentBackgoundType")
#define kEnviromentDrawColor                        (@"kEnviromentDrawColor")

#define enviromentName_Normal    (@"正常")
#define enviromentName_Night     (@"夜晚")
#define enviromentName_Yangpizhi (@"羊皮纸")
#define enviromentName_ZIPIZHI   (@"飘渺紫")
#define enviromentName_Doushalv  (@"豆沙绿")

@implementation bookConfig
@synthesize font;
@synthesize fontName;
@synthesize fontSize;
@synthesize alphaValue;
@synthesize lineSpacing;
@synthesize paragraphSpacing;
@synthesize enviromentType;
@synthesize textDrawArea;
@synthesize isBackground;
@synthesize isPlaying;
@synthesize oebFontScale;
@synthesize eVoicePlayTime;
@synthesize turnPageMode;
@synthesize isTuchTurn;
@synthesize isFullMode;
@synthesize maxLengthInALine;
@synthesize maxLengthInALine_LandScape;
@synthesize maxLengthInAFrame;
@synthesize fontHeight;
@synthesize backGrounColor;
@synthesize isNOAd;
@synthesize enviromentArray;
@synthesize oldEnviromentType;
+ (bookConfig*) sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[bookConfig alloc] init];
        }
        return instance;
    }
}

- (void) setFontSize:(CGFloat)fontSize_
{
    int pointSize = (int)fontSize_;
    self.font = [self.font fontWithSize:pointSize];
    fontSize = pointSize;
}

- (void) setLineSpacing:(CGFloat)lineSpacing_
{
    lineSpacing = (int)lineSpacing_;
}

- (void) setEnviromentType:(enum enviromentType)enviromentType_
{
    enviromentType = enviromentType_;
    
    if (enviromentType != enviromentType_night)
    {
        oldEnviromentType = enviromentType;
    }
}

- (void) initEnviromentArray
{
    self.enviromentArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.enviromentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:enviromentName_Normal,kEnviromentBackgoundName,
                                     PAPER_COLOR,kEnviromentBackgoundColor,
                                     [NSNumber numberWithInt:enviromentType_light],kEnviromentBackgoundType,
                                     [UIColor blackColor],kEnviromentDrawColor,
                                     nil]];
 
    [self.enviromentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:enviromentName_Yangpizhi,kEnviromentBackgoundName,
                                     YANGPIZHI_BACKGROUND_COLOR,kEnviromentBackgoundColor,
                                     [NSNumber numberWithInt:enviromentType_yangpizhi],kEnviromentBackgoundType,
                                     [UIColor blackColor],kEnviromentDrawColor,
                                     nil]];
    [self.enviromentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:enviromentName_ZIPIZHI,kEnviromentBackgoundName,
                                     ZIPIZHI_BACKGROUND_COLOR,kEnviromentBackgoundColor,
                                     [NSNumber numberWithInt:enviromentType_zipizhi],kEnviromentBackgoundType,
                                     [UIColor blackColor],kEnviromentDrawColor,
                                     nil]];
    [self.enviromentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:enviromentName_Doushalv,kEnviromentBackgoundName,
                                     DOUSHALV_BACKGROUND_COLOR,kEnviromentBackgoundColor,
                                     [NSNumber numberWithInt:enviromentType_doushalv],kEnviromentBackgoundType,
                                     [UIColor blackColor],kEnviromentDrawColor,
                                     nil]];
    
    [self.enviromentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:enviromentName_Night,kEnviromentBackgoundName,
                                     PAPER_NIGHT_COLOR,kEnviromentBackgoundColor,
                                     [NSNumber numberWithInt:enviromentType_night],kEnviromentBackgoundType,
                                     [UIColor whiteColor],kEnviromentDrawColor,
                                     nil]];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//        BOOL isfirstSetting = ![userDefaults boolForKey:@"isfirstSetting"];
//        if(isfirstSetting)
//        {
//            [userDefaults setFloat: 0.4 forKey:@"readersrcreenalphavalue"];
//            alphaValue = 0.4;
//            [userDefaults setBool:YES forKey:@"isfirstSetting"];
//            //保存正在读的书
//            [userDefaults setValue:[NSNumber numberWithInt:-1000] forKey:NOWREADBOOK];
//        }
//        else
//        {
//            alphaValue = [userDefaults floatForKey:@"readersrcreenalphavalue"];
//        }
//        float savedFontSize = [userDefaults floatForKey:@"readersrcreenfontsizevalue"];
//        if(ABS(savedFontSize - 0)> 0.05)
//        {
//            fontSize = savedFontSize;
//            oebFontScale = savedFontSize / kReaderScreenFontSizeDefaultValue;
//        }
//        else
//        {
//            fontSize = kReaderScreenFontSizeDefaultValue;
//            oebFontScale = kReaderScreenFontSizeScaleDefaultValue;
//        }
//        
//        self.fontName = [userDefaults objectForKey:@"readerfontname"];
//        
//        if (self.fontName == nil)
//        {
//            self.fontName = FontName_Default;
//        }
//        
//        self.font = [UIFont fontWithName:fontName size:fontSize];
//        
//        if (self.font == nil)
//        {
//            self.fontName = FontName_STHeitiTC_Light;
//            self.font = [UIFont fontWithName:fontName size:fontSize];
//        }
//        
//        if (self.font == nil)
//        {
//            self.font = [UIFont systemFontOfSize:fontSize];
//        }
//        
//        // alphaValue = 0.0;
//        if ([userDefaults objectForKey:@"readersrcreenParagraphSpacing"])
//        {
//            paragraphSpacing = [userDefaults floatForKey:@"readersrcreenParagraphSpacing"];
//            paragraphSpacing = MAX(paragraphSpacing, kReaderScreenParagraphspacingMinValue);
//            paragraphSpacing = MIN(paragraphSpacing, kReaderScreenParagraphspacingMaxValue);
//        }
//        else
//        {
//            paragraphSpacing = kReaderScreenParagraphspacingDefaultValue;
//        }
//        
//        
//        if ([userDefaults objectForKey:@"readersrcreenlinespacingvalue"])
//        {
//            lineSpacing = [userDefaults floatForKey:@"readersrcreenlinespacingvalue"];
//            lineSpacing = MAX(lineSpacing, kReaderScreenLinespacingMinValue);
//            lineSpacing = MIN(lineSpacing, kReaderScreenLinespacingMaxValue);
//        }
//        else
//        {
//            lineSpacing = kReaderScreenLinespacingDefaultValue;
//        }
        
        
        if ([userDefaults objectForKey:@"readersrcreenenvtype"])
        {
            enviromentType = [userDefaults integerForKey:@"readersrcreenenvtype"];
        }
        else
        {
            enviromentType= enviromentType_light;
        }
        
        turnPageMode = [userDefaults integerForKey:@"readerturnpagemode"];
        self.isBackground = FALSE;
        
        isTuchTurn = [userDefaults boolForKey:@"isTuchTurn"];
        
        self.backGrounColor = [self backgrounColorWithEnviromentType:enviromentType];
        
        if ([userDefaults objectForKey:@"readerisnoad"])
        {
            self.isNOAd = [userDefaults boolForKey:@"readerisnoad"];
        }
        
        if ([userDefaults objectForKey:@"oldEnviromentType"]) 
        {
            oldEnviromentType = [userDefaults integerForKey:@"oldEnviromentType"];
        }
        else
        {
            oldEnviromentType = enviromentType_light;
        }
        
#define kBookConfigVersionUpdata            @"bookConfigVersionUpdata1"
        if (![userDefaults objectForKey:kBookConfigVersionUpdata])
        {
            [BookSaveFile versionUpdata];
        }
        
        self.isNOAd = NO;
        //isFullMode = YES;
        
        [self initEnviromentArray];
    }
    
    return self;
}

- (id) dicWithEnviromentType:(enum enviromentType)type
{
    for (NSDictionary* dic in self.enviromentArray)
    {
        int eType = [[dic objectForKey:kEnviromentBackgoundType] intValue];
        if (eType == type)
        {
            return dic;
        }
    }
    
    return nil;
}
- (UIColor*) backgrounColorWithEnviromentType:(enum enviromentType)type
{
    for (NSDictionary* dic in self.enviromentArray)
    {
        int eType = [[dic objectForKey:kEnviromentBackgoundType] intValue];
        if (eType == type)
        {
            return [dic objectForKey:kEnviromentBackgoundColor];
        }
    }
    
    return nil;
}

- (enum enviromentType) enviromentTypeWithBackgrounColor:(UIColor*)backgrounColor_
{
    for (NSDictionary* dic in self.enviromentArray)
    {
        UIColor* color = [dic objectForKey:kEnviromentBackgoundColor];
        if (CGColorEqualToColor(backgrounColor_.CGColor, color.CGColor))
        {
            return [[dic objectForKey:kEnviromentBackgoundType] intValue];
        }
    }
    
    return 0;
}

- (void) saveBookConfig
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:alphaValue forKey:@"readersrcreenalphavalue"];
    [userDefaults setFloat:font.pointSize forKey:@"readersrcreenfontsizevalue"];
    [userDefaults setFloat:lineSpacing forKey:@"readersrcreenlinespacingvalue"];
    [userDefaults setInteger:enviromentType forKey:@"readersrcreenenvtype"];
    [userDefaults setInteger:turnPageMode forKey:@"readerturnpagemode"];
    [userDefaults setBool:isTuchTurn forKey:@"isTuchTurn"];
    [userDefaults setFloat:paragraphSpacing forKey:@"readersrcreenParagraphSpacing"];
    [userDefaults setObject:fontName forKey:@"readerfontname"];
    [userDefaults setObject:backGrounColor forKey:@"backGrounColor"];
    [userDefaults setBool:isNOAd forKey:@"readerisnoad"];
    [userDefaults setInteger:oldEnviromentType forKey:@"oldEnviromentType"];
    
    [userDefaults synchronize];  
}
- (void)dealloc
{
    [font release];
    [backGrounColor release];
    self.enviromentArray = nil;
    [super dealloc];
}

@end
