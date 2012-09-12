//
//  PdfOutlines.h
//  PDFTest
//
//  Created by heyong on 11-11-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFDest : NSObject {
    NSInteger pageNumber;
}

@property (nonatomic) NSInteger pageNumber;

@end

@interface PDFOutlineItem : NSObject {
	NSString* m_title;
	NSMutableArray*	m_children;
	PDFOutlineItem*	m_parent;
	PDFDest *m_dest;
}

@property (nonatomic, copy)	NSString* title;
@property (nonatomic, assign) PDFOutlineItem* parent;
@property (nonatomic, retain) PDFDest *dest;
@property (nonatomic, retain) NSMutableArray* children;

- (id)initWithChildrenCount:(NSInteger)count;
- (void)addChildItem:(PDFOutlineItem *)item;
- (BOOL)hasChildren;
- (void)printInfoLevel:(NSInteger)level;
- (NSArray *)getArrayForOutlineItem;

@end

@interface PDFOutline : NSObject {
    PDFOutlineItem *rootItem;
}

+ (PDFOutline*) pdfOutlineOfDocument:(CGPDFDocumentRef)pdfDocument;
+ (BOOL) hasOutlineInPdfDocument:(CGPDFDocumentRef)pdfDocument;

@property (nonatomic, retain) PDFOutlineItem *rootItem;

@end




