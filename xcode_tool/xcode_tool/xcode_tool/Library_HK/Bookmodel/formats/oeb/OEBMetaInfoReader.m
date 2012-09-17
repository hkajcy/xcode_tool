//
//  OEBMetaInfoReader.m
//  epubParse
//
//  Created by  on 11-10-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBMetaInfoReader.h"
#import "GDataXMLNode.h"
#import "OEBSpine.h"
#import "book.h"
#import "OEBLocation.h"
#import "ZipArchive.h"
#import "macros_for_IOS_hk.h"
#import "book.h"

#define ITEM                                         @"item"
#define ITEMREF                                      @"itemref"
#define MANIFEST                                     @"manifest"
#define SPINE                                        @"spine"
#define GUIDE                                        @"guide"
#define REFERENCE                                    @"reference"
#define METADATA                                     @"metadata"
#define ATTRIBUTE_NAME                               @"name"
#define ATTRIBUTE_CONTENT                            @"content"
#define META                                         @"meta"
#define ATTRIBUTE_HERF                               @"href"
#define ATTRIBUTE_ID                                 @"id"
#define AATTRIBUTE_IDREF                             @"idref"
#define ATTRIBUTE_TITLE                              @"title"

@implementation OEBMetaInfoReader

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

+ (NSString*)opfNameWithContainer:(NSData*) metaInfoData;
{
    /*
     测试方法
     NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"container" ofType:@"xml"];
     NSString *xmlFileContents = [NSString stringWithContentsOfFile:xmlFilePath encoding:NSUTF8StringEncoding error:nil];
     NSData *xmlData = [xmlFileContents dataUsingEncoding:NSUTF8StringEncoding];
     [OEBMetaInfoReader opfNameWithContainer:xmlData];
     */
    
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:metaInfoData options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    NSString *opfName = nil;
    
    NSArray *rootMembers = [doc.rootElement elementsForName:@"rootfiles"];
    
    if (rootMembers.count > 0) {
        for (GDataXMLElement *rootfiles in rootMembers) {
            
            NSArray *rootfile = [rootfiles elementsForName:@"rootfile"];
            
            if (rootfile.count > 0) {
                for (GDataXMLElement *element in rootfile) {
                    opfName = [[element attributeForName:@"full-path"] stringValue];
                    break;
                }
            }
        }
    }
    
    [doc release];
    return opfName;
}

+ (OEBSpine*)createSpine:(NSData*)metaInfoData 
            withBasePath:(NSString *)basePath 
          withZipArchive:(ZipArchive *)zipArchive
{
    
    NSError *error;
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:metaInfoData options:0 error:&error];
    if (doc == nil) 
    {
        SAFE_RELEASE(pool)
        return nil;
    }
    
    NSArray *manifestArray = [doc.rootElement elementsForName:MANIFEST];
    NSArray *spineArray = [doc.rootElement  elementsForName:SPINE];
    NSArray *guideArray = [doc.rootElement elementsForName:GUIDE];

    // parse manifest

    NSMutableDictionary *manifestDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *distinctDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    if (manifestArray.count > 0) {
        for (GDataXMLElement *manifestMembers in manifestArray) {
            
            NSArray *itemArray = [manifestMembers elementsForName:ITEM];
            
            if (itemArray.count > 0) {
                for (GDataXMLElement *item in itemArray) {
                    NSString *spineId = nil;
                    NSString *href = nil;
                    spineId = [[item attributeForName:ATTRIBUTE_ID] stringValue];
                    href = [[item attributeForName:ATTRIBUTE_HERF] stringValue];
                    [manifestDic  setObject:href forKey:spineId];// id作为主键，href作为值
                }
            }
        }
    }
    // parse guide

    NSMutableDictionary *guideDic = [[NSMutableDictionary alloc] init];
    
    if (guideArray.count > 0) {
        for (GDataXMLElement *guideMembers in guideArray) {
            
            NSArray *refArray = [guideMembers elementsForName:REFERENCE];
            
            if (refArray.count > 0) {
                for (GDataXMLElement *item in refArray) {
                    NSString *title = nil;
                    NSString *href = nil;
                    title = [[item attributeForName:ATTRIBUTE_TITLE] stringValue];
                    href = [[item attributeForName:ATTRIBUTE_HERF] stringValue];
                    [guideDic  setObject:title forKey:href]; // href作为主键，title作为值
                }
            }
        }
    }
    
    // parse spine
    NSMutableArray *spine = [[NSMutableArray alloc] init];
    if (spineArray.count > 0) {
        for (GDataXMLElement *spineMembers in spineArray) {
            
            NSArray *itemRefArray = [spineMembers elementsForName:ITEMREF];
            
            if (itemRefArray.count > 0)
            {
                for (GDataXMLElement *item in itemRefArray)
                {
                    NSString *idref = nil;
                    idref = [[item attributeForName:AATTRIBUTE_IDREF] stringValue];
                    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                    [tempDic  setObject:idref forKey:SpineID_STR];// add key id
                    
                    NSString *href = [manifestDic objectForKey:idref] ;
                    
                    OEBLocation* loc = [[OEBLocation alloc] init];
                    loc.href = href;
                    [tempDic setObject:loc forKey:SpineLocation_STR];// add key position
                    [loc release];
                    
                    
                    if ([guideDic objectForKey:href] != nil)
                    { // add key title
                        [tempDic setObject:[guideDic objectForKey:href] forKey:SpineTittle_STR];
                    }
                     
                    
                    if (![distinctDic objectForKey:href])
                    {
                        [spine addObject:tempDic];
                        [distinctDic setValue:tempDic forKey:href];
                    }
                    [tempDic release];
                }
            }
        }
    }

    SAFE_RELEASE(pool)
    [manifestDic release];
    [guideDic release];
    
    OEBSpine *oebSpine = [[[OEBSpine alloc] init] autorelease];
    oebSpine.spineArray  = spine;
    [spine release];
    [doc release];
    return oebSpine;
}

