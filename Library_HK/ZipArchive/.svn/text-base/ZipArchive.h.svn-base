//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//
// History: 
//    09-11-2008 version 1.0    release
//    10-18-2009 version 1.1    support password protected zip files
//    10-21-2009 version 1.2    fix date bug

#import <Foundation/Foundation.h>

#include "minizip/unzip.h"

@interface ZipArchive : NSObject {
@private
	unzFile		_unzFile;
	
	NSString*   _password;
}

- (id) initWithPath:(NSString *)path;
- (id) initWithPath:(NSString *)path andPassWord:(NSString *)password;

//if return nil; 
//it means that there is no file named pathStr;
- (NSData*) readFileBiggest;
- (NSData*) readFileWithPath:(NSString*)pathStr;
- (NSData*) readFileWithFileName:(NSString *)FileName;
- (NSArray*) pathArrayWithExternName:(NSString*)externName;
@end
