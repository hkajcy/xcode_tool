//
//  PDFLocation.h
//  DocinBookReader
//
//  Created by mac-L on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "formatLocation.h"
@interface PDFLocation : formatLocation
<formatLocationProtocol,NSCoding>
{
    int pageIndex;
}

@property (nonatomic,assign) int pageIndex;

+ (PDFLocation*) pdfLocationWithIndex:(int)index;

@end
