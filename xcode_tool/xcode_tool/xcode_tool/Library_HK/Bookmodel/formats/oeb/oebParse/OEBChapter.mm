//
//  OEBChapterReader.m
//  OEBReader
//
//  Created by heyong on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBConstant.h"
#import "OEBChapter.h"
#import "TFHpple.h"
#import "OEBParagraph.h"
#import "ZipArchive.h"

#import "StyleSheetTable.h"
#import "StyleSheetParser.h"
#import "OEBConstant.h"
#import "macros_for_IOS_hk.h"

@interface OEBChapter ()

@property (nonatomic, retain) ZipArchive *zipArchive;
@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, retain) TFHpple *hpple;
@property (nonatomic) BOOL hasHyperLink;
@property (nonatomic, copy) NSString *hyperLinkHref;
@property (nonatomic, retain) NSMutableDictionary* styleDic;
@property (nonatomic, retain) NSMutableDictionary* controlDic;

- (void)readWithContentsOfFile:(NSString *)path;
- (void)paragraphForElement:(TFHppleElement *)element withStyle:(OEBCSSStyle *)style;
- (OEBControlType)getControlType:(NSString *)tagName;
- (OEBCSSStyle *)getOEBCSSStyleWithTagName:(NSString *)tagName className:(NSString *)className;
- (void)addControlWithTag:(NSString *)tag style:(OEBCSSStyle *)style isStart:(BOOL)isStart;
- (void)elementForChildren:(TFHppleElement *)element withStyle:(OEBCSSStyle *)style;
- (OEBCSSStyle *)getNewOEBCSSStyle:(OEBCSSStyle *)style;
- (OEBCSSStyle *)getNewOEBCSSStyleFromStyle:(OEBCSSStyle *)fromStyle toStyle:(OEBCSSStyle *)toStyle;
- (NSArray *)componentsSeparatedForString:(NSString *)data withSep1:(NSString *)sep1 withSep2:(NSString *)sep2;

@end

@implementation OEBChapter

@synthesize zipArchive;
@synthesize title;
@synthesize paragraphs;
@synthesize basePath;
@synthesize hpple;
@synthesize hasHyperLink;
@synthesize hyperLinkHref;
@synthesize styleDic;
@synthesize controlDic;

