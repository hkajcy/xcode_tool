//
//  ZipArchive.mm
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//

#import "ZipArchive.h"
#import "zlib.h"
#import "zconf.h"
#import "macros_for_IOS_hk.h"

@interface  ZipArchive ()

@property (nonatomic,retain)NSString* password;
- (NSString *)parseFilePath:(NSString *)path;
- (NSString*) currentFileName;
@end



@implementation ZipArchive

@synthesize password = _password;

- (NSString *)parseFilePath:(NSString *)filePath {
    if (nil == filePath) {
        return nil;
    }
    NSMutableString *newPath = [NSMutableString stringWithString:filePath];
    
    //NSString *testPath = @"OEBPS/Text/../Images/00001.htm/1.jpg";
    //NSString *testPath = @"OEBPS/../Images/00001.htm/1.jpg";
    //NSString *testPath = @"OEBPS/Text/../../Images/00001.htm/1.jpg";
    //NSString *testPath = @"/OEBPS/Text/../../Images/00001.htm/1.jpg";
    //NSMutableString *newPath = [NSMutableString stringWithString:testPath];
    
    NSRange r = [newPath rangeOfString:@"/../"];
    while (r.length > 0) {
        NSRange r1 = [newPath rangeOfString:@"/" options:NSBackwardsSearch range:NSMakeRange(0, r.location)];
        if (r1.length > 0) {
            [newPath replaceCharactersInRange:NSMakeRange(r1.location + 1, (r.location + r.length - 1) - r1.location) withString:@""];
        } else {
            [newPath replaceCharactersInRange:NSMakeRange(0, r.location + r.length) withString:@""];
        }
        r = [newPath rangeOfString:@"/../"];
    }
    return newPath;
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile
{
	_unzFile = unzOpen( (const char*)[zipFile UTF8String] );
	return _unzFile!=NULL;
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password
{
	_password = password;
	return [self UnzipOpenFile:zipFile];
}

- (id) initWithPath:(NSString *)path
{
    return [self initWithPath:path andPassWord:nil];
}

- (id) initWithPath:(NSString *)path andPassWord:(NSString *)password
{
    if(self=[super init])
	{
        if (password)
        {
            if (![self UnzipOpenFile:path]) 
            {
                self = nil;
            }
        }
        else
        {
            if (![self UnzipOpenFile:path Password:password])
            {
                self = nil;
            }
        }
	}
	return self;
}

- (void) OutputErrorMessage:(NSString*)errorStr
{
    NSLog(@"%@",errorStr);
}

- (NSData*) readFileBiggest
{
    NSArray* pathArray = [self pathArrayWithExternName:nil];
    
    NSData* biggestData = nil;
    
    for (NSString* str in pathArray) 
    {
        NSData* tData = [self readFileWithFileName:str];
        
        if (biggestData == nil) {
            biggestData = tData;
        }
        
        if ([biggestData length] < [tData length]) 
        {
            biggestData = tData;
        }
    }
    
    if ([pathArray count])
    {
        @try {
            NSAssert([biggestData length], @"");
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    return biggestData;
}

- (NSData*) readFileWithPath:(NSString*)pathStr
{
    @synchronized (self) {
        pathStr = [self parseFilePath:pathStr];
        int ret = 0;
        NSMutableData* retData = [[[NSMutableData alloc] initWithLength:0] autorelease];
        const char * szfilename = [pathStr UTF8String];
        ret = unzLocateFile(_unzFile, szfilename, 0);
        
        if (ret != UNZ_OK)
        {
            return retData;
        }
        
        if( [_password length]==0 )
            ret = unzOpenCurrentFile( _unzFile );
        else
            ret = unzOpenCurrentFilePassword( _unzFile, [_password cStringUsingEncoding:NSASCIIStringEncoding] );
        
        if( ret != UNZ_OK )
        {
            [self OutputErrorMessage:@"Error occurs while getting file info"];
            unzCloseCurrentFile( _unzFile );
            return retData;
        }
        
        unsigned char		buffer[4096] = {0};
        
        NSAssert(buffer != nil, @"");
        int read = -1;
        while (read != 0)
        {
            read = unzReadCurrentFile(_unzFile, buffer, 4096);
            
            [retData appendBytes:buffer length:read];
        }
        
        unzCloseCurrentFile( _unzFile );
        
        return retData;
    }
}

- (NSData*) readFileWithFileName:(NSString *)FileName
{
    unzGoToFirstFile( _unzFile );
    NSString* filePath ;
    
    while (filePath != nil)
    {
        filePath = [self currentFileName];
        
        NSString* name = [filePath lastPathComponent]; // 取得改文件的文件名，包括扩展名

        //说明找到了这个文件
        if ([name isEqualToString:FileName])
        {
            NSData* retData = [self readFileWithPath:filePath];
            return retData;
        }
        
        if (UNZ_END_OF_LIST_OF_FILE == unzGoToNextFile(_unzFile))
            break;
    }
    return nil;
}

#pragma mark -
#pragma mark currentFileName
- (NSString*) currentFileName
{
	int ret ;
    
    if( [_password length]==0 )
        ret = unzOpenCurrentFile( _unzFile );
    else
        ret = unzOpenCurrentFilePassword( _unzFile, [_password cStringUsingEncoding:NSASCIIStringEncoding] );
    if( ret!=UNZ_OK )
    {
        [self OutputErrorMessage:@"Error occurs"];
        return nil;
    }
    
    // reading data and write to file
    unz_file_info	fileInfo ={0};
    ret = unzGetCurrentFileInfo(_unzFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
    if( ret!=UNZ_OK )
    {
        [self OutputErrorMessage:@"Error occurs while getting file info"];
        unzCloseCurrentFile( _unzFile );
        return nil;
    }
    
    char* filename = (char*) malloc( fileInfo.size_filename +1 );
    unzGetCurrentFileInfo(_unzFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
    filename[fileInfo.size_filename] = '\0';
    
    // check if it contains directory
    NSString * strPath = [NSString  stringWithCString:filename encoding:NSASCIIStringEncoding];
    
//    BOOL isDirectory = NO;
//    if( filename[fileInfo.size_filename-1]=='/' || filename[fileInfo.size_filename-1]=='\\')
//        isDirectory = YES;
    free( filename );
//    
//    if( [strPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location!=NSNotFound )
//    {// contains a path
//        strPath = [strPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
//    }
    
    unzCloseCurrentFile( _unzFile );
	return strPath;
}

- (NSArray*) pathArrayWithExternName:(NSString*)externName
{
    NSMutableArray* pathArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    unzGoToFirstFile( _unzFile );
    NSString* str = @"";
    
    while (str != nil)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        str = [self currentFileName];
        
        if ([externName length])
        {
            if (str && [[str pathExtension] isEqualToString:externName])
            {
                [pathArray addObject:str];
            }
        }
        else
        {
            [pathArray addObject:str];
        }
        [pool release];

        if (UNZ_END_OF_LIST_OF_FILE == unzGoToNextFile(_unzFile))
            break;
    }
    
    return pathArray;
}

-(BOOL) UnzipCloseFile
{
	if( _unzFile )
		return unzClose( _unzFile )==UNZ_OK;
	return YES;
}

-(void) dealloc
{
    [self UnzipCloseFile];
    [_password release];
    
	[super dealloc];
}
@end


