//
//  txtRow.m
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtRowStream.h"
#import "txtStringStream.h"
#import <CoreText/CoreText.h>
#import "macros_for_IOS_hk.h"

@implementation txtRowStream
@synthesize string;
@synthesize font;
@synthesize width;
@synthesize rowCach;

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        rowCach = [[NSMutableArray alloc] initWithCapacity:0];
        firstRowIndex = 0;
        originaCharactorIndex = 0;
        firstCharactorIndex = 0;
        lastCharactorIndex = 0;
        
        string = [[txtStringStream alloc] initWithFileName:fileName];
        assert(string);
    }
    
    return self;
}

- (void)rowReset
{
    [rowCach removeAllObjects];
    [string strReset];
}

- (void)setCharactorIndex:(int)index
{
    if (index < 0)
    {
        index = 0;
    }
    
    [self rowReset];
    firstRowIndex = 0;
    originaCharactorIndex = index;
    firstCharactorIndex = index;
    lastCharactorIndex = index;
}

- (NSMutableArray*)stringToRowsBackward:(NSString*)str
                      startIndex:(int)start
                  needLastString:(bool)needLastString
{
    assert(start >= 0);//Start不允许大于0
    
    NSMutableArray* rowArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    int lastIndex = 0;
    NSString* rowString = nil;
    NSNumber* startIndex = nil;
    NSNumber* endIndex = nil;
    int chNumberInOneRow = 0;
    
    for (int i=0; i<[str length];)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        NSString* subString = [str substringWithRange:NSMakeRange(lastIndex, i-lastIndex)];
        int drawWidth = [subString sizeWithFont:font].width;
        if(drawWidth >= width)
        {
            for (int i=[subString length]-1; i>=0; i--)
            {
                rowString = [str substringToIndex:i];
                int drawWidth = [rowString sizeWithFont:font].width;
                if ((drawWidth < width)) 
                    break;
            }
            
            chNumberInOneRow = MAX(chNumberInOneRow, [subString length]);
            int startIndexInstr = lastIndex;
            int endIndexInstr = i-(drawWidth != width);
            int length = endIndexInstr - startIndexInstr;
            
            startIndex = [NSNumber numberWithInt:startIndexInstr + start];
            endIndex = [NSNumber numberWithInt:endIndexInstr + start];
            rowString = [str substringWithRange:NSMakeRange(startIndexInstr, length)];
            NSDictionary* txtDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                     startIndex,@"startIndex",endIndex,@"endIndex",rowString,@"title", nil] autorelease];
            [rowArray addObject:txtDic];
            lastIndex = endIndexInstr;
            i += chNumberInOneRow;
        }
        else
        {
            i++;
        }
        SAFE_RELEASE(pool);
    } 
    
    if ( (lastIndex < [str length] && needLastString )
        || ![rowArray count])
    {
        
        startIndex = [NSNumber numberWithInt:lastIndex + start];
        endIndex = [NSNumber numberWithInt:[str length] + start];
        rowString = [str substringFromIndex:lastIndex];
        NSDictionary* txtDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                 startIndex,@"startIndex",endIndex,@"endIndex",rowString,@"title", nil] autorelease];
        [rowArray addObject:txtDic];
    }
    
    return rowArray;
}

