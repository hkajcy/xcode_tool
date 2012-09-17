//
//  J2FConvert.h
//  DocinBookReader
//
//  Created by 黄柯 on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define J2FConvertInstance  [J2FConvert sharedInstance]

@interface J2FConvert : NSObject
{    
    char        subBuffer[2];
}
- (id) init;
- (NSString*) JFConvert:(NSString*)convertStr IsJ2F:(BOOL)isJ2F;
+ (J2FConvert*) sharedInstance;
@end
