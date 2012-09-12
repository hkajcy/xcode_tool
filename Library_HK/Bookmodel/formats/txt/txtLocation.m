//
//  txtLocation.m
//  docinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtLocation.h"

@implementation txtLocation

@synthesize charactorIndex;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

+ (txtLocation*) txtLocationWithIndex:(int)index
{
    txtLocation* txtLocationt = [[[txtLocation alloc] init] autorelease];
    txtLocationt.charactorIndex = index;
    
    return txtLocationt;
}

- (void)encodeWithCoder:(NSCoder *)aCoder 
{  
    [aCoder encodeInt:charactorIndex forKey:@"charactorIndex"];
}  

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {  
        
        charactorIndex = [aDecoder decodeIntForKey:@"charactorIndex"];
    }  
    
    return self;  
}

- (BOOL) isEqualChapter:(id)object
{
    return YES;
}

- (BOOL) isEqualLocation:(txtLocation*)object
{
    return self.charactorIndex == object.charactorIndex;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"%d",charactorIndex];
}
@end
