//
//  OEBParagraph.h
//  OEBReader
//
//  Created by heyong on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEBCSSStyle.h"
#import "htmlnames.h"

typedef enum {
    OEBParagraphTypeText = 0,
    OEBParagraphTypeImage,
    OEBParagraphTypeControl,
    OEBParagraphTypeHyperlink
} OEBParagraphType;

#pragma mark - Paragraph
@interface OEBParagraph : NSObject {
    OEBParagraphType type;
}

@property (nonatomic) OEBParagraphType type;

@end
 
#pragma mark - TextParagraph
@interface OEBTextParagraph : OEBParagraph {
    OEBCSSStyle *textStyle;
    NSString *content;
}

@property (nonatomic, retain) OEBCSSStyle *textStyle;
@property (nonatomic, copy) NSString *content;

@end


#pragma mark - ImageParagraph
@interface OEBImageParagraph : OEBParagraph {
    NSString *imagePath;
}

@property (nonatomic, copy) NSString *imagePath;

@end

#pragma mark - ControlParagraph
@interface OEBControlParagraph : OEBParagraph {
    OEBCSSStyle *style;
    OEBControlType controlType;
    BOOL isStart;
    NSString* controlName;
}

@property (nonatomic, retain) OEBCSSStyle *style;
@property (nonatomic) OEBControlType controlType;
@property (nonatomic) BOOL isStart;
@property (nonatomic, retain) NSString* controlName;

- (BOOL) lineBreaker;
@end

#pragma mark - HyperlinkParagraph
@interface OEBHyperlinkParagraph : OEBTextParagraph {
    NSString *href;
}

@property (nonatomic, copy) NSString *href;

@end
