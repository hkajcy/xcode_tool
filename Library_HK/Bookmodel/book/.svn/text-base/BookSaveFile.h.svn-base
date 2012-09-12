//
//  BookSaveFile.h
//  DocinBookReader
//
//  Created by Yongming Li on 28/9/11.
//  Copyright 2011 Docin Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookSaveFile : NSObject
{
    
}
+ (void) deleteBookInfomation:(NSUInteger) bookid;

+ (void) writeChapterArray:(NSMutableArray *) chapterArray WithBookId:(NSUInteger) bookid;
+ (NSMutableArray *) readChapterArray:(NSUInteger) bookid;
+ (void) deleteChapterArrayWithBookID:(NSUInteger) bookid;

+ (void) writeSpineArray:(NSMutableArray *)spineArray WithBookId:(NSUInteger) bookid;
+ (NSMutableArray *) readSpineArray:(NSUInteger) bookid;
+ (void) deleteSpineArrayWithBookID:(NSUInteger) bookid;


+ (void) writePageStartLocFromIndex:(NSMutableDictionary*)pageStartLocFromIndexDic 
                         WithBookId:(NSUInteger)bookid
                       withFileName:(NSString*)withFileName
                       withDrawFont:(UIFont*)drawFont
                    withLineSpacing:(int)lineSpace
               withParagraphSpacing:(int)paragraphSpaceing
                       withDrawSize:(CGSize)drawSize;

+ (NSMutableDictionary*)readPageStartLocFromIndexWithBookId:(NSUInteger)bookid
                                                    withFileName:(NSString*)withFileNam
                                               withDrawFont:(UIFont*)drawFont
                                            withLineSpacing:(int)lineSpace
                                       withParagraphSpacing:(int)paragraphSpaceing
                                               withDrawSize:(CGSize)drawSize;
+ (void) deletStartLocFromIndexWithBookId:(NSUInteger)bookid;

+ (void) versionUpdata;
@end