- (NSMutableArray*)separaterStringToRowsForward:(NSString*)str 
                            startIndex:(int)start
                        needLastString:(bool)needLastString
{
    NSMutableArray* rowArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSString* rowString = nil;
    NSNumber* startIndex = nil;
    NSNumber* endIndex = nil;
    int startIndexInstr = 0;
    int endIndexInstr = 0;
    NSString* tStr = [str substringFromIndex:startIndexInstr];
    
    while ([tStr length])
    {
        NSMutableAttributedString* attStr = [[[NSMutableAttributedString alloc] initWithString:tStr] autorelease];
        
        CTFontRef fontRef = CTFontCreateWithName(CFSTR("Helvetica"), font.pointSize, NULL);
        [attStr addAttribute:(NSString*)kCTFontAttributeName value:(id)fontRef range:NSMakeRange(0, [attStr length])];
        CFRelease(fontRef);
        
        CTParagraphStyleSetting settings;
        CTTextAlignment alignment;
        settings.spec = kCTParagraphStyleSpecifierAlignment;
        settings.valueSize = sizeof(CTTextAlignment);
        
        //alignment = kCTLeftTextAlignment;
        alignment = kCTJustifiedTextAlignment;
        //alignment = kCTNaturalTextAlignment;
        settings.value = &alignment;
        
        CTParagraphStyleRef style = CTParagraphStyleCreate((const CTParagraphStyleSetting*) &settings, 1);
        [attStr addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0, [attStr length])];
        CFRelease(style);
        
        CTLineRef lineRef =  CTLineCreateWithAttributedString((CFAttributedStringRef)attStr);
        int strOffset = CTLineGetStringIndexForPosition(lineRef, CGPointMake(width, 0));
        CFRelease(lineRef);
            
        endIndexInstr += strOffset;
        startIndex = [NSNumber numberWithInt:startIndexInstr + start];
        endIndex = [NSNumber numberWithInt:endIndexInstr + start];
        rowString = [str substringWithRange:NSMakeRange(startIndexInstr, strOffset)];
        NSDictionary* txtDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                 startIndex,@"startIndex",endIndex,@"endIndex",rowString,@"title", nil] autorelease];
        [rowArray addObject:txtDic];
        startIndexInstr += strOffset;
        
        tStr = [str substringFromIndex:startIndexInstr];
    }
    
    if (!needLastString)
    {
        if ([rowArray count] > 1)
        {
            [rowArray removeLastObject];
        }
    }
    
    return rowArray;
}
- (NSMutableArray*)stringToRowsForward:(NSString*)str 
                     startIndex:(int)start
                 needLastString:(bool)needLastString
//{
//    NSMutableArray* rowArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
//    while (str)
//    {
//        NSRange rRange = [str rangeOfString:@"\r"];
//        NSRange nRange = [str rangeOfString:@"\n"];
//        
//        NSRange rnRange = [str rangeOfString:@"\r\n"];
//        NSRange nrRange = [str rangeOfString:@"\n\r"];
//        
//        int separaterIndex = 0;
//        
//        BOOL needLast = rRange.location != NSNotFound 
//        || nRange.location != NSNotFound
//        || rnRange.location != NSNotFound
//        || nrRange.location != NSNotFound;
//        
//        if (needLast)
//        {
//            if (rRange.location < nRange.location)
//            {
//                if (rRange.location < rnRange.location)
//                {
//                    separaterIndex = rRange.location + 1;
//                }
//                else
//                {
//                    separaterIndex = rnRange.location + 2;
//                }
//            }
//            else
//            {
//                if (nRange.location < nrRange.location)
//                {
//                    separaterIndex = nRange.location + 1;
//                }
//                else
//                {
//                    separaterIndex = nrRange.location + 2;
//                }
//            }
//        }
//        
//        
//        NSString* tStr;
//        
//        if (separaterIndex == 0)
//        {
//            tStr = str;
//        }
//        else
//        {
//            tStr = [str substringToIndex:separaterIndex];
//        }
//        
//        [rowArray addObjectsFromArray:[self separaterStringToRowsForward:tStr
//                                                              startIndex:start
//                                                          needLastString:needLast || needLastString]];
//        
//        start += [tStr length];
//        
//        if (separaterIndex == 0)
//        {
//            str = nil;
//        }
//        else
//            str = [str substringFromIndex:separaterIndex];
//    }
//    
//    
//    
//    return rowArray;
//}
{
    assert(start >= 0);//Start不允许大于0
    
    NSMutableArray* rowArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    int lastIndex = 0;
    NSString* rowString = nil;
    NSNumber* startIndex = nil;
    NSNumber* endIndex = nil;
    int chNumberInOneRow = 0;
    
    for (int i=0; i<[str length];++i)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        unichar ch_0, ch_1, ch_2;
        
        if (i != 0)
        {
            ch_0 = [str characterAtIndex:i-1];
        }
        
        ch_1 = [str characterAtIndex:i];

        if (i < [str length] - 1)
        {
            ch_2 = [str characterAtIndex:i+1];
        }
        
        isOnlyReback = NO;
        if (ch_1 == '\r' && ch_0 != '\n' && ch_2 != '\n')
        {
            isOnlyReback = YES;
        }
        
        
        BOOL needBreakRow = NO;
        if (isOnlyReback)
        {
            if (ch_1 == '\r')
            {
                needBreakRow = YES;
            }
        }
        else
        {
            if (ch_1 == '\n')
            {
                needBreakRow = YES;
            }
        }
        
        if (needBreakRow)
        {
            int startIndexInstr = lastIndex;
            int endIndexInstr = i + 1;
            int length = endIndexInstr - startIndexInstr;
            
            startIndex = [NSNumber numberWithInt:startIndexInstr + start];
            endIndex = [NSNumber numberWithInt:endIndexInstr + start];
            rowString = [str substringWithRange:NSMakeRange(startIndexInstr, length)];
            NSDictionary* txtDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                     startIndex,@"startIndex",endIndex,@"endIndex",rowString,@"title", nil] autorelease];
            [rowArray addObject:txtDic];
            lastIndex = endIndexInstr;
        }
        else
        {
            NSString* subString = [str substringWithRange:NSMakeRange(lastIndex, i-lastIndex)];
            int drawWidth = [subString sizeWithFont:font].width;
            if(drawWidth >= width)
            {
                chNumberInOneRow = MAX(chNumberInOneRow, [subString length]);
                int startIndexInstr = lastIndex;
                int endIndexInstr = i-(drawWidth != width);
                int length = endIndexInstr - startIndexInstr;
                
                startIndex = [NSNumber numberWithInt:startIndexInstr + start];
                endIndex = [NSNumber numberWithInt:endIndexInstr + start];
                rowString = [str substringWithRange:NSMakeRange(startIndexInstr, length)];
                NSDictionary* txtDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                         startIndex,@"startIndex",endIndex,@"endIndex",rowString,@"title", nil] autorelease];
                [rowArray addObject:txtDic];
                lastIndex = endIndexInstr;
            }
        }
        SAFE_RELEASE(pool);
    } 
    
    if ( (lastIndex < [str length] && needLastString )
        || ![rowArray count])
    {
        
        startIndex = [NSNumber numberWithInt:lastIndex + start];
        endIndex = [NSNumber numberWithInt:[str length] + start];
        rowString = [str substringFromIndex:lastIndex];
        NSDictionary* txtDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                 startIndex,@"startIndex",endIndex,@"endIndex",rowString,@"title", nil] autorelease];
        [rowArray addObject:txtDic];
    }
    
    return rowArray;
}

