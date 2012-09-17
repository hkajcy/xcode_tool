//
//  txtString.m
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtStringStream.h"
#import "txtBufferStream.h"
#import "UMDBufferStream.h"
#import <CoreText/CoreText.h>
#import "macros_for_IOS_hk.h"

@interface txtStringStream()
- (void)setCharactorIndex:(int)charactorIndex AndCurse:(int)tempCurse;
@end

@implementation txtStringStream
@synthesize totalCharacters;
@synthesize tempStr;

- (BOOL)isUnicode:(NSStringEncoding)encoding
{
    if (NSUnicodeStringEncoding == encoding
        || NSUTF16BigEndianStringEncoding == encoding
        || NSUTF16LittleEndianStringEncoding == encoding)
        return YES;
    else
        return NO;
}

- (void)createSpine
{
    int aCurse = 0;
    NSAutoreleasePool* mainPool = [[NSAutoreleasePool alloc] init];
    NSAutoreleasePool* pool = nil;
    
    txtBufferStream* aTxtbufer = [[txtBufferStream alloc] initWithFileName:fileName];
    while (1)
    {
        pool = [[NSAutoreleasePool alloc] init];
        NSString* str = [aTxtbufer readForwardFromCurse:&aCurse withLength:BUFFER_SIZE * 10];
        
        if (!str)
        {
            break;
        }
        
        totalCharacters += [str length];
        NSNumber* chNumber = [NSNumber numberWithInt:totalCharacters];
        NSNumber* curNumber = [NSNumber numberWithInt:aCurse];
        NSDictionary* dic = [[[NSDictionary alloc] initWithObjectsAndKeys:chNumber,@"charactorIndex",curNumber,@"curseIndex", nil] autorelease];
        [spineArray addObject:dic];
        
        SAFE_RELEASE(pool);
    }
    
    SAFE_RELEASE(pool);
    
    [aTxtbufer release];
    SAFE_RELEASE(mainPool)
}

- (id)initWithFileName:(NSString *)filename
{
    self = [super init];
    if (self) {
        // Initialization code here.
        fileName = filename;
        
        if ([[[fileName pathExtension] uppercaseString] isEqualToString:@"TXT"])
        {
            txtbufer = [[txtBufferStream alloc] initWithFileName:fileName];
        }
        else if ([[[fileName pathExtension] uppercaseString] isEqualToString:@"UMD"])
        {
            txtbufer = [[UMDBufferStream alloc] initWithFileName:fileName];
        }
        else
        {
            assert(0);
        }
        
        
        curse = 0;
        totalCharacters = 0;
        
        chIndexToCurse = [[NSMutableDictionary alloc] init];
        spineArray = [[NSMutableArray alloc] initWithCapacity:0];
        tempStr = [[NSString alloc] init];
        tempStrIndex = 0;
    }
    
    return self;
}

- (void)setSpineArray:(NSMutableArray *)_spineArray
{
    if (_spineArray && [_spineArray count])
    {
        if (spineArray != _spineArray)
        {
            [spineArray release];
        }
        [_spineArray retain];
        spineArray = _spineArray;
        totalCharacters = [[[spineArray lastObject] objectForKey:@"charactorIndex"] intValue];
        assert(totalCharacters > 0);
    }
    else
    {
        if (![self isUnicode:[txtbufer encoding]]) 
        {
            START_TIMER
            [self createSpine];
            END_TIMER(@"createSpine")
        }
        else
        {
            [self setCurseWithCharactorIndex:0];
        }
    }
}

- (NSMutableArray*)spineArray
{
    return spineArray;
}

- (void)strReset
{
    curse = 0;
}

- (void)findCurseAndCharacterIndex:(int)characterIndex
                      CurrentIndex:(int*)currentIndex
                        limitCurse:(int*)limitCurse;
{
    NSAutoreleasePool* pool = nil;
    curse = -1;
    *currentIndex = -1;
    for (int index = 0; index < [spineArray count]; index++) 
    {
        pool = [[NSAutoreleasePool alloc] init];
        int chIndex = 0;
        NSDictionary* chDic = (NSDictionary*)[spineArray objectAtIndex:index];
        chIndex = [(NSNumber*)[chDic objectForKey:@"charactorIndex"] intValue];
        *limitCurse = [[(NSDictionary*)[spineArray objectAtIndex:index] objectForKey:@"curseIndex"] intValue];
        
        if(characterIndex < chIndex)
        {
            if (index == 0) 
            {
                curse = 0;
                *currentIndex = characterIndex;
                break;
            }
            else
            {
                curse = [[(NSDictionary*)[spineArray objectAtIndex:index-1] objectForKey:@"curseIndex"] intValue];
                *currentIndex = characterIndex - [[(NSDictionary*)[spineArray objectAtIndex:index-1] objectForKey:@"charactorIndex"] intValue];
                break;
            }
        }
        SAFE_RELEASE(pool);
    }
    
    SAFE_RELEASE(pool);
}

