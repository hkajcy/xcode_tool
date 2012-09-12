//
//  OEBDrawer.h
//  moonBookReader
//
//  Created by  on 11-11-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZipArchive;
@class OEBLocation;
@interface OEBDrawer : NSObject

+ (void) drawPage:(NSArray*)rows 
        isPlaying:(BOOL)isPlaying 
          withZip:(ZipArchive*)zipArchive
withStartPlayingLocation:(OEBLocation*)startLocation
withStopPlayingLocation:(OEBLocation*)stopLocation
      WithContext:(CGContextRef)context;

@end
