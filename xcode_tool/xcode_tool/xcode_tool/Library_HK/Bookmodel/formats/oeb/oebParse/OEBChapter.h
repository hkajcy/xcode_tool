//
//  OEBChapterReader.h
//  OEBReader
//
//  Created by heyong on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEBConstant.h"
#import "htmlnames.h"

@class ZipArchive;
@class TFHpple;

class StyleSheetSingleStyleParser;
class StyleSheetTable;
class StyleSheetTableParser;

@interface OEBChapter : NSObject {
    NSString *title;
    NSMutableArray *paragraphs;
    ZipArchive *zipArchive;
    NSString *basePath;
    TFHpple *hpple;
    
    StyleSheetTable *sheetTable;
    StyleSheetTableParser *tableParser;
    
    StyleSheetTable *internalSheetTable;
    StyleSheetTableParser *internalTableParser;
    
    StyleSheetSingleStyleParser *singleParser;
    
    BOOL hasHyperLink;
    NSString *hyperLinkHref;
}

- (id)initWithBasePath:(NSString *)basePath 
          withFileName:(NSString *)fileName 
        withZipArchive:(ZipArchive *)file;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSMutableArray *paragraphs;


@end