- (void)minilizeRowCach:(NSRange)range withDirection:(int)dir
{
    int cachRows = range.length * 3;
    int location = range.location;
    
    //把左侧的去掉
    int leftCut = location - firstRowIndex - cachRows;
    if (leftCut > 0 && dir > 0)
    {
        [rowCach removeObjectsInRange:NSMakeRange(0, leftCut)];
        firstRowIndex += leftCut;
        firstCharactorIndex = [[[rowCach objectAtIndex:0] objectForKey:@"startIndex"] intValue];
    }
    
    //把右侧的去掉
    int rightCut = firstRowIndex + (int)[rowCach count] - ((int)range.location + (int)range.length + cachRows) ;
    if (rightCut > 0 && dir < 0)
    { 
        [rowCach removeObjectsInRange:NSMakeRange(rightCut, [rowCach count] - rightCut)];
        lastCharactorIndex = [[[rowCach lastObject] objectForKey:@"endIndex"] intValue];
    }
    
}

- (NSArray*)cludeRows:(NSRange)range withDirection:(int)dir
{
    NSArray* subArray  = nil;
    
    int location = (int)range.location;
    int length = (int)range.length;
    int index = location - firstRowIndex;
    
    if (index > (int)[rowCach count])
    {
        return nil;
    }
    
    if (index < 0)
    {
        if (index + length > 0)
        {
            return [self rowsWithRange:NSMakeRange((int)range.location - index, range.length)];
        }
    }
    else
    {
        subArray = [rowCach subarrayWithRange:NSMakeRange(index, MIN((int)[rowCach count] - index, range.length))];
    }
    
    [self minilizeRowCach:range withDirection:dir];
    
    return subArray;
}

