//
//  OEBSpine.m
//  moonBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBSpine.h"
#import "OEBLocation.h"
#import "Constants.h"
@implementation OEBSpine

@synthesize hrefDic;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (formatLocation*) firstChapter
{
    if ([self.spineArray count] == 0)
    {
        [NSException raise:NSObjectNotAvailableException format:@"there is no chapter info"];
    }
    
    NSDictionary* dic = [self.spineArray objectAtIndex:0];
    return [dic objectForKey:SpineLocation_STR];
}

- (formatLocation*) lastChapter
{
    NSDictionary* dic = [self.spineArray lastObject];
    return [dic objectForKey:SpineLocation_STR];
}

- (formatLocation*) previousChapter:(OEBLocation*)currentChapter
{
    NSDictionary* dic ;
    int index = -1;
    for (dic in self.spineArray)
    {
        OEBLocation* loc = [dic objectForKey:SpineLocation_STR];
        
        if ([loc.href isEqualToString:currentChapter.href])
        {
            index = [self.spineArray indexOfObject:dic];
            break;
        }
    }
    
    NSAssert(index != -1,@"");
    
    if (index != 0)
    {
        dic = [self.spineArray objectAtIndex:index - 1];
        return [dic objectForKey:SpineLocation_STR];
    }
    else
    {
        return nil;
    }
}

- (id) nextChapter:(OEBLocation*)currentChapter
{
    assert(currentChapter);
    NSDictionary* dic;
    int index = -1;
    for (dic in self.spineArray)
    {
        OEBLocation* loc = [dic objectForKey:SpineLocation_STR];
        
        if ([loc.href isEqualToString:currentChapter.href])
        {
            index = [self.spineArray indexOfObject:dic];
            break;
        }
    }
    
    assert(index != -1);
    
    if (index != [self.spineArray count] - 1)
    {
        dic = [self.spineArray objectAtIndex:index + 1];
        return [dic objectForKey:SpineLocation_STR];
    }
    else
    {
        return nil;
    }
    
}

- (void) gotoChapter:(formatLocation*)gotoChapter
{
    assert(0);
}

- (void) arrangeSpine
{
    SAFE_RELEASE(hrefDic)
    
    hrefDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    int locIndex = 0;
    for (NSDictionary* dic in self.spineArray) 
    {
        OEBLocation* location = [dic objectForKey:SpineLocation_STR];
        [hrefDic setValue:[NSNumber numberWithInt:locIndex] forKey:location.href];
        locIndex++;
    }
}
- (void)dealloc
{
    SAFE_RELEASE(hrefDic);
    [super dealloc];
}
@end
