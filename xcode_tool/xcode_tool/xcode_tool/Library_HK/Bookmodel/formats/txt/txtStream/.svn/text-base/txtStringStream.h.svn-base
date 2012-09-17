//
//  txtString.h
//  docinBookReader
//
//  Created by  on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BufferStream <NSObject>

- (id)initWithFileName:(NSString*)fileName;

- (NSString*)readForwardFromCurse:(int*)curseIndex limitLength:(int)limitLength;
- (NSString*)readBackwardFromCurse:(int*)curseIndex limitLength:(int)limitLength;

- (int)findCurseWithStartCurse:(int)startCurse CharactorIndex:(int)chIndex LimitLength:(int)limitLength;

//获取txt文档的编码格式
- (NSStringEncoding)encoding;

- (int)fileLength;

@end

@interface txtStringStream : NSObject
{
    id<BufferStream> txtbufer;
    NSMutableArray* spineArray;
    NSString* cachStr;
    
    int curse;
    int totalCharacters;
    
    NSString* tempStr;
    int       tempStrIndex;
    NSString* fileName;
    
    NSMutableDictionary* chIndexToCurse;
}

@property (nonatomic, retain)NSMutableArray* spineArray;
@property (nonatomic, retain)NSString* tempStr;
@property (nonatomic, readonly)int totalCharacters;

- (id)initWithFileName:(NSString*)fileName;
- (void)strReset;
- (NSString*)readFileFromCurrentCurseByCreatingSpine;
- (NSString*)readForwardFromCharactorIndex:(int)charactorIndex limitCharNum:(int) chNumber;
- (NSString*)readForwardFromCharactorIndex:(int)charactorIndex;
- (NSString*)readBackwardFromCharactorIndex:(int)charactorIndex limitCharNum:(int) chNumber;
- (NSString*)readBackwardFromCharactorIndex:(int)charactorIndex;
- (int)setCurseWithCharactorIndex:(int)characterIndex;

@end
