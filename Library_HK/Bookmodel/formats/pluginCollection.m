//
//  pluginCollection.m
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "pluginCollection.h"
#import "OEBPlugin.h"
#import "TxtPlugin.h"
#import "pdfPlugin.h"
#import "macros_for_IOS_hk.h"
static pluginCollection* instance = nil;

@implementation pluginCollection

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        formatPluginArray = [[NSMutableArray alloc] init];
        
        OEBPlugin* OEBPlugint = [[[OEBPlugin alloc] init] autorelease];
        [formatPluginArray addObject:OEBPlugint];
        
        TxtPlugin* txtPlugint = [[[TxtPlugin alloc] init] autorelease];
        [formatPluginArray addObject:txtPlugint];
        
        pdfPlugin* pdfPlugint = [[[pdfPlugin alloc] init] autorelease];
        [formatPluginArray addObject:pdfPlugint];
    }
    
    return self;
}

+ (pluginCollection*) sharedInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[pluginCollection alloc] init];
        }
        return instance;
    }
}

+ (void) releaseInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            [instance release];
        }
    } 
}

- (formatPlugin* ) plugin:(NSString*)filePath
{
    for (formatPlugin* formatPlugint in formatPluginArray) 
    {
        if ([formatPlugint acceptsFile:filePath])
        {
            return formatPlugint;
        }
    }
    
    return nil;
}

- (void)dealloc
{
    SAFE_RELEASE(formatPluginArray);
    [super dealloc];
}
@end
