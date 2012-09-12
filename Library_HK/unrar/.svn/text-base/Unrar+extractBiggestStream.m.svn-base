//
//  NSObject+Unrar_extractBiggestStream.m
//  DocinBookReader
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Unrar+extractBiggestStream.h"

@implementation Unrar4iOS (Unrar_extractBiggestStream)

- (NSData*) extractBiggestStream {
    NSArray* array = [self unrarListFiles];
    NSData* biggestData = nil;
    
    for (NSString* str in array) 
    {
        NSData* tData = [self extractStream:str];
        
        if (biggestData == nil) {
            biggestData = tData;
        }
        
        if ([biggestData length] < [tData length]) {
            biggestData = tData;
        }
    }
    
    return biggestData;
}

@end