- (id)init {
    self = [super init];
    if (self) {
        title = @"";
        paragraphs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithBasePath:(NSString *)bPath 
          withFileName:(NSString *)fileName 
        withZipArchive:(ZipArchive *)file
{
    self = [super init];
    if (self)
    {
        title = @"";
        paragraphs = [[NSMutableArray alloc] init];
        self.zipArchive = file;
        self.basePath = bPath;
        self.styleDic = [[[NSMutableDictionary alloc] init] autorelease];
        self.controlDic = [[[NSMutableDictionary alloc] init] autorelease];
        if (nil != file) 
        {
            [self readWithContentsOfFile:[bPath stringByAppendingString:fileName]];
        }
    }
    
    return self;
}

- (void)readWithContentsOfFile:(NSString *)path 
{
    START_TIMER
    if (nil == path)
    {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSData *xhtmlData;
    START_TIMER
    xhtmlData = [zipArchive readFileWithPath:path];
    END_TIMER(@"--------读取文件时间");
    
    
    if (nil == xhtmlData)
    {
        [pool release];
        return;
    }
    
    TFHpple *hpp = nil;
    NSArray *elements = nil;
    
    START_TIMER
    hpp = [[[TFHpple alloc] initWithHTMLData:xhtmlData] autorelease];
    self.hpple = hpp;
    elements = [hpple searchWithXPathQuery:@"//html"];
    END_TIMER(@"--------解析HTML时间");
    
    OEBCSSStyle *style;
    START_TIMER
    self.paragraphs = [[[NSMutableArray alloc] init] autorelease];
    
    delete sheetTable;
    sheetTable = NULL;
    delete tableParser;
    tableParser = NULL;
    
    delete internalSheetTable;
    internalSheetTable = NULL;
    delete internalTableParser;
    internalTableParser = NULL;
    
    delete singleParser;
    singleParser = new StyleSheetSingleStyleParser();
    
    style = [[[OEBCSSStyle alloc] init] autorelease];
    self.hasHyperLink = NO;
    self.hyperLinkHref = nil;
    END_TIMER(@"chushihua")
    
    START_TIMER
    for (TFHppleElement *element in elements) 
    {
        [self paragraphForElement:element withStyle:style];
    }
    END_TIMER(@"--------解析章节时间");
    
    START_TIMER
    self.hpple = nil;
    delete sheetTable;
    sheetTable = NULL;
    delete tableParser;
    tableParser = NULL;
    delete internalSheetTable;
    internalSheetTable = NULL;
    delete internalTableParser;
    internalTableParser = NULL;
    delete singleParser;
    singleParser = NULL;
    
    
    [pool release];
    END_TIMER(@"--------释放空间")
    
    END_TIMER(@"readWithContentsOfFile")
}

- (OEBControlType)getControlType:(NSString *)tagName
{
    int ret = [HTMLNamesInstance tagWithName:tagName];
    return ret;
}

- (OEBCSSStyle *)getNewOEBCSSStyle:(OEBCSSStyle *)style 
{
    return style;
}

- (OEBCSSStyle *)getNewOEBCSSStyleFromStyle:(OEBCSSStyle *)fromStyle toStyle:(OEBCSSStyle *)toStyle 
{
    return fromStyle;
}

- (OEBCSSStyle *)getOEBCSSStyleWithTagName:(NSString *)tagName className:(NSString *)className 
{
    NSString* styleKey = [tagName?tagName:@" " stringByAppendingString:className?className:@" "];
    OEBCSSStyle *style = nil;
    
    style = [self.styleDic objectForKey:styleKey];
    
    if (style)
    {
        return style;
    }
    
    OEBCSSStyle *internalStyle = nil;
    StyleSheetTable *table = NULL;
    
    if (internalSheetTable) {
        table = internalSheetTable;
        
        OEBCSSStyle *style1 = table->createOEBCSSStyle(tagName, @"");
        if (nil != style1) {
            [style1 appendingCSSStyle:internalStyle];
            internalStyle = style1;
        }
        
        OEBCSSStyle *style2 = table->createOEBCSSStyle(@"", className);
        if (nil != style2) {
            [style2 appendingCSSStyle:internalStyle];
            internalStyle = style2;
        }
        OEBCSSStyle *style3 = table->createOEBCSSStyle(tagName, className);
        if (nil != style3) {
            [style3 appendingCSSStyle:internalStyle];
            internalStyle = style3;
        }
    }

    if (sheetTable) {
        table = sheetTable;
        
        OEBCSSStyle *style1 = table->createOEBCSSStyle(tagName, @"");
        if (nil != style1) {
            [style1 appendingCSSStyle:style];
            style = style1;
        } else {
            if ([tagName isEqualToString:kHTMLTag_H1] 
                || [tagName isEqualToString:kHTMLTag_H2] 
                || [tagName isEqualToString:kHTMLTag_H3] 
                || [tagName isEqualToString:kHTMLTag_H4] 
                || [tagName isEqualToString:kHTMLTag_H5] 
                || [tagName isEqualToString:kHTMLTag_H6]) {
                
                CGFloat fontSize = kSystemFontDefaultSize;
                if ([tagName isEqualToString:kHTMLTag_H1]) {
                    fontSize = kCSSFontSize_XXLarge;
                } else if ([tagName isEqualToString:kHTMLTag_H2]) {
                    fontSize = kCSSFontSize_XLarge;
                } else if ([tagName isEqualToString:kHTMLTag_H3]) {
                    fontSize = kCSSFontSize_Large;
                } else if ([tagName isEqualToString:kHTMLTag_H4]) {
                    fontSize = kCSSFontSize_Medium;
                } else if ([tagName isEqualToString:kHTMLTag_H5]) {
                    fontSize = kCSSFontSize_Small;
                } else if ([tagName isEqualToString:kHTMLTag_H6]) {
                    fontSize = kCSSFontSize_XSmall;
                }
                
                OEBFont *font = [[OEBFont alloc] initWithStyle:OEBFontStyleBold withFontSize:fontSize withFontName:nil];
                style = [[[OEBCSSStyle alloc] initWithTextAlign:OEBTextAlignmentLeft withFontStyle:font withTextIndent:NO withTextColor:kCSSTextColor_Black] autorelease];
                [font release];
            }
        }
        
        OEBCSSStyle *style2 = table->createOEBCSSStyle(@"", className);
        if (nil != style2) {
            [style2 appendingCSSStyle:style];
            style = style2;
        }
        OEBCSSStyle *style3 = table->createOEBCSSStyle(tagName, className);
        if (nil != style3) {
            [style3 appendingCSSStyle:style];
            style = style3;
        }
    }
    
    if (nil != internalStyle) 
    {
        [internalStyle appendingCSSStyle:style];
        style = internalStyle;
    }
    
    if (style)
    {
        [self.styleDic setValue:style forKey:styleKey];
    }
    return style;
}

#pragma mark-
#pragma mark kHTMLTag
- (void) kHTMLTag_IMG:(NSDictionary*)dic
{
    
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    [self addControlWithTag:tag style:newStyle isStart:YES];
    
    // Create image paragraph
    OEBImageParagraph *paragraph = [[OEBImageParagraph alloc] init];
    paragraph.imagePath = [basePath stringByAppendingString:[attrs objectForKey:kHTMLAttribute_Src]];
    [self.paragraphs addObject:paragraph];
    [paragraph release];
    
    
    [self elementForChildren:element withStyle:newStyle];
    
    [self addControlWithTag:tag style:newStyle isStart:NO];
    
}

- (void) kHTMLTag_A:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    hasHyperLink = YES;
    hyperLinkHref = [attrs objectForKey:kHTMLAttribute_Href];
    
    [self elementForChildren:element withStyle:newStyle];

    hasHyperLink = NO;
    hyperLinkHref = nil;
}

- (void) parseCSSExternal:(NSData*)cssData
{
    delete sheetTable;
    sheetTable = new StyleSheetTable();
    delete tableParser;
    tableParser = new StyleSheetTableParser(*sheetTable);
    tableParser->parse((const char*)[cssData bytes], [cssData length]);
}

- (void) parseCSSInternal:(NSString*)cssStr
{
    delete internalSheetTable;
    internalSheetTable = new StyleSheetTable();
    delete internalTableParser;
    internalTableParser = new StyleSheetTableParser(*internalSheetTable);
    internalTableParser->parse([cssStr UTF8String], [cssStr length]);
}

- (void) kHTMLTag_LINK:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    // link
    NSString *rel = [attrs objectForKey:kHTMLAttribute_Rel];
    NSString *type = [attrs objectForKey:kHTMLAttribute_Type];
    
    if ([rel isEqualToString:@"stylesheet"] 
        && [type isEqualToString:@"text/css"]) 
    {
        NSData *cssData = [zipArchive readFileWithPath:[basePath stringByAppendingString:[attrs objectForKey:kHTMLAttribute_Href]]];
        [self parseCSSExternal:cssData];
    }
}

- (void) kHTMLTag_STYLE:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    
    NSString *type = [attrs objectForKey:kHTMLAttribute_Type];
    if ([type isEqualToString:@"text/css"]) {
        NSArray *childElements = [element children];
        for (TFHppleElement *childElement in childElements) 
        {
            NSString *content = [childElement content];
            if ([content length] > 0)
            {
                [self parseCSSInternal:content];
            }
        }
    }
}

