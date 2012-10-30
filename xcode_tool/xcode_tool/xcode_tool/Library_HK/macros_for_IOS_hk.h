//
//  hk_maros.h
//  DocinBookiPad
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 Docin Ltd. All rights reserved.
//

#ifndef _HK_MARCROS_FOR_IOS_H_
#define _HK_MARCROS_FOR_IOS_H_

//framePointLocation
/*********************************************************************************************/
#ifndef isPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#ifndef isiPad
#define isiPad(_iPad,_iPhone)              (isPad?_iPad:_iPhone)
#endif


#ifndef kPortraitValue
#define kPortraitValue(value)                               (isiPad(k##value##_For_iPad_Portrait ,k##value##_For_iPhone_Portrait))
#endif

#ifndef kLandscapeValue
#define kLandscapeValue(value)                              (isiPad(k##value##_For_iPad_Landscape,k##value##_For_iPhone_Landscape))
#endif

// UIConstants provides contants variables for UI control.

#ifndef UI_NAVIGATION_BAR_HEIGHT
#define UI_NAVIGATION_BAR_HEIGHT    (44)
#endif

#ifndef UI_TAB_BAR_HEIGHT
#define UI_TAB_BAR_HEIGHT           (49)
#endif

#ifndef UI_STATUS_BAR_HEIGHT
#define UI_STATUS_BAR_HEIGHT        (20)
#endif

#ifndef UI_SCREEN_WIDTH
#define kUI_SCREEN_WIDTH_For_iPhone_Portrait                      (320)
#define kUI_SCREEN_WIDTH_For_iPhone_Landscape                     (460)

#define kUI_SCREEN_WIDTH_For_iPad_Portrait                        (768)
#define kUI_SCREEN_WIDTH_For_iPad_Landscape                       (1024)

#define kCurUI_SCREEN_WIDTH(orientation)                          (UIInterfaceOrientationIsPortrait(orientation) ? \
kPortraitValue(UI_SCREEN_WIDTH) : \
kLandscapeValue(UI_SCREEN_WIDTH))
#endif

#ifndef UI_SCREEN_HEIGHT
#define kUI_SCREEN_HEIGHT_For_iPhone_Portrait                      (460)
#define kUI_SCREEN_HEIGHT_For_iPhone_Landscape                     (320)

#define kUI_SCREEN_HEIGHT_For_iPad_Portrait                        (1024)
#define kUI_SCREEN_HEIGHT_For_iPad_Landscape                       (768)

#define kCurUI_SCREEN_HEIGHT(orientation)                          (UIInterfaceOrientationIsPortrait(orientation) ? \
kPortraitValue(UI_SCREEN_HEIGHT) : \
kLandscapeValue(UI_SCREEN_HEIGHT))
#endif
/*********************************************************************************************/



#ifdef DEBUG

#define debugLog(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__]);  
#define debugMethod() NSLog(@"%s", __func__);
#define debugAssert(condition)  NSAssert(condition,@"");
#else

#define debugLog(...)
#define debugMethod()
#define debugAssert(condition)  

#endif

//count time
/*********************************************************************************************/
#ifdef DEBUG

#define START_TIMER {NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];  
#define END_TIMER(msg)  NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; \
debugLog([NSString stringWithFormat:@"%@ Time = %f", msg, stop-start]);}  

#else

#define START_TIMER
#define END_TIMER(msg)  

#endif
/*********************************************************************************************/



#ifndef EMPTY_STRING
#define EMPTY_STRING        (@"")
#endif

#ifndef STR
#define STR(key)            (NSLocalizedString(key, nil))
#endif

#ifndef PATH_OF_APP_HOME
#define PATH_OF_APP_HOME    (NSHomeDirectory())
#endif

#ifndef PATH_OF_TEMP
#define PATH_OF_TEMP        (NSTemporaryDirectory())
#endif

#ifndef PATH_OF_DOCUMENT
#define PATH_OF_DOCUMENT    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#endif


/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 Usage sample:
 
 if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
 ...
 }
 
 if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
 ...
 }
 
 */

#ifndef SAFE_RELEASE
#define SAFE_RELEASE( x )   \
\
if( x )                     \
{                           \
[(id)x release];            \
x = nil;                \
}

#else

#endif

#define AUTO_RELEASED_CTREF(CTValue)  ((void*)[(id)(CTValue) autorelease])

#ifndef CFSAFE_RELEASE
#define CFSAFE_RELEASE( x )   \
\
if( x )                     \
{                           \
CFRelease(x);            \
x = nil;                \
}

#else

#endif

#ifndef DeclearValueWithOrietation
#define DeclearValueWithOrietation(\
valueType,\
Name)   \
\
- (valueType) Name##WithOrietation:(UIInterfaceOrientation)orientation;
#endif

#ifndef DefineValueWithOrietation
#define DefineValueWithOrietation(\
valueType,\
Name,\
value_For_iPhone_Portrait,\
value_For_iPhone_Landscape,\
value_For_iPad_Portrait,\
value_For_iPad_Landscape)  \
- (valueType) Name##WithOrietation:(UIInterfaceOrientation)orientation\
{\
valueType retValue; \
\
if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) \
{\
if (UIInterfaceOrientationIsPortrait(orientation)) \
{\
retValue = value_For_iPhone_Portrait;\
}\
else\
{\
retValue = value_For_iPhone_Landscape;\
}\
}\
else\
{\
if (UIInterfaceOrientationIsPortrait(orientation)) \
{\
retValue = value_For_iPad_Portrait;\
}\
else\
{\
retValue = value_For_iPad_Landscape;\
}\
}\
\
return retValue;\
}

#endif


#endif
