//
//  Config.h
//  
//
//  Created by  on 12-9-14.
//  Copyright (c) 2012年  Ltd. All rights reserved.
//

//global
/*********************************************************************************************/
#define configInstance                                      [ConfigSetting sharedInstance]

#define configFun(value)                                    value##Fun
#define configInstanceFun(value)                            [configInstance value##Fun]

#define configFun_declare(returnType,valueName)\
- (returnType) configFun(k##valueName##_For_iPhone_Portrait);\
- (returnType) configFun(k##valueName##_For_iPhone_Landscape);\
- (returnType) configFun(k##valueName##_For_iPad_Portrait);\
- (returnType) configFun(k##valueName##_For_iPad_Landscape);\

#ifndef kPortraitValue
#define kPortraitValue(value)                               isiPad(k##value##_For_iPad_Portrait ,k##value##_For_iPhone_Portrait)
#endif

#ifndef kLandscapeValue
#define kLandscapeValue(value)                              isiPad(k##value##_For_iPad_Landscape,k##value##_For_iPhone_Landscape)
#endif
/*********************************************************************************************/


#ifndef ScreenWidth
#define ScreenWidth                                           ScreenWidth
#define kScreenWidth_For_iPhone_Portrait                      configInstanceFun(kScreenWidth_For_iPhone_Portrait)
#define kScreenWidth_For_iPhone_Landscape                     configInstanceFun(kScreenWidth_For_iPhone_Landscape)

#define kScreenWidth_For_iPad_Portrait                        configInstanceFun(kScreenWidth_For_iPad_Portrait)
#define kScreenWidth_For_iPad_Landscape                       configInstanceFun(kScreenWidth_For_iPad_Landscape)

#define kCurScreenWidth(orientation)                          (UIInterfaceOrientationIsPortrait(orientation) ? \
kPortraitValue(ScreenWidth) : \
kLandscapeValue(ScreenWidth))
#endif