- (void) kHTMLTag_SVG:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    [self addControlWithTag:tag style:newStyle isStart:YES];
    NSArray *childElements = [element children];
    for (TFHppleElement *childElement in childElements) {
        if ([[childElement tagName] isEqualToString:kHTMLTag_Image]) {
            NSString *imagePath = [[childElement attributes] objectForKey:kHTMLAttribute_xlinkHref];
            if (nil != imagePath && [imagePath length] > 0) {
                OEBImageParagraph *paragraph = [[OEBImageParagraph alloc] init];
                paragraph.imagePath = [basePath stringByAppendingString:imagePath];
                [self.paragraphs addObject:paragraph];
                [paragraph release];
            }
        }
    }
    [self addControlWithTag:tag style:newStyle isStart:NO];
}

//#define HTMLFUN(tagName)            HTMLFUN_##tagName
//- (void) HTMLFUN(ID_A):(id)value
//{
//}


- (void) kHTMLTag_B:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    [self addControlWithTag:tag style:newStyle isStart:YES];
    if (OEBFontStyleItalic == newStyle.fontStyle.style 
        || OEBFontStyleBoldItalic == newStyle.fontStyle.style) 
    {
        newStyle.fontStyle.style = OEBFontStyleBoldItalic;
    }
    else
    {
        newStyle.fontStyle.style = OEBFontStyleBold;
    }
    newStyle.textFont = [newStyle.fontStyle getUIFont];
    
    [self elementForChildren:element withStyle:newStyle];
    [self addControlWithTag:tag style:newStyle isStart:NO];
}

