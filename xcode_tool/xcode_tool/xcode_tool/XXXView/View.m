//
//  ReadView.m
//  TuShuoTianXia
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "View.h"

@interface View (private)

- (void) initPrivate;

@end

@implementation View

@synthesize curOrientation;

- (id) init
{
    if (self = [super init]) 
    {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}


- (void) initPrivate
{
    
}


#pragma mark -
#pragma mark - dealloc
#pragma mark -
- (void)dealloc
{
    
    [super dealloc];
}
@end