- (int)setCurseWithCharactorIndex:(int)characterIndex
{
    //判断是否存有存档，这样就不用查找了。 开始
    NSNumber* chIndex = nil;
    chIndex = [chIndexToCurse objectForKey:[NSNumber numberWithInt:characterIndex]];
    
    if (chIndex)
    {
        curse = [chIndex intValue];
        return curse;
    }
    //判断是否存有存档，这样就不用查找了。 结束
    
    if (![self isUnicode:[txtbufer encoding]])
    {
        int currentIndex = -1;
        int limitCurse = -1;
        [self findCurseAndCharacterIndex:characterIndex CurrentIndex:&currentIndex limitCurse:&limitCurse];
        
        
        if (limitCurse == -1)
        {
            limitCurse = txtbufer.fileLength;
        }
        
        int limitLength = limitCurse - curse;
        
        //这表示没有找到
        if (currentIndex == -1)
        {
            curse = txtbufer.fileLength;
        }
        else if (currentIndex != 0)
        {
            curse = [txtbufer findCurseWithStartCurse:curse CharactorIndex:currentIndex LimitLength:limitLength];
        }
    }
    else
    {
        curse = 0;
        curse = [txtbufer findCurseWithStartCurse:curse CharactorIndex:1 LimitLength:4];
        if (curse == 2)
        {
            curse = characterIndex * 2 ;
            totalCharacters = [txtbufer fileLength]/2;
        }
        else
        {
            assert(curse == 4);
            curse = characterIndex * 2 + 2; 
            totalCharacters = [txtbufer fileLength]/2 - 1;
        }
    }
    
    [self setCharactorIndex:characterIndex AndCurse:curse];
    return curse;
}

//设置光标到从此位置到上一个段落的开始
- (int)setCurseToLastTabWithCharactorIndex:(int)index
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [self setCurseWithCharactorIndex:index];
    
    NSString* str = [txtbufer readForwardFromCurse:&curse limitLength:2000];
    int retIndex = -[str length];
    
    [self setCurseWithCharactorIndex:index + retIndex];
    
    [pool release];
    
    return retIndex;
}

- (NSString*)readFileFromCurrentCurseByCreatingSpine
{
    NSString* str = [txtbufer readForwardFromCurse:&curse limitLength:2000];
    return str;
}

- (NSString*)getString:(int)charactorIndex Direction:(int)dir limitCharNum:(int)chNumber
{
    assert(dir != 0);
    
    int len = [tempStr length];
    len = len;
    if (dir > 0)
    {
        if (charactorIndex >= tempStrIndex && charactorIndex < tempStrIndex + [tempStr length])
        {
            chNumber = [tempStr length] - (charactorIndex - tempStrIndex) > chNumber ? 
            chNumber : [tempStr length] - (charactorIndex - tempStrIndex);
            NSString* str = [tempStr substringWithRange:NSMakeRange(charactorIndex - tempStrIndex, chNumber)];
            return str;
        }
    }
    else
    {
        if (charactorIndex >= tempStrIndex && charactorIndex <= tempStrIndex + [tempStr length])
        {
            chNumber = charactorIndex - tempStrIndex > chNumber ? chNumber : charactorIndex - tempStrIndex;
            NSString* str = [tempStr substringWithRange:NSMakeRange(charactorIndex - tempStrIndex - chNumber, chNumber)];
            
            int len = [str length];
            assert(len <= charactorIndex);
            return str;
        }
    }
    
    return nil;
}

- (void)setCharactorIndex:(int)charactorIndex AndCurse:(int)tempCurse
{
    NSNumber* charactorIndexNumber = [NSNumber numberWithInt:charactorIndex];
    
    NSNumber* tempCuseNumber = [NSNumber numberWithInt:tempCurse];
    
    [chIndexToCurse setValue:tempCuseNumber forKey:(id)charactorIndexNumber];
}

- (NSString*)readForwardFromCharactorIndex:(int)charactorIndex
{
    return [self readForwardFromCharactorIndex:charactorIndex limitCharNum:200];
}

