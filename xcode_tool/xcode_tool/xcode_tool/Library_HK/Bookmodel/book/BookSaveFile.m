//
//  BookSaveFile.m
//  DocinBookReader
//
//  Created by Yongming Li on 28/9/11.
//  Copyright 2011 Docin Ltd. All rights reserved.
//

#import "BookSaveFile.h"
#import "FileSystemManager.h"
@implementation BookSaveFile

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (void) deleteBookInfomation:(NSUInteger) bookid
{
    [BookSaveFile deleteChapterArrayWithBookID:bookid];
    [BookSaveFile deleteSpineArrayWithBookID:bookid];
    [BookSaveFile deletStartLocFromIndexWithBookId:bookid];
}

+ (NSString*) spinePathWithBookID:(int)bookID
{
    NSString *path = [NSString stringWithFormat:@"%@/txtData/%d/", [FileSystemMgr cachePath],bookID];
    
    if (![FileSystemMgr isFileExistAtPath:path])
    {
        [FileSystemMgr createDir:path];
    }
    return [path stringByAppendingString:@"spineData.data"];
}

+ (NSString*) chapterPathWithBookID:(int)bookID
{
    NSString *path = [NSString stringWithFormat:@"%@/txtData/%d/", [FileSystemMgr cachePath],bookID];
    if (![FileSystemMgr isFileExistAtPath:path])
    {
        [FileSystemMgr createDir:path];
    }
    return [path stringByAppendingString:@"chatperData.data"];
}

+ (void)writeSpineArray:(NSMutableArray *)spineArray WithBookId:(NSUInteger)bookid
{
	[NSKeyedArchiver archiveRootObject:spineArray toFile:[self spinePathWithBookID:bookid]];	
    NSAssert([FileSystemMgr isFileExistAtPath:[self spinePathWithBookID:bookid]],@"");
}

+ (void)writeChapterArray:(NSMutableArray *)chapterArray WithBookId:(NSUInteger)bookid
{
	[NSKeyedArchiver archiveRootObject:chapterArray toFile:[self chapterPathWithBookID:bookid]];	
    NSAssert([FileSystemMgr isFileExistAtPath:[self chapterPathWithBookID:bookid]],@"");
}

+ (void) deleteChapterArrayWithBookID:(NSUInteger)bookid
{
    //删除本书的章节
    NSString *chapterpath = [self chapterPathWithBookID:bookid];
    if ([FileSystemMgr isFileExistAtPath:chapterpath]) 
    {
        [FileSystemMgr deleteFilesysItemAtPath:chapterpath];
    }
}
+ (NSMutableArray *)readChapterArray:(NSUInteger)bookid
{
    NSMutableArray *chapterArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self chapterPathWithBookID:bookid]];    
    return chapterArray;
}

+ (NSMutableArray *) readSpineArray:(NSUInteger) bookid
{
    return nil;
    NSMutableArray *spineArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self spinePathWithBookID:bookid]];    
    return spineArray;
}
+ (void) deleteSpineArrayWithBookID:(NSUInteger)bookid
{
    //删除本书的脊骨
    NSString *spinepath = [self spinePathWithBookID:bookid];
    if ([FileSystemMgr isFileExistAtPath:spinepath])
    {
        [FileSystemMgr deleteFilesysItemAtPath:spinepath];
    }
}

+ (NSString*) pathBagWithBookID:(NSUInteger)bookid
{
    
    NSString* filePath = [NSString stringWithFormat:@"%@/pageStartLocFromIndex/%d/",[FileSystemMgr cachePath],bookid];
    [FileSystemMgr createDir:filePath];
    return filePath;
}

+ (NSString*) pageStartLocFromIndexPathWithBookId:(NSUInteger)bookid
                                     withFileName:(NSString*)withFileName
                                     withDrawFont:(UIFont*)drawFont
                                  withLineSpacing:(int)lineSpace
                             withParagraphSpacing:(int)paragraphSpaceing
                                     withDrawSize:(CGSize)drawSize;
{
    NSString* filePath = [self pathBagWithBookID:bookid];
    
    withFileName = [withFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    withFileName = [withFileName stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
    
    NSString* fileName = [NSString stringWithFormat:@"%@_%i_%d_%d_%d_%d",drawFont.fontName,(int)drawFont.pointSize,lineSpace,paragraphSpaceing,(int)drawSize.width,(int)drawSize.height];
    fileName = [fileName stringByAppendingFormat:@"_%@",withFileName];
    
    filePath = [filePath stringByAppendingString:fileName];
    
    return filePath;
}
+ (void) writePageStartLocFromIndex:(NSMutableDictionary*)pageStartLocFromIndexDic 
                         WithBookId:(NSUInteger)bookid
                       withFileName:(NSString*)withFileName
                       withDrawFont:(UIFont*)drawFont
                    withLineSpacing:(int)lineSpace
               withParagraphSpacing:(int)paragraphSpaceing
                       withDrawSize:(CGSize)drawSize
{
    NSString* path = [self pageStartLocFromIndexPathWithBookId:bookid
                                                  withFileName:withFileName
                                                  withDrawFont:drawFont
                                               withLineSpacing:lineSpace
                                          withParagraphSpacing:paragraphSpaceing
                                                  withDrawSize:drawSize];
	[NSKeyedArchiver archiveRootObject:pageStartLocFromIndexDic toFile:path];	
    NSAssert([FileSystemMgr isFileExistAtPath:path],@"");
}

+ (NSMutableDictionary*)readPageStartLocFromIndexWithBookId:(NSUInteger)bookid
                                               withFileName:(NSString*)withFileName
                                               withDrawFont:(UIFont*)drawFont
                                            withLineSpacing:(int)lineSpace
                                       withParagraphSpacing:(int)paragraphSpaceing
                                               withDrawSize:(CGSize)drawSize
{
    NSString* path = [self pageStartLocFromIndexPathWithBookId:bookid
                                                  withFileName:withFileName
                                                  withDrawFont:drawFont
                                               withLineSpacing:lineSpace
                                          withParagraphSpacing:paragraphSpaceing
                                                  withDrawSize:drawSize];
    NSMutableDictionary *value = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return value;
}

+ (void) deletStartLocFromIndexWithBookId:(NSUInteger)bookid
{
    NSString* filePath = [self pathBagWithBookID:bookid];
    [FileSystemMgr deleteFilesysItemAtPath:filePath];
}

+ (void) versionUpdata
{
    
    NSError *err = nil;
    NSArray *filearray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[FileSystemMgr cachePath] error:&err];
    
    for (NSString* filename in filearray)
    {
        int bookid = 0;
        
        if ([filename rangeOfString:@"_"].location != NSNotFound) 
        {
            bookid = [[filename substringToIndex:[filename rangeOfString:@"_"].location] intValue]; 
        }
        
        if ([filename rangeOfString:@"chapterArray"].location != NSNotFound)
        {
            [[NSFileManager defaultManager] moveItemAtPath:[[FileSystemMgr cachePath] stringByAppendingFormat:@"/%@",filename] 
                                                    toPath:[self chapterPathWithBookID:bookid] 
                                                     error:&err];
        }
        
        if ([filename rangeOfString:@"spineArray"].location != NSNotFound)
        {
            [[NSFileManager defaultManager] moveItemAtPath:[[FileSystemMgr cachePath] stringByAppendingFormat:@"/%@",filename] 
                                                    toPath:[self spinePathWithBookID:bookid] 
                                                     error:&err];
        }
    }
}
@end
