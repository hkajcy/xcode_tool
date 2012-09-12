//
//  accessbilityManager.m
//  DocinBookReader
//
//  Created by  on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "accessbilityManager.h"

@implementation accessbilityManager

@synthesize accessArray;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void) addAccessWithAccessType:(enum accessType)accesstype
                withStartLoction:(id)startLocation 
                withStopLocation:(id)stopLocation 
                        withInfo:(id)info
{
    
}

- (void)dealloc
{
    self.accessArray = nil;
    [super dealloc];
}
@end
