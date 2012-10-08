//
//  ConfigSetting.h
//  
//
//  Created by HK on 12-9-13.
//  Copyright (c) 2012年 HK Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"


@interface ConfigSetting : NSObject
+ (ConfigSetting *)sharedInstance;

//declarw
/*********************************************************************************************/
//configFun_declare(returnType, valueName)
//returnType          返回值类型
//valueName           全局参数的名字
/*********************************************************************************************/

//ScreenWidth
/*********************************************************************************************/
configFun_declare(float,ScreenWidth)
/*********************************************************************************************/

@end
