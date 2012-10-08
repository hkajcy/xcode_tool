//
//  ReadView.m
//  TuShuoTianXia
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KKView.h"

@interface KKView (private)

- (void) initPrivate;

@end

@implementation KKView

@synthesize curOrientation;

- (id) init
{
    if (self = [super init]) 
    {
        self.backgroundColor = [UIColor clearColor];
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


-(UIBezierPath*)set_path
{
    #define ORC_RADIUS 12
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    CGSize size = self.bounds.size;
    double h = size.height - ORC_RADIUS*3;
    double bw = (size.width - ORC_RADIUS*3)/2;
    
    CGPoint p = CGPointMake(ORC_RADIUS, 0);
    [path moveToPoint:p];
    p.x += size.width - ORC_RADIUS*2;
    [path addLineToPoint: p];
    
    p.y += ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:3.1414926*1.5
                  endAngle:0
                 clockwise:YES];
    
    p.x += ORC_RADIUS;
    p.y += h;
    [path addLineToPoint: p];
    
    p.x -= ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:0
                  endAngle:3.1415926/2.0
                 clockwise:YES];
    p.y += ORC_RADIUS;
    p.x -= bw;
    [path addLineToPoint: p];
    
    p.x -= ORC_RADIUS/2;
    p.y += ORC_RADIUS;
    [path addLineToPoint: p];
    p.x -= ORC_RADIUS/2;
    p.y -= ORC_RADIUS;
    [path addLineToPoint: p];
    p.x -= bw;
    [path addLineToPoint: p];
    p.y -= ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:3.1415926/2.0
                  endAngle:3.1415926
                 clockwise:YES];
    p.x -= ORC_RADIUS;
    p.y -= h;
    [path addLineToPoint: p];
    p.x += ORC_RADIUS;
    [path addArcWithCenter:p
                    radius:ORC_RADIUS
                startAngle:3.1415926
                  endAngle:3.1415926*1.5
                 clockwise:YES];
    [path closePath];
    
    return path;
}

- (void) drawRect:(CGRect)rect
{
    [[UIColor grayColor] setFill];
    [[self set_path] fill];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