+ (void) getCoverImage:(NSData*)metaInfoData withMetaDic:(NSMutableDictionary*)metaDic
{
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:metaInfoData options:0 error:&error];
    if (doc == nil) {
        return ;
    }
    NSArray *metadataArray = [doc.rootElement elementsForName:METADATA];
    
    NSArray *tempArray = nil;
    NSString *name = nil;
    NSString *content = nil;
    if (metadataArray.count > 0)
    {
        for (GDataXMLElement *metadataMembers in metadataArray)
        {
            tempArray = [metadataMembers elementsForName:META];
            for (GDataXMLElement *item in tempArray)
            {
                name = [[item attributeForName:ATTRIBUTE_NAME] stringValue];
                content = [[item attributeForName:ATTRIBUTE_CONTENT] stringValue];
            }
        }
    }
    
    NSArray * manifestArray = [doc.rootElement elementsForName:MANIFEST];
    for (GDataXMLElement *metadataMembers in manifestArray)
    {
        tempArray = [metadataMembers elementsForName:ITEM];
        for (GDataXMLElement *item in tempArray)
        {
            NSString* ID = [[item attributeForName:ATTRIBUTE_ID] stringValue];
            NSString* Href = [[item attributeForName:ATTRIBUTE_HERF] stringValue];
            
            if ([ID isEqualToString:name]
                || [ID isEqualToString:content]
                )
            {
                if (NSOrderedSame == [[Href pathExtension] compare:@"jpg" options:NSCaseInsensitiveSearch]
                    || NSOrderedSame == [[Href pathExtension] compare:@"png" options:NSCaseInsensitiveSearch]
                    || NSOrderedSame == [[Href pathExtension] compare:@"jpeg" options:NSCaseInsensitiveSearch])
                {
                    [metaDic setObject:Href forKey:coverImageHref_STR];
                    [doc release];
                    return;
                }
            }
        }
    }
    [doc release];
    return ;
}

+ (NSMutableDictionary*)createMetaInfoDic:(NSData*)metaInfoData
{
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:metaInfoData options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    NSArray *metadataArray = [doc.rootElement elementsForName:METADATA];
    NSMutableDictionary *metaDic = [[NSMutableDictionary alloc] init ];
    
    NSString *temp = nil;
    NSArray *tempArray = nil;
    if (metadataArray.count > 0)
    {
        for (GDataXMLElement *metadataMembers in metadataArray)
        {
            tempArray= [metadataMembers elementsForName:tittle_STR];            
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:tittle_STR];
            }
            
            tempArray =  [metadataMembers elementsForName:language_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if(temp != nil){
                [metaDic setObject:temp forKey:language_STR];
            }
            
            tempArray= [metadataMembers elementsForName:creator_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:creator_STR];
            }
            
            tempArray = [metadataMembers elementsForName:publisher_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if(temp != nil){
                [metaDic setObject:temp forKey:publisher_STR];
            }
            
            tempArray = [metadataMembers elementsForName:filePath_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:filePath_STR];
            }
            
            tempArray = [metadataMembers elementsForName:encoding_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:encoding_STR];
            }
            
            tempArray = [metadataMembers elementsForName:description_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if(temp != nil){
                [metaDic setObject:temp forKey:description_STR];
            }
            
            tempArray = [metadataMembers elementsForName:coverage_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if(temp != nil){
                [metaDic setObject:temp forKey:coverage_STR];
            }
            
            tempArray = [metadataMembers elementsForName:source_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if(temp != nil){
                [metaDic setObject:temp forKey:source_STR];
            }
            
            tempArray = [metadataMembers elementsForName:date_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:date_STR];
            }
            
            tempArray = [metadataMembers elementsForName:rights_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:rights_STR];
            }
            
            tempArray = [metadataMembers elementsForName:subject_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:subject_STR];
            }
            
            tempArray = [metadataMembers elementsForName:contributor_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:contributor_STR];
            }
            
            tempArray = [metadataMembers elementsForName:type_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:type_STR];
            }
            
            tempArray = [metadataMembers elementsForName:format_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:format_STR];
            }
            
            tempArray = [metadataMembers elementsForName:relation_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:relation_STR];
            }
            
            tempArray = [metadataMembers elementsForName:builder_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:builder_STR];
            }
            
            tempArray = [metadataMembers elementsForName:builder_version_STR];
            temp = [[tempArray objectAtIndex:0] stringValue];
            if (temp != nil) {
                [metaDic setObject:temp forKey:builder_version_STR];
            }
        }
    }
    
    [OEBMetaInfoReader getCoverImage:metaInfoData withMetaDic:metaDic];
    [doc release];
    return [metaDic autorelease];
}

