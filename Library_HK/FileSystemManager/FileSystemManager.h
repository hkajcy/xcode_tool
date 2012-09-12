//
//  FileSystemMgr.h
//  DocInStudy
//
//  Created by juan howard on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileSystemMgr : NSObject {
    
}

+ (BOOL)createDir:(NSString*)newDir;
+ (BOOL)deleteFilesysItemAtPath:(NSString*)path;
+ (BOOL)moveFilesysItem:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL) isFileExistAtPath:(NSString*)strPath;


+ (NSString*) docPath;
+ (NSString*) cachePath;

@end
