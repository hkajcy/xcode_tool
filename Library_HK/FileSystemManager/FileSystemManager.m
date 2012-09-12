//
//  FileSystemMgr.m
//  DocInStudy
//
//  Created by juan howard on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FileSystemManager.h"

@implementation FileSystemMgr

+ (BOOL)createDir:(NSString*)newDir
{
    NSError * error = nil; 
    BOOL bOK = [[NSFileManager defaultManager] createDirectoryAtPath:newDir  
                                         withIntermediateDirectories:YES  
                                                          attributes:nil  
                                                               error:&error];
    return bOK;
}

+ (BOOL)deleteFilesysItemAtPath:(NSString*)path
{
    NSError * error = nil; 
    
    BOOL bOK = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    return bOK;
}

+ (BOOL)moveFilesysItem:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSError * error = nil; 
    BOOL bOK = [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath  error:&error];
    return bOK;
    
}

+ (BOOL) isFileExistAtPath:(NSString *)strPath
{
    //debugLog(@"%@", strPath);
    NSFileManager *file_manager = [NSFileManager defaultManager];
    BOOL bOK = [file_manager fileExistsAtPath:strPath];
    return bOK;
}

+ (NSString*) docPath
{
    // such as : a/b/c
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    
    return documentPath;
}

+ (NSString *) cachePath
{   
    // such as : a/b/c
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    return cachePath;
}



@end