+ (void) ncxRead:(NSArray*)paramArray
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    assert([paramArray count] == 2);
    
    [OEBMetaInfoReader ncxRead:[paramArray objectAtIndex:0] With:[paramArray objectAtIndex:1]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NcxReadFinished_STR object:nil];
    SAFE_RELEASE(pool)
}

+ (void) ncxRead:(NSData*)ncxData With:(NSMutableArray*)spineArray
{
    
    for (NSDictionary* dic in spineArray)
    {
        NSNumber* isInncx = [NSNumber numberWithBool:NO];
        [dic setValue:isInncx forKey:SpineIsInNCX_STR];
    }
    
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:ncxData options:0 error:&error];
    if (doc == nil) {
        return ;
    }
    NSArray *navmapArray = [doc.rootElement elementsForName:@"navMap"];

    for (GDataXMLElement *members in navmapArray)
    {
        NSString* chapterTitle = nil;
        NSString* src = nil;
        NSArray *navPointArray = [members elementsForName:@"navPoint"];
        for (GDataXMLElement *members in navPointArray) 
        {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
            NSArray *navLabelArray = [members elementsForName:@"navLabel"];
            for (GDataXMLElement *members in navLabelArray) 
            {
                NSArray *textArray = [members elementsForName:@"text"];
                chapterTitle = [[textArray objectAtIndex:0] stringValue];
            }
            
            NSArray *contentArray = [members elementsForName:@"content"];
            for (GDataXMLElement *members in contentArray) 
            {
                src = [[members attributeForName:@"src"] stringValue];
                //这个src有可能包含#所以要把#去掉
                int index = [src rangeOfString:@"#"].location;
                if (index != NSNotFound)
                {
                    src = [src substringToIndex:index];
                }
            }
            
            for (NSDictionary* dic in spineArray)
            {
                if (src)
                {
                    if ([src isEqualToString:((OEBLocation*)[dic objectForKey:SpineLocation_STR]).href])
                    {
                        if (chapterTitle) 
                        {
                            [dic setValue:chapterTitle forKey:SpineTittle_STR];
                            NSNumber* isInncx = [NSNumber numberWithBool:YES];
                            [dic setValue:isInncx forKey:SpineIsInNCX_STR];
                        }
                        break;
                    }
                }
            }
            
            //二阶查找  begin
            NSArray *navPointArray = [members elementsForName:@"navPoint"];
            for (GDataXMLElement *members in navPointArray) 
            {
                NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
                NSArray *navLabelArray = [members elementsForName:@"navLabel"];
                for (GDataXMLElement *members in navLabelArray) 
                {
                    NSArray *textArray = [members elementsForName:@"text"];
                    chapterTitle = [[textArray objectAtIndex:0] stringValue];
                }
                NSArray *contentArray = [members elementsForName:@"content"];
                for (GDataXMLElement *members in contentArray) 
                {
                    src = [[members attributeForName:@"src"] stringValue];
                    //这个src有可能包含#所以要把#去掉
                    int index = [src rangeOfString:@"#"].location;
                    if (index != NSNotFound)
                    {
                        src = [src substringToIndex:index];
                    }
                }
                for (NSDictionary* dic in spineArray)
                {
                    if (src)
                    {
                        if ([src isEqualToString:((OEBLocation*)[dic objectForKey:SpineLocation_STR]).href])
                        {
                            if (chapterTitle) 
                            {
                                [dic setValue:chapterTitle forKey:SpineTittle_STR];
                                NSNumber* isInncx = [NSNumber numberWithBool:YES];
                                [dic setValue:isInncx forKey:SpineIsInNCX_STR];
                            }
                            break;
                        }
                    }
                }
                [pool release];
                //二阶查找  end
            }
            [pool release];
        }
    }
    [doc release];
    return;
}

@end
