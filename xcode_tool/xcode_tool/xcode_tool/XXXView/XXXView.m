//
//  ReadView.m
//  TuShuoTianXia
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XXXView.h"

@interface XXXView (private)

- (void) initPrivate;

@end

@implementation XXXView

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