- (void) kHTMLTag_STRONG:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    [self addControlWithTag:tag style:newStyle isStart:YES];
    if (OEBFontStyleItalic == newStyle.fontStyle.style 
        || OEBFontStyleBoldItalic == newStyle.fontStyle.style) 
    {
        newStyle.fontStyle.style = OEBFontStyleBoldItalic;
    }
    else
    {
        newStyle.fontStyle.style = OEBFontStyleBold;
    }
    newStyle.textFont = [newStyle.fontStyle getUIFont];
    
    [self elementForChildren:element withStyle:newStyle];
    [self addControlWithTag:tag style:newStyle isStart:NO];
}

- (void) kHTMLTag_I:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    [self addControlWithTag:tag style:newStyle isStart:YES];
    if (OEBFontStyleBold == newStyle.fontStyle.style 
        || OEBFontStyleBoldItalic == newStyle.fontStyle.style) {
        newStyle.fontStyle.style = OEBFontStyleBoldItalic;
    } else {
        newStyle.fontStyle.style = OEBFontStyleItalic;
    }
    newStyle.textFont = [newStyle.fontStyle getUIFont];
    
    [self elementForChildren:element withStyle:newStyle];
    [self addControlWithTag:tag style:newStyle isStart:NO];
}

- (void) kHTMLTag_BR:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    [self addControlWithTag:tag style:newStyle isStart:NO];
}

