//
//  accessbilityManager.h
//  DocinBookReader
//
//  Created by  on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum accessType
{
    accessType_share = 0,
    accessType_digest = 1
};

@interface accessbilityManager : NSObject

@property (nonatomic, retain) NSMutableArray* accessArray;

- (void) addAccessWithAccessType:(enum accessType)accesstype
                withStartLoction:(id)startLocation 
                withStopLocation:(id)stopLocation 
                        withInfo:(id)info;
@end