- (NSString*)readForwardFromCharactorIndex:(int)charactorIndex limitCharNum:(int) chNumber
{
    if (charactorIndex < 0) 
    {
        assert(charactorIndex > 0);
    }
    
    if (charactorIndex == NSNotFound)
    {
        return nil;
    }
    
    @synchronized (self)
    {
        int length = [tempStr length];
        int lastIndex = tempStrIndex + length;
        lastIndex = lastIndex;
        //判断此Index是否在这个tempStr内
        if (charactorIndex >= tempStrIndex  //大于或者小于左边界
            && charactorIndex < tempStrIndex + length)//小于右边界
        {
            //没有足够多的字符
            if ([tempStr length] - (charactorIndex - tempStrIndex) < chNumber ) 
            {
                int inValideLength = charactorIndex - tempStrIndex;
                int limitLength = chNumber - ([self.tempStr length] - inValideLength) + 20;//这个20是我多取一点，做个缓冲
                NSAssert(limitLength > 0,@"");
                NSString* str = [tempStr substringFromIndex:(charactorIndex - tempStrIndex)/2];
                
                [self setCurseWithCharactorIndex:tempStrIndex + [tempStr length]];
                tempStrIndex += [tempStr length] - [str length];
                assert(tempStrIndex >= 0 && tempStrIndex < [self totalCharacters]);
                
                NSString* readStr = [txtbufer readForwardFromCurse:&curse limitLength:limitLength];
                if (readStr)
                {
                    [self setCharactorIndex:tempStrIndex + [tempStr length] + [readStr length] AndCurse:curse];
                    assert(readStr);
                    str = [str stringByAppendingString:readStr];
                }
                
                self.tempStr = str;
                
            }
            return [self getString:charactorIndex
                         Direction:1
                      limitCharNum:chNumber];
        }
        else
        {
            [self setCurseWithCharactorIndex:charactorIndex];
            self.tempStr = [txtbufer readForwardFromCurse:&curse limitLength:chNumber];
            [self setCharactorIndex:charactorIndex + [tempStr length] AndCurse:curse];
            tempStrIndex = charactorIndex;
            NSAssert(tempStrIndex >= 0, nil);
            NSAssert(tempStrIndex <= [self totalCharacters], nil);
//            Debugger();
            return [self getString:charactorIndex
                         Direction:1
                      limitCharNum:chNumber];
            
        }
    }
}

- (NSString*)readBackwardFromCharactorIndex:(int)charactorIndex 
{
    return [self readBackwardFromCharactorIndex:charactorIndex limitCharNum:200];
}

- (NSString*)readBackwardFromCharactorIndex:(int)charactorIndex limitCharNum:(int) chNumber
{

    if (charactorIndex < 0) 
    {
        NSAssert(charactorIndex > 0,@"");
    }
    
    if (charactorIndex == NSNotFound)
    {
        return nil;
    }
    
    @synchronized (self)
    {
        if (charactorIndex > tempStrIndex && charactorIndex <= tempStrIndex + [tempStr length])
        {
            //没有足够多的字符
            if (charactorIndex - tempStrIndex < chNumber && charactorIndex - tempStrIndex > 0) 
            {
                NSString* str = [tempStr substringToIndex:charactorIndex - tempStrIndex];
                
                [self setCurseWithCharactorIndex:tempStrIndex];
                
                int inValideLength = [tempStr length] - (charactorIndex - tempStrIndex);
                
                int limitLength = chNumber - ([self.tempStr length] - inValideLength) + 20;//这个20是我多取一点，做个缓冲
                assert(limitLength > 0);
                NSString* readStr = [txtbufer readBackwardFromCurse:&curse limitLength:limitLength];
                if (readStr)
                {
                    assert(str);
                    self.tempStr = [readStr stringByAppendingString:str];
                    tempStrIndex -= [tempStr length] - [str length];
                    [self setCharactorIndex:tempStrIndex AndCurse:curse];
                    assert(tempStrIndex >= 0);
                    assert( tempStrIndex <= [self totalCharacters]);
                }
            }
            
            return [self getString:charactorIndex
                         Direction:-1
                      limitCharNum:chNumber];
            
        }
        else
        {
            [self setCurseWithCharactorIndex:charactorIndex];
            self.tempStr = [txtbufer readBackwardFromCurse:&curse limitLength:chNumber];
            tempStrIndex = charactorIndex - [tempStr length];
            [self setCharactorIndex:tempStrIndex AndCurse:curse];
            
            if (!(tempStrIndex >= 0 && tempStrIndex < [self totalCharacters])) 
            {
                assert(tempStrIndex >= 0);
                assert( tempStrIndex <= [self totalCharacters]);
            }
            
            assert(charactorIndex == tempStrIndex + [tempStr length]);
            return [self getString:charactorIndex
                         Direction:-1
                      limitCharNum:chNumber];
            
        }

    }
}

- (void)dealloc
{
    SAFE_RELEASE(spineArray);
    SAFE_RELEASE(txtbufer);
    SAFE_RELEASE(tempStr);
    SAFE_RELEASE(chIndexToCurse)
    [super dealloc];
}
@end
