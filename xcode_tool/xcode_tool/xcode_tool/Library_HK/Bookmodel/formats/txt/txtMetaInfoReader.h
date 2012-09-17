//
//  txtMetaInfoReader.h
//  docinBookReader
//
//  Created by  on 11-11-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface txtMetaInfoReader : NSObject

+ (NSMutableDictionary*)createMetaInfoDicWithFilePath:(NSString*)filePath;

@end
