//
//  bookChapter.m
//  RegxDemo
//
//  Created by zhao liang on 11-8-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtBookChapter.h"
#import "RegexKitLite.h"
#import "txtStringStream.h"
#import "BookSaveFile.h"
#import "txtLocation.h"
#import "macros_for_IOS_hk.h"
#import "NSString ++.h"
@interface txtBookChapter(private)
- (NSMutableArray *)sectionInSearch:(NSString *)searchString;
- (void)sectionOutSearch:(NSString *)newString;
- (void)searchRegx:(NSString *)searchString;
- (void)percentTransformByTotoal:(NSUInteger) total;
@end 

@implementation txtBookChapter

#define LENGTH 50
#define TITLELENGTH 20
#define TEMPLOCATION @"templocation"

@synthesize chapterArray;
@synthesize oldString;
@synthesize separateTitleString;


- (id)init
{
    self = [super init];
    if (self) {
        oldString = nil;
        isNull = NO;
        isSeparate = NO;
        chapterArray = [[NSMutableArray alloc] init];
        isFinish = NO;
    }
    
    return self;
}

- (void)createChapter:(txtStringStream *)stringStream WithBookid:(NSUInteger) bookid
{
    NSMutableArray *chapter = [BookSaveFile readChapterArray:bookid];
    if (chapter == nil && [chapterArray count] == 0) 
    {
        if (isFinish ) 
        {
            return;
        }
        else
        {
            NSString *newString;
            assert(stringStream != nil);
            [stringStream strReset];
            while (1)
            {
                NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
                newString= [stringStream readFileFromCurrentCurseByCreatingSpine];
                if(newString == nil)
                {
                    [pool release];
                    break;
                }
                
                [self sectionOutSearch:newString];
                [pool release];
            }
            [self percentTransformByTotoal:stringStream.totalCharacters];
            
            isFinish = YES;
        }
        [BookSaveFile writeChapterArray:chapterArray WithBookId:bookid];
    }
    else
    {
        self.chapterArray = chapter;
    }
    
    //兼容epub 黄柯添加
    for (NSDictionary* dic in self.chapterArray)
    {
        [dic setValue:[NSNumber numberWithBool:YES] forKey:SpineIsInNCX_STR];
    }
}
- (void)percentTransformByTotoal:(NSUInteger) total
{
    for(int i= 0; i<[chapterArray count]; i++)
    {
        NSMutableDictionary *tmp = nil;
        tmp = [chapterArray objectAtIndex:i];
        NSNumber *Molecular = [tmp objectForKey:TEMPLOCATION];

        float percent = (float) [Molecular intValue]/ total * 100;
        [tmp setValue:[NSNumber numberWithFloat:percent] forKey:@"percent"];
    }
}
- (NSMutableArray *)sectionInSearch:(NSString *)searchString//一个buffer内的正则搜索
{
//    debugLog(@"***************%@", searchString);
    NSMutableArray *reArray = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0, searchString.length);
    
    NSString *regexString = @"§§§|\\b第(\\s*\\w\\s*){1,5}回\\b|\\b第\\s*\\w{1,8}\\s*章|\\b第\\s*\\w{1,8}\\s*卷\\b|\\b第\\s*\\w{1,8}\\s*篇\\b|\\b第(\\s*\\w\\s*){1,5}节|\\bchapter\\s*\\d\\b|\\bsection\\s*\\d\\b";
    
    NSArray  *matchArray   = nil;  
    matchArray = [searchString componentsMatchedByRegex:regexString]; 
    NSRange matchedRange ;
    NSString *titleString = nil;
    
    for (int i= 0; i< [matchArray count]; i++) {
        
        matchedRange = [searchString rangeOfRegex:regexString inRange:searchRange];
        
        NSUInteger tmpLocation = matchedRange.location + matchedRange.length;
        NSUInteger tmpLength = searchString.length - tmpLocation;
        if (tmpLength >= 20) { 
            
            titleString = [searchString stringByMatching:@"\\r\\n|\\b.{0,20}" inRange:NSMakeRange(tmpLocation, 20)];
            titleString = [titleString stringByReplacingOccurrencesOfRegex:@"\\)\\]" withString:@""];
            
        }
   
        else //章节和章节题目分离
        {
            titleString = [searchString stringByMatching:@"\\r\\n|\\b.{0,19}" inRange:NSMakeRange(tmpLocation,tmpLength)];
            if (![titleString isEqualToString:@"\r\n"] && [titleString findSubString:@"\r\n"] != -1) //判断后边是否为空格
            {
                if (tmpLength == 0) { //章节题目没有分离
                    isSeparate = NO;
                }
                else{
                    //titleString = @"duan";
                    self.separateTitleString = [searchString stringByMatching:@"\\b.{0,19}" inRange:NSMakeRange(tmpLocation,tmpLength) ];
                    {
//                        if ([self.separateTitleString findSubString:@"\r\n"] == -1)
//                        {
//                            isSeparate = NO;
//                        }
//                        else
//                        {
                        
                            isSeparate = YES;//章节题目分离
//                        }
                        if (separateTitleString.length == 0) {//特殊情况，章节题目虽然有分离，但是分离前半部为空格
                            isSeparate = NO;
                        }
                    }
                }
                isNull = YES;
            }
        }
        
        
        NSNumber *loc = [NSNumber numberWithInt:matchedRange.location];
        NSNumber *len = [NSNumber numberWithInt:matchedRange.length];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];//将章节、章节题目、字符数添加到字典
        [dict setValue:[matchArray objectAtIndex:i] forKey:SpineID_STR];//
        //将章节和章节题目合并
        NSString *tittle = [matchArray objectAtIndex:i];
        tittle = [tittle  stringByReplacingOccurrencesOfString:@" " withString:@""];
        titleString = [titleString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *content = [NSString stringWithFormat:@"%@   %@",tittle,titleString];
        
        if (content != nil) {
            [dict setValue:content forKey:SpineTittle_STR];
        }
        [dict setValue:loc forKey:TEMPLOCATION];
        [dict setValue:len forKey:@"length"];
        [reArray addObject:dict]; 
        searchRange = NSMakeRange(tmpLocation,tmpLength ); //重新设定搜索范围
        [dict release]; 
        
    }
    return  [reArray autorelease];

}
- (void)sectionOutSearch:(NSString *)newString //两个buffer内的正则查找
{
//    debugLog(@"---------------%@",newString);
    NSMutableArray *data = nil ;
    NSString *tmpString = nil;
    
    if (oldString == nil ) { //第一次传递，oldString为空或者是前一次没有搜索到信息，oldSring仍然为空
        data=[self sectionInSearch:newString];
        
        if ([data count] == 0) {
            baseLocation += newString.length; //本次没有搜索到，将基址指向该字符串的最后，继续搜索
            return;
        }
        int m;
        NSMutableDictionary *tmp = nil;
        NSUInteger tmpIndex = 0;
        for (int i= 0; i < [data count]; i++) {
            
            tmp=[data objectAtIndex:i];
            NSUInteger tmpLoc = [[tmp objectForKey:TEMPLOCATION] intValue];
            NSUInteger tmpLen = [[tmp objectForKey:@"length"] intValue];
            NSUInteger sumLoc = tmpLoc +baseLocation;  //得到实际地址
            NSNumber *tmpNum = [NSNumber numberWithInt:sumLoc];
            [tmp setValue:tmpNum forKey:TEMPLOCATION];
            //locaiton 变成类的对象
            txtLocation *txtLoc = [txtLocation txtLocationWithIndex:[tmpNum intValue]];
            [tmp setValue:txtLoc forKey:SpineLocation_STR];
            m= [data count] -1;
            if (i==m) {
                baseLocation += tmpLen + tmpLoc;
                tmpIndex = tmpLen +tmpLoc;
            }
           
            //[tmp release]; 
        }
        NSUInteger tmpStringLength = newString.length - tmpIndex; //剩余字符的长度
        if (tmpStringLength >= LENGTH) { //大于默认值
            baseLocation += newString.length - LENGTH - tmpIndex; //将基址指向改字符串的默认处
            self.oldString = [newString substringFromIndex:(newString.length -LENGTH)]; 
        }
        else
        {
            self.oldString = [newString substringFromIndex:tmpIndex] ;
        }
        [chapterArray  addObjectsFromArray:data];
    }
    else
    {
        NSUInteger tmpLen = 0;
        NSUInteger tmpLoc = 0;
        NSUInteger baseIndex = 0;
        NSUInteger sumLoc = 0;
        
        tmpString = [oldString stringByAppendingString:newString];//
        if (isNull == YES) { //章节题目被分离后，取后半部的题目
            
            NSString *str = [newString stringByMatching:@"\\r\\n|\\b.{0,20}" inRange:NSMakeRange(0, 20)];
            if (![str isEqualToString:@"\r\n"]) {
                str = [str stringByReplacingOccurrencesOfRegex:@"\\)\\]" withString:@""];
                if (isSeparate ) {
//                    NSMutableDictionary *dic = [chapterArray lastObject];
//                    NSString *tmpString = [dic objectForKey:SpineID_STR];
//                    NSString *str = [dic objectForKey:SpineTittle_STR];
                    if(![[separateTitleString substringWithRange:NSMakeRange(separateTitleString.length-1, 1)] isEqualToString:@"\r\n"])
                  {
                    str = [separateTitleString stringByAppendingString:str];
                  }
                }
                
                NSUInteger index = [chapterArray count];
                NSMutableDictionary *dic = [chapterArray objectAtIndex:index-1];
                [dic setValue:str forKey:SpineTittle_STR];
                
                [chapterArray insertObject:dic atIndex:[chapterArray count]-1];
                [chapterArray removeLastObject];
                
                isSeparate = NO;
            }
            isNull = NO;
           
            
        }
        data = [self sectionInSearch:tmpString];//组成一个新的字符串进行正则搜索
        int m;
        for (int i= 0; i < [data count]; i++) {
            
            NSMutableDictionary *tmp = nil;
            tmp=[data objectAtIndex:i];
            tmpLoc = [[tmp objectForKey:TEMPLOCATION] intValue];
            tmpLen = [[tmp objectForKey:@"length"] intValue];
            sumLoc = tmpLoc +baseLocation;
            NSNumber *tmpNum = [NSNumber numberWithInt:sumLoc];
            [tmp setValue:tmpNum forKey:TEMPLOCATION];
            //locaiton 变成类的对象
            txtLocation *txtLoc = [txtLocation txtLocationWithIndex:[tmpNum intValue]];
            [tmp setValue:txtLoc forKey:SpineLocation_STR];
            m= [data count] -1;
            if (i == m) {
                baseIndex = tmpLoc + tmpLen ;
            }
            
            //[tmp release]; 
        }
        //正则搜索后最多取字符串的后五十个字符赋值给旧字符串
        
        NSUInteger l = tmpString.length - baseIndex;
        
        if (l >= LENGTH) {
            baseIndex = tmpString.length - LENGTH;
            baseLocation = baseLocation +baseIndex;            
        }
        else {
            baseLocation = sumLoc + tmpLen;
        }    
        [chapterArray addObjectsFromArray:data];
        
        if (tmpString.length >= baseIndex)
        {
            self.oldString = [tmpString substringFromIndex:baseIndex];
        }
    }  
    
}
/* //每行解析 暂不使用
- (void)searchRegx:(NSString *)searchString
{
//    debugLog(@"---------->%@",searchString);
    
    NSMutableArray *reArray = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0, searchString.length);
    
    NSString *regexString = @"\\b第(\\s*\\w\\s*){1,5}回\\b|\\b第\\s*\\w{1,8}\\s*章|\\b第\\s*\\w{1,8}\\s*卷\\b|\\b第\\s*\\w{1,8}\\s*篇\\b|\\b第(\\s*\\w\\s*){1,5}节|\\bchapter\\s*\\d\\b|\\bsection\\s*\\d\\b";
    
    NSArray  *matchArray   = nil;  
    matchArray = [searchString componentsMatchedByRegex:regexString]; 
    NSRange matchedRange ;
    NSString *titleString =nil;
    
    for (int i= 0; i< [matchArray count]; i++) {
        
        matchedRange = [searchString rangeOfRegex:regexString inRange:searchRange];
        
        NSUInteger tmpLocation = matchedRange.location + matchedRange.length;
        NSUInteger tmpLength = searchString.length - tmpLocation;
        if (tmpLength < TITLELENGTH) { 
            
            titleString = [searchString substringFromIndex:tmpLocation];
            
        }
        else{
            NSRange range = NSMakeRange(tmpLocation, TITLELENGTH);
            titleString = [searchString substringWithRange:range];
        }
        
        
        NSNumber *loc = [NSNumber numberWithInt:matchedRange.location + baseLocation];
        NSNumber *len = [NSNumber numberWithInt:matchedRange.length];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];//将章节、章节题目、字符数添加到字典
        [dict setValue:[matchArray objectAtIndex:i] forKey:@"name"];
        if(titleString!=nil)
        {
            [dict setValue:titleString forKey:@"title"];
        }
         [dict setValue:loc forKey:TEMPLOCATION];
        [dict setValue:len forKey:@"length"];
        [reArray addObject:dict]; 
        searchRange = NSMakeRange(tmpLocation,tmpLength ); //重新设定搜索范围
        [dict release]; 
        
    }
    
    baseLocation += searchString.length; 
    [chapterArray addObjectsFromArray:reArray];
    [reArray autorelease];
    
}*/
- (void)dealloc
{
    
    
//    debugLog(@"%@",chapterArray);
    [chapterArray release];
//    debugLog(@"%@",oldString);
    [oldString release];
    
    [separateTitleString release];
    [super dealloc];
    
}

@end
