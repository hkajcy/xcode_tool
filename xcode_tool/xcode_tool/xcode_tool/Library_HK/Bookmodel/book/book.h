//
//  tBook.h
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookModel.h"
#import "FormatPlugin.h"

#define filePath_STR                                (@"dc:filePath")
#define tittle_STR                                  (@"dc:title")
#define language_STR                                (@"dc:language")
#define encoding_STR                                (@"dc:encoding")
#define creator_STR                                 (@"dc:creator")
#define publisher_STR                               (@"dc:publisher")
#define description_STR                             (@"dc:description")
#define coverage_STR                                (@"dc:coverage")
#define source_STR                                  (@"dc:source")
#define date_STR                                    (@"dc:date")
#define rights_STR                                  (@"dc:rights")
#define subject_STR                                 (@"dc:subject")
#define contributor_STR                             (@"dc:contributor")
#define type_STR                                    (@"dc:type")
#define format_STR                                  (@"dc:format")
#define relation_STR                                (@"dc:relation")
#define builder_STR                                 (@"dc:builder")
#define builder_version_STR                         (@"dc:builder_version")
#define coverImageHref_STR                          (@"coverImageHref")
#define coverImage_STR                              (@"coverImage")

@class formatSpine;
@class bookModel;
@class formatLocation;
@interface book : NSObject
{
    NSMutableDictionary*    _metaInfoDic;
    formatSpine*            _FormatSpine;
    id<BookModelProtocol>   _bookModel;
    NSString*               _filePath;
    int                     _bookID;
    formatLocation*         _startLocation;
    id<BookMarkDBProtocol>                      _bookWareHouse;
}

@property (nonatomic,assign) id                      bookWareHouse;
@property (nonatomic,assign) int                     bookID;
@property (nonatomic,retain) id<BookModelProtocol>   myBookModel;   
@property (nonatomic,retain) NSMutableDictionary*    myMetaInfoDic;
@property (nonatomic,retain) formatSpine*            mySpine;
@property (nonatomic,retain) formatLocation*         mystartLocation;

+ (UIImage*) coverImageOfBookPath:(NSString*) bookName;

+ (book*) BookWithFilePath:(NSString *)filePath 
                    bookID:(int)bookid 
             StartLocation:(id)formatLocationt;


- (NSString*) filePath;
- (NSString*) bookTittle;
- (NSMutableArray*) bookSpineArray;
- (UIImage*) coverImage;
@end
