//
//  NSString ++.h
//  DocinBookiPad
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 Docin Ltd. All rights reserved.
//

@interface NSString (CFString)

- (CFStringRef) CFString;
@end

@implementation NSString (CFString)

- (CFStringRef) CFString
{
    CFStringRef cfStr = CFStringCreateWithCString(NULL, [self cStringUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8);
    return (CFStringRef)[(id)cfStr autorelease];

}

@end

@interface NSString (find)

- (int) findSubString:(NSString*)subString;
- (int) rFindSubString:(NSString*)subString;

@end

@implementation NSString (find)

- (int) findSubString:(NSString*)subString
{
    return [self rangeOfString:subString].location;
}
- (int) rFindSubString:(NSString*)subString
{
    return [self rangeOfString:subString options:NSBackwardsSearch].location;
}

@end

#pragma mark-
#pragma mark --- seperator finder---
@implementation NSString (fingFirstSeperator)
//顺序查找分隔符，
- (int) fingFirstSeperatorIndex
{ 
    NSString* str = self;
    NSArray *seperatorArray = [NSArray arrayWithObjects:@"\r",@"\n",@"(",@")",@"…",@"、",@"，",@",",@"。",@".",@"；",@";",@"！",@"!",@"？",@"?",@":",@"：",@"\"",@"”",@"．",@"\t",@"\u3000", nil];
    NSSet* set = [NSSet setWithArray:seperatorArray];
    NSArray *numberArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".", nil];
    NSSet* numberSet = [NSSet setWithArray:numberArray];
    
    int index = -1;
    NSRange range;
    for(int i=0;i<[str length];i++)
    {
        range = NSMakeRange(i, 1);
        NSString* character = [str substringWithRange:range];
        if([set containsObject:character])
        {
            //对于. : 的特殊处理 start
            if (([character isEqualToString:@"."] || [character isEqualToString:@":"])
                && (i + 1) < [str length] - 1) 
            {
                //判断此分隔符算不算小数点 start
                BOOL isDot = NO;
                NSString* number = [str substringWithRange:NSMakeRange(i+1, 1)];
                if ([numberSet containsObject:number]) 
                {
                    isDot = YES;
                    index = i;
                    break;
                }
                
                if (isDot)
                {
                    continue;
                }
                //判断此分隔符算不算小数点 end
            }
            //对于.的特殊处理 end
            
            
            index = i;
            return index;
        }
    }
    return index;
}

- (int) rFindLastSeperatorIndex
{
    NSString* str = self;
    NSArray *seperatorArray = [NSArray arrayWithObjects:@"\r",@"\n",@"(",@")",@"…",@"、",@"，",@",",@"。",@".",@"；",@";",@"！",@"!",@"？",@"?",@":",@"：",@"\"",@"”",@"．",@"\t",@"\u3000", nil];
    
    NSSet* set = [NSSet setWithArray:seperatorArray];
    
    int index = -1;
    NSRange range;
    for(int i=[str length] - 1;i>=0;i--)
    {
        range = NSMakeRange(i, 1);
        NSString* character = [str substringWithRange:range];
        if ([set containsObject:character])
        {
            index = i;
            break;
        }
    }
    return index;
}

- (NSString*) splitStrContainSeperator
{
    NSString* str = self;
    NSString* retStr;
    if (!str || [str length] == 0)
    {
        return nil;
    }
    
    int sepIndex = -1;
    
    sepIndex = [[str substringFromIndex:1] fingFirstSeperatorIndex];
    
    //如果没有找到
    if (sepIndex == -1)
    {
        return nil;
    }
    else
    {
        sepIndex += 2;
        //第一个加一指判断分隔符时是从第2个开始判断的。
        //第二个加一指要把这个分隔符包含进去
        //第三个加一指如果这个是一个说话结尾的话，要把分隔符后的引号也加进去
        if (sepIndex < [str length])
        {
            for (int i = sepIndex; i < [str length]; i++)
            {
                NSString* tempStr = [str substringWithRange:NSMakeRange(i,1)];
                int index = [tempStr fingFirstSeperatorIndex];
                if ([tempStr isEqualToString:@"\""] 
                    || [tempStr isEqualToString:@" "]
                    || index == 0)
                {
                    sepIndex += 1;
                }
                else
                {
                    break;
                }
            }
        }
        retStr = [str substringToIndex:sepIndex];
    }
    return retStr;
}
@end

@interface NSString (visible)
- (BOOL) isVisible;
@end

@implementation NSString (visible)

- (BOOL) isVisible
{
    BOOL isVisible = NO;
    for (int i=0; i<[self length]; i++)
    {
        unichar ch = [self characterAtIndex:i];
        //12288 是 e38080 
        if (ch > 31 && ch !=127 && ch != 12288)
        {
            isVisible = YES;
            break;
        }
    }
    return isVisible;
}

@end

@interface NSString (isEndWithBreakEnd)
- (BOOL) isEndWithBreakEnd;
@end

@implementation NSString (isEndWithBreakEnd)

- (BOOL) isEndWithBreakEnd
{
    BOOL isEndWithBreakEnd = NO;
    
    if ([self length])
    {
        unichar ch = [self characterAtIndex:[self length] - 1];
        if (ch == '\n' || ch == '\r' || ch == '\0')
        {
            isEndWithBreakEnd = YES;
        }
    }
    
    return isEndWithBreakEnd;
}

@end

