//
//  OEBBookModel.h
//  moonBookReader
//
//  Created by heyong on 11-11-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookModel.h"

@class ZipArchive;
@class OEBTextModel;
@class OEBLocation;
@class OEBSpine;
@class accessibilityElement;
@interface OEBBookModel : bookModel <BookModelProtocol> 
{
    OEBSpine*     _mySpine;
    
    NSString* bookTitle;
    NSString* fatherPath;
    
    CGRect          renderRect;
    ZipArchive *zipArchive;
    
    
    NSMutableDictionary*        textModelDic;
    NSMutableDictionary*        textModelIndexDic;
    int                         startPageIndex;

    OEBLocation*                startPlayingLocation;
    OEBLocation*                stopPlayingLocation;
}

@property (nonatomic, copy) NSString* bookTitle;

@property (nonatomic, assign) int tottlePageCount;


@property (nonatomic, retain) OEBSpine*     mySpine;
@property (nonatomic, retain) NSMutableDictionary* pageCountStartFromPageHref;
@property (nonatomic, retain) NSMutableArray* startPageIndexArray;

- (id)initWithZipArchive:(ZipArchive *)zipFile
         WithOEBLocation:(OEBLocation*)location
            WithOEBSpine:(OEBSpine*)oebSpine
          withFatherPath:(NSString*)fatherPatht
              withBookID:(int)bookid;

- (void) parseAll;

- (OEBTextModel*) textModelFromPageIndex:(int)pageIndex;
- (OEBTextModel*) textModelFromLocation:(OEBLocation*)location;
- (int) startPageIndexWithTextModel:(OEBTextModel*)textModel;
//- (BOOL) isThisLocation:(OEBLocation*)leftLocation ForwardFromLocation:(OEBLocation*)rightLocaiton;
//- (BOOL) isThisLocation:(OEBLocation*)leftLocation BackwardFromLocation:(OEBLocation*)rightLocaiton;
@end
