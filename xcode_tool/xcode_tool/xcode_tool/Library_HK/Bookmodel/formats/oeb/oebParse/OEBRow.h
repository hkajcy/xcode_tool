//
//  OEBRow.h
//  OEBReader
//
//  Created by heyong on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEBRow.h"
#import "OEBParagraph.h"

typedef enum {
    OEBRowTypeText = 0,
    OEBRowTypeImage,
    OEBRowTypeHyperlink
} OEBRowType;

#pragma mark - OEBRow
@interface OEBRow : NSObject {
    OEBRowType type;
    CGRect rect;
    OEBParagraph *paragraph;
}
    
@property (nonatomic) OEBRowType type;
@property (nonatomic) CGRect rect;
@property (nonatomic, retain) OEBParagraph *paragraph;

@end

#pragma mark - OEBTextRow
@interface OEBTextRow : OEBRow {
    NSRange textRange;
    //OEBTextParagraph *paragraph;
}

@property (nonatomic) NSRange textRange;
//@property (nonatomic, retain) OEBTextParagraph *paragraph;

@end

#pragma mark - OEBImageRow
@interface OEBImageRow : OEBRow {
    //OEBImageParagraph *paragraph;
}

//@property (nonatomic, retain) OEBImageParagraph *paragraph;

@end

#pragma mark - OEBHyperlinkRow
@interface OEBHyperlinkRow : OEBTextRow {

}

@end