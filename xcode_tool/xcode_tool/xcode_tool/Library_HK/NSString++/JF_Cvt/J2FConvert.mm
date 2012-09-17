//
//  J2FConvert.m
//  DocinBookReader
//
//  Created by 黄柯 on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include "jfConvert.h"

#import "J2FConvert.h"

static J2FConvert* instance = nil;

@implementation J2FConvert

CjfConvert* convert;

+ (J2FConvert*) sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[J2FConvert alloc] init];
        }
        return instance;
    }
}

- (id) init
{
    self = [super init];
    if (self)
    {
        const char* jjFileName = [[[NSBundle mainBundle] pathForResource:@"JJ" ofType:@"txt"] UTF8String];
        const char* jfFileName = [[[NSBundle mainBundle] pathForResource:@"JF" ofType:@"txt"] UTF8String];
        const char* fjFileName = [[[NSBundle mainBundle] pathForResource:@"FJ" ofType:@"txt"] UTF8String];
        const char* ffFileName = [[[NSBundle mainBundle] pathForResource:@"FF" ofType:@"txt"] UTF8String];
        
        convert = new CjfConvert;
        if (!convert->init(jjFileName, jfFileName, fjFileName, ffFileName))
        {
            delete convert;
            return nil;
        }
            
        
    }
    return self;
}

- (void) dealloc
{
    delete convert;
    [super dealloc];
}

- (NSString*) F2JConvert:(NSString*)convertStr
{
    NSUInteger GBEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSMutableString* retStr = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i < [convertStr length]; i++)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSString* subStr = [convertStr substringWithRange:NSMakeRange(i, 1)];
        NSData* subData = [subStr dataUsingEncoding:GBEncoding];
        memset(subBuffer, 0, 2);
        memcpy(subBuffer, [subData bytes], [subData length]);
        convert->F2J(subBuffer);
        NSString* newStr = [NSString stringWithCString:subBuffer encoding:GBEncoding];
        if (!newStr)
        {
            [pool release];
            return nil;
        }
        [retStr appendString:newStr];
        [pool release];
    }
    
    return retStr;
}

- (NSString*) J2FConvert:(NSString*)convertStr
{
    NSUInteger GBEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSMutableString* retStr = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i < [convertStr length]; i++)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSString* subStr = [convertStr substringWithRange:NSMakeRange(i, 1)];
        NSData* subData = [subStr dataUsingEncoding:GBEncoding];
        memset(subBuffer, 0, 2);
        memcpy(subBuffer, [subData bytes], [subData length]);
        convert->J2F(subBuffer);
        NSString* newStr = [NSString stringWithCString:subBuffer encoding:GBEncoding];
        [retStr appendString:newStr];
        [pool release];
    }
    
    return retStr;
}

- (NSString*) JFConvert:(NSString*)convertStr IsJ2F:(BOOL)isJ2F
{
    NSString* str;
    if (isJ2F)
    {
        str = [self J2FConvert:convertStr];
    }
    else
    {
        str = [self F2JConvert:convertStr];
    }
    
    return str;
}
@end
