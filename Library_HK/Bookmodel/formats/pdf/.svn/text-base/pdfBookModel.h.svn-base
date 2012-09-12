//
//  pdfBookModel.h
//  DocinBookReader
//
//  Created by mac-L on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "bookModel.h"
#import <Foundation/Foundation.h>

@interface pdfBookModel : bookModel
<BookModelProtocol>
{
    NSString *_bookTitle;
    NSUInteger _bookId;
    int _pageIndex;  //当前页数
 
}
@property(nonatomic,copy) NSString *bookTitle;
@property(nonatomic, assign) NSUInteger bookId;

- (id)initWithFilePath:(NSString*)filePath PageIndex:(int)pageIndex BookId:(NSUInteger)bookid;
@end
