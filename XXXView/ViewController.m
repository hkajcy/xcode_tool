//
//  ViewController.m
//  let's dance
//
//  Created by  on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "constants.h"

@interface ViewController (private)

- (void) initPrivate;

@end

@implementation ViewController

@synthesize curOrientation;

- (id) init
{
    if (self = [super init])
    {
        self.curOrientation = self.interfaceOrientation;
    }
    
    return self;
}


- (void) initPrivate
{
    
}

#pragma mark-
#pragma mark-  Managing the View
#pragma mark-

- (void) setFramWithUIInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
}

- (void) loadView
{
    [super loadView];
    
    [self setFramWithUIInterfaceOrientation:self.curOrientation];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void) viewWillUnload
{
    [super viewWillUnload];
    
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

#pragma mark-
#pragma mark-  Handling Memory Warnings
#pragma mark-

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark-
#pragma mark-  Responding to View Events
#pragma mark-

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.curOrientation != self.interfaceOrientation)
    {
        self.curOrientation = self.interfaceOrientation;
        [self setFramWithUIInterfaceOrientation:self.curOrientation];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark-
#pragma mark-  Responding to View Rotation Events
#pragma mark-

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.curOrientation = toInterfaceOrientation;
    [self setFramWithUIInterfaceOrientation:self.curOrientation];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark - dealloc
- (void)dealloc
{
    [super dealloc];
}
@end