- (NSString*)backwardString
{
    // 这里也不找那么多了。。 就找一次。
    NSString* str = nil;
    NSString* tStr = [string readBackwardFromCharactorIndex:firstCharactorIndex];
    
    if (tStr && [tStr length])
    {
        firstCharactorIndex -= [tStr length];
        assert(firstCharactorIndex >= 0);
        
        if (!str)
        {
            str = tStr;
        }
        else
        {
            assert(str);
            str = [tStr stringByAppendingString:str];
        }
        
        int rIndex = [tStr rangeOfString:@"\n"].location;
        
        if (rIndex != NSNotFound && rIndex != [tStr length] - 1)
        {
            str = [str substringFromIndex:rIndex + 1];
            firstCharactorIndex += rIndex + 1;
        }
    }
    else
    {
        debugLog(@"first page");
    }
    
    return str;
}

- (NSArray*)forwardRows:(NSRange)range
{
    NSAutoreleasePool* pool = nil;
    while (1)
    {
        pool = [[NSAutoreleasePool alloc] init];
        NSString* str = [string readForwardFromCharactorIndex:lastCharactorIndex];
        
        if (str && [str length])
        {
            NSMutableArray* mArray = [self stringToRowsForward:str
                                                    startIndex:lastCharactorIndex
                                                needLastString:NO];
            
            [rowCach addObjectsFromArray:mArray];
            
            NSDictionary* dic = [rowCach lastObject];
            
            lastCharactorIndex = [[dic objectForKey:@"endIndex"] intValue];
            
            if (firstRowIndex + (int)[rowCach count] >= (int)range.location + (int)range.length)
            {
                break;
            }
        }
        else
        {
            break;
        }
        SAFE_RELEASE(pool);
    }
    SAFE_RELEASE(pool);
    return [self cludeRows:range withDirection:1];
}

- (NSArray*)backwardRows:(NSRange)range;
{
    int location = (int)range.location ;
    int length = (int)range.location  + (int)range.length;
    
    //length = length;
    
    NSAutoreleasePool* pool = nil;
    while (1)
    {
        pool = [[NSAutoreleasePool alloc] init];

        NSDate* startBackstr = [NSDate date];
        NSString* str = [self backwardString];
        NSDate* stopBackstr = [NSDate date];
        debugLog(@"backwardStr spended %fs",[stopBackstr timeIntervalSinceDate:startBackstr]);
        if (str && [str length]) 
        {
            NSDate* startStrToRow = [NSDate date];
            NSMutableArray* mArray = [self stringToRowsForward:str
                                                     startIndex:firstCharactorIndex
                                                 needLastString:YES];
            NSDate* stopStrToRow = [NSDate date];
            debugLog(@"str length = %d spended %fs toRow", [str length],[stopStrToRow timeIntervalSinceDate:startStrToRow]);
            
            firstRowIndex -= [mArray count];
            [mArray addObjectsFromArray:rowCach];
            self.rowCach = mArray;
            
            NSDictionary* dic = [rowCach objectAtIndex:0];
            firstCharactorIndex = [[dic objectForKey:@"startIndex"] intValue];
            assert(firstCharactorIndex >= 0);
            
            //只要firstRowIndex小于location就可以退出了
            if (firstRowIndex <= location)
            {
                break;
            }
        }
        else
        {
            break;
        }
        SAFE_RELEASE(pool);
    }
    
    SAFE_RELEASE(pool);
    
    if (location + length > firstRowIndex + [rowCach count])
        return [self forwardRows:range];
    else
        return [self cludeRows:range withDirection:-1];
}

- (int)checkDirection:(NSRange)range
{
    int location = (int)range.location;
    int lastLocation = (int)range.location + (int)range.length;
    if (firstRowIndex > location)
    {
        return -1;
    }
    else if (firstRowIndex + (int)[rowCach count] < lastLocation)
    {
        return +1;
    }
    else return 0;
}

- (NSArray*)rowsWithRange:(NSRange)range
{
    NSArray* retArray = nil;
    
    @synchronized (self)
    {
        //确定方向
        int dir = [self checkDirection:range];
        
        switch (dir) {
            case -1:
                retArray = [self backwardRows:range];
                break;
            case 0:
                retArray = [self cludeRows:range withDirection:0];
                break;
            case 1:
                retArray = [self forwardRows:range];
                break;
            default:
                assert(0);
                break;
        }
    }
    
    return retArray;
}


- (void)dealloc
{
    SAFE_RELEASE(string)
    SAFE_RELEASE(rowCach)
    [super dealloc];
}
@end
