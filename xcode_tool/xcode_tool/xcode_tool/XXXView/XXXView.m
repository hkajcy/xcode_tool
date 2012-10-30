//
//  XXXView.m
//  huangke
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 huangke. All rights reserved.
//

#import "XXXView.h"

@interface XXXView ()

- (void) initPrivate;

@end

@implementation XXXView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initPrivate];
    }
    return self;
}


- (void) initPrivate
{
    
}

#pragma mark -
#pragma mark - setFrame
#pragma mark -
- (void) setFrameWithUIInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
}

#pragma mark -
#pragma mark - touch
#pragma mark -
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark -
#pragma mark - dealloc
#pragma mark -
- (void)dealloc
{
    
    [super dealloc];
}
@end
