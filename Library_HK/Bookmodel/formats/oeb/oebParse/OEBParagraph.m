//
//  OEBParagraph.m
//  OEBReader
//
//  Created by heyong on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBParagraph.h"
#import "OEBConstant.h"
#pragma mark - Paragraph
@implementation OEBParagraph

@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBParagraphTypeText;
    }
    
    return self;
}

@end

#pragma mark - TextParagraph
@implementation OEBTextParagraph

@synthesize textStyle;
@synthesize content;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBParagraphTypeText;
        content = @"";
        textStyle = [[OEBCSSStyle alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [textStyle release];
    [content release];
    [super dealloc];
}

@end

#pragma mark - ImageParagraph
@implementation OEBImageParagraph

@synthesize imagePath;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBParagraphTypeImage;
    }
    
    return self;
}

- (void)dealloc {
    [imagePath release];
    [super dealloc];
}

@end

#pragma mark - ControlParagraph
@implementation OEBControlParagraph

@synthesize style;
@synthesize controlType;
@synthesize isStart;
@synthesize controlName;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBParagraphTypeControl;
        isStart = NO;
        style = [[OEBCSSStyle alloc] init];
    }
    
    return self;
}

- (BOOL) lineBreaker
{
    NSArray* noLineBreaker = [NSArray arrayWithObjects:kHTMLTag_A,kHTMLTag_Span,kHTMLTag_B,kHTMLTag_Strong, nil];
    for (id ob in noLineBreaker) 
    {
        if ([controlName isEqualToString:ob ])
        {
            return NO;
        }
    }
    
    return YES;
}
- (void)dealloc {
    [style release];
    [controlName release];
    [super dealloc];
}

@end

#pragma mark - HyperlinkParagraph
@implementation OEBHyperlinkParagraph

@synthesize href;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBParagraphTypeHyperlink;
    }
    
    return self;
}

- (void)dealloc {
    [href release];
    [super dealloc];
}

@end
