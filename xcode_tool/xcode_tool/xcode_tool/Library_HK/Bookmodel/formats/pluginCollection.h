//
//  pluginCollection.h
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class formatPlugin;
@interface pluginCollection : NSObject
{
    NSMutableArray* formatPluginArray;
}

+ (pluginCollection*) sharedInstance;
+ (void) releaseInstance;

- (formatPlugin* ) plugin:(NSString*)filePath;

@end
