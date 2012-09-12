//
//  OEBMetaInfoReader.h
//  epubParse
//
//  Created by  on 11-10-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OEBSpine;
@class ZipArchive;

@interface OEBMetaInfoReader : NSObject

+ (NSString*)opfNameWithContainer:(NSData*)metaInfoData;
+ (OEBSpine*)createSpine:(NSData*)metaInfoData 
            withBasePath:(NSString *)basePath 
          withZipArchive:(ZipArchive *)zipArchive;
+ (NSMutableDictionary*)createMetaInfoDic:(NSData*)metaInfoData;
+ (void) ncxRead:(NSData*)ncxData With:(NSMutableArray*)spineArray;
@end
