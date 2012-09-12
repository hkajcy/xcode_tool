//
//  BufferTest.h
//  Test
//
//  Created by Liu Shanfeng on 11-6-8.
//  Copyright 2011 Vanceinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h> 
#import <AVFoundation/AVAudioSession.h>

#define     sythePipeNumber             (4)
#define     BYTES_PER_SAMPLE            (2)
#define     SAMPLE_RATE                 (16000)
#define     FRAME_COUNT                 (SAMPLE_RATE / 60)
#define     TEXTLENGTH                  (300)
#define     CONSTSIZE                   (12640)
#define     AUDIO_BUFFERS               (3)

#define VOICEPLAYSPEEDMAXVALUE     2.0
#define VOICEPLAYSPEEDDEFAULTVALUE 1.1
#define VOICEPLAYSPEEDMINVALUE     0.8

@protocol finishedPlaySound <NSObject>

@optional
- (void) didFinishPlaySound;
- (void) didFinishedSytheText;
- (void) didStopPlaySound;
@end

@protocol changeVoice <NSObject>

@optional
- (void) didFinishedChange;

@end


typedef unsigned short sampleFrame;

typedef struct AQCallbackStruct {
    AudioQueueRef queue;
    UInt32 frameCount;
    AudioQueueBufferRef mBuffers[AUDIO_BUFFERS];
    AudioStreamBasicDescription mDataFormat; 
    UInt32 playPtr;
    UInt32 sampleLen;
} AQCallbackStruct;

typedef struct pnWaveStruct{
    
	unsigned short *pnWav;
	int nLength;
	int isValid;
    bool sentenceOver;
	
}pnWaveStruct;

enum VoiceMode
{
    VoiceMode_Man = 1,
    VoiceMode_Woman = 0,
};

enum VoiceStyle
{
    VoiceStyle_Putonghua = 0,   //为普通话
    VoiceStyle_Yueyu,           //为粤语 
};

@class eVoiceTimer;

@interface eVoicePlayer : NSObject
<AVAudioSessionDelegate>
{
    BOOL                    isPausing;
    
    NSString*               playingStr;
    
    //声音设置
    enum VoiceMode          voiceMaleOrFamale;
    enum VoiceStyle         voiceStyle;
    float                   voiceSpeed;
    BOOL                    isBackgroundPlay;
    
    id<finishedPlaySound>   playSoundDelegate;
    id<changeVoice>         changeVoiceDelegate;
    
    int                     nWaveLen;
	int                     nHandle;
    
    volatile BOOL           isExit;   //整个线程的退出标志。
    volatile BOOL           isStopSythe;  //转换退出标志
    volatile BOOL           isStopPlaying; //播放退出标志

    volatile BOOL           isNeedProducting;
    volatile BOOL           isProductingEnd;
    volatile BOOL           isPlaying;
    
    volatile int            roundCount;
    int                     mSynNum;
    int                     mPlayNum;
    int                     mFullNum;
    
    //用来判断是否更新的数据
    int                     lastSynNum;
    NSMutableArray*         lastSynNumArray;
    int                     tottalSynNum;
    int                     tottalPlayNum;
    int                     changeVoiceNum;
    int                     enqueueCount;
    
    AQCallbackStruct*       aqc;
    pnWaveStruct*           pnWave;
    
    BOOL                    isNeedChangeVoice;
    BOOL                    isChangingVoice;
    NSCondition*            productCondition;
    NSString*               synHandle;
    
    
}

@property (nonatomic,assign) id<finishedPlaySound>   playSoundDelegate;
@property (nonatomic,assign) id<changeVoice>         changeVoiceDelegate;
@property (nonatomic,assign) enum VoiceMode          voiceMaleOrFamale;
@property (nonatomic,assign) enum VoiceStyle         voiceStyle;
@property (nonatomic,assign) float                   voiceSpeed;
@property (nonatomic,assign) BOOL                    isBackgroundPlay;
@property (nonatomic,readonly) NSMutableArray*         lastSynNumArray;
@property (nonatomic,retain) NSOperationQueue*          operationQueue;
@property (nonatomic,assign) BOOL                    isPausing;
+ (eVoicePlayer*) sharedInstance;

- (void) playText:(NSString*)txt stopOldPlay:(BOOL)stopOldPlay;
- (void) setIsBackgroundPlay:(BOOL)isBackGroundPlay;

- (void) startPlay;
- (void) pauseOrResume;
- (void) stopPlayForPlayingNewText;
- (void) stopPlay;

- (void) setVoiceModeWithManOrWoman:(int)vMode// 1 for man; 0 for woman
                     WithVoiceStyle:(int)vStyle// 0 是默认， 1 是普通话， 2 是粤语
                     WithVoiceSpeed:(float)vSpeed
                IsPlayingBackground:(BOOL)isBackGroundPlay;


@end