- (void) kHTMLTag_TEXT:(NSDictionary*)dic
{
    TFHppleElement* element = [dic objectForKey:@"element"];
    NSString *tag = [element tagName];
    OEBCSSStyle *newStyle = [dic objectForKey:@"newStyle"];
    NSDictionary * attrs = [element attributes];
    
    NSString *content = [element content];
    
    if ([content length] > 0) 
    {
        TFHppleElement *parentElement = [element parent];
        NSString *parentTag = [parentElement tagName];
        
        if ([parentTag isEqualToString:kHTMLTag_Title]) 
        {
            // title
            self.title = content;
        }
        else
        {
            NSArray *strArray = [self componentsSeparatedForString:content withSep1:@"\r\n" withSep2:@"\n"];
            
            OEBTextParagraph* paragraph = nil;
            for (NSString *str in strArray) 
            {
                if ([str length] > 0) 
                {
                    if (hasHyperLink)
                    {
                        paragraph = [[[OEBHyperlinkParagraph alloc] init] autorelease];
                        ((OEBHyperlinkParagraph*)paragraph).href = hyperLinkHref;
                    }
                    else
                    {
                        paragraph = [[[OEBTextParagraph alloc] init] autorelease];
                    }
                    
                    paragraph.content = str;
                    paragraph.textStyle = [self getNewOEBCSSStyle:newStyle];
                    [self.paragraphs addObject:paragraph];
                }
                
                if ([strArray indexOfObject:str] != [strArray count] - 1)
                {
                    [self addControlWithTag:kHTMLTag_Br style:newStyle isStart:NO];
                }
            }
        }
    }
}
#pragma mark-
#pragma mark paragraphForElement
- (void)paragraphForElement:(TFHppleElement *)element withStyle:(OEBCSSStyle *)style
{
    NSString *tag = [element tagName];
    NSDictionary * attrs = [element attributes];
    NSString *className = [attrs objectForKey:kHTMLAttribute_Class];
    
    BOOL isTextTag = [tag isEqualToString:kHTMLTag_Text];
    OEBCSSStyle *newStyle = nil;
    if (!isTextTag) 
    {
        NSString *styleAttr = [attrs objectForKey:@"style"];
        
        if (nil != styleAttr)
        {
            shared_ptr<ZLTextStyleEntry> entry = singleParser->parseString([styleAttr UTF8String]);
            newStyle = StyleSheetTable::createOEBCSSStyle(*entry);
        }
        
        if (nil == newStyle) 
        {
            newStyle = [self getOEBCSSStyleWithTagName:tag className:className];
            if (nil == newStyle)
            {
                newStyle = [self getNewOEBCSSStyle:style];
            }
        }
        
        [newStyle appendingCSSStyle:style];
        
    } 
    else
    {
        newStyle = [self getNewOEBCSSStyle:style];
    }
    
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         newStyle,@"newStyle",
                         element,@"element",
                         nil];
    NSString* funName = [[@"kHTMLTag_" stringByAppendingString:[tag uppercaseString]] stringByAppendingString:@":"];
    SEL fun = NSSelectorFromString(funName);
    
    if ([self respondsToSelector:fun])
    {
        [self performSelector:fun withObject:dic];
    }
    else
    {
        try 
        {
            NSSet* set = [NSSet setWithObjects:@"HTML",
                          @"HEAD",
                          @"META",
                          @"TITLE",
                          @"BODY",
                          @"DIV",
                          @"P",
                          @"SPAN",
                          @"OL",
                          @"LI",
                          @"EM",
                          @"TABLE",
                          @"UL",
                          [kHTMLTag_H1 uppercaseString],
                          [kHTMLTag_H2 uppercaseString],
                          [kHTMLTag_H3 uppercaseString],
                          [kHTMLTag_H4 uppercaseString],
                          [kHTMLTag_H5 uppercaseString],
                          [kHTMLTag_H6 uppercaseString],
                          nil];
            if (![set containsObject:[tag uppercaseString]])
            {
                [NSException raise:@"" format:@""];
            }
            
        }
        catch (NSException *e)
        {
        }
        
        [self addControlWithTag:tag style:newStyle isStart:YES];
        [self elementForChildren:element withStyle:newStyle];
        [self addControlWithTag:tag style:newStyle isStart:NO];
    }
}

- (void)elementForChildren:(TFHppleElement *)element withStyle:(OEBCSSStyle *)style 
{
    NSArray *childElements = [element children];
    for (TFHppleElement *childElement in childElements) {
        [self paragraphForElement:childElement withStyle:style];
    }
}

- (void)addControlWithTag:(NSString *)tag style:(OEBCSSStyle *)style isStart:(BOOL)isStart 
{
    NSString* key = [[[NSString stringWithString:tag] stringByAppendingString:[style description]] stringByAppendingFormat:@"%d",isStart];
    
    OEBControlParagraph *controlP = nil;
    
    controlP = [self.controlDic objectForKey:key];
    
    if (!controlP)
    {
        controlP = [[[OEBControlParagraph alloc] init] autorelease];
        controlP.isStart = isStart;
        controlP.style = [self getNewOEBCSSStyle:style];
        controlP.controlType = [self getControlType:tag];
        controlP.controlName = tag;
        
        //能快0.1s
        [self.controlDic setValue:controlP forKey:key];
    }
    
    [self.paragraphs addObject:controlP];
}

- (NSArray *)componentsSeparatedForString:(NSString *)data withSep1:(NSString *)sep1 withSep2:(NSString *)sep2
{
    NSMutableArray *newArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *sep1Array = [data componentsSeparatedByString:sep1];
    for (NSString *sep1Str in sep1Array) 
    {
        NSArray *sep2Array = [sep1Str componentsSeparatedByString:sep2];
        [newArray addObjectsFromArray:sep2Array];
    }
    return newArray;
}

- (void)dealloc {
    delete sheetTable;
    delete tableParser;
    delete internalSheetTable;
    delete internalTableParser;
    delete singleParser;
    
    [zipArchive release];
    [title release];
    [paragraphs release];
    [basePath release];
    [hpple release];
    [hyperLinkHref release];
    self.styleDic = nil;
    self.controlDic = nil;
    [super dealloc];
}
@end
