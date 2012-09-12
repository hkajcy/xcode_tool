//
//  txtMetaInfoReader.m
//  docinBookReader
//
//  Created by  on 11-11-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtMetaInfoReader.h"
#import "book.h"
#import "Constants.h"

@implementation txtMetaInfoReader

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSMutableDictionary*)createMetaInfoDicWithFilePath:(NSString*)filePath;
{
    NSMutableDictionary* dic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    int startIndex = [filePath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\\/"] options:NSBackwardsSearch].location;
    
    if (startIndex == NSNotFound) 
    {
        startIndex = 0;
    }
    else
    {
        ++startIndex;
    }
    
    int stopIndex = [filePath rangeOfString:@"." options:NSBackwardsSearch].location;
    
    if (stopIndex == NSNotFound)
    {
        stopIndex = [filePath length];
    }
    
    [dic setObject:[filePath substringWithRange:NSMakeRange(startIndex, stopIndex - startIndex)] forKey:tittle_STR];
    return dic;
}
@end
