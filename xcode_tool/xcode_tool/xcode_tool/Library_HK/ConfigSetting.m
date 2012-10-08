//
//  config.m
//  
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年  Ltd. All rights reserved.
//

#import "ConfigSetting.h"
#import "GDataXMLNode.h"

@interface NSString (stringValue)

- (id) stringValue;

@end

@implementation NSString (stringValue)

- (id) stringValue
{return self;}

@end
//configFun_implementation
/*********************************************************************************************
 returnType                  返回值的类型
 returnTypeFunName           获取返回值的函数名字
 valuename                   你要设置的参数名字
 curNode                     当前的节点
 deviceName                  iPhone,iPad
 oreitation                  Portrait,Landscape
 *********************************************************************************************/


#define toStr(value)                            @#value
#define configFun_implementation_(returnType,\
                                returnTypeFunName,\
                                valueName,\
                                curNode,\
                                deviceType,\
                                oreitation)                                               \
- (returnType) k##valueName##_For_##deviceType##_##oreitation##Fun                                                   \
{                                                                                                               \
    static returnType retValue = 0;                                                                                  \
\
    static dispatch_once_t onceToken;                                                                           \
    dispatch_once(&onceToken,                                                                                   \
                ^{\
                    id device_oreitationNode = [[curNode elementsForName:toStr(deviceType##_##oreitation)] objectAtIndex:0];\
                    id attributeNode = [device_oreitationNode attributeForName:@"value"];\
                    retValue = [[attributeNode stringValue] returnTypeFunName];\
                }                                                                                             \
                );                                                                                            \
\
    return retValue;                                                                                            \
}

#define configFun_implementation(returnType, returnTypeFunName, valueName, curNode)\
configFun_implementation_(returnType, returnTypeFunName, valueName, curNode, iPhone, Portrait)\
configFun_implementation_(returnType, returnTypeFunName, valueName, curNode, iPhone, Landscape)\
configFun_implementation_(returnType, returnTypeFunName, valueName, curNode, iPad, Portrait)\
configFun_implementation_(returnType, returnTypeFunName, valueName, curNode, iPad, Landscape)\


#define configCheck(value)\
NSAssert(k##value##_For_iPad_Portrait,@"");\
NSAssert(k##value##_For_iPad_Landscape,@"");\
NSAssert(k##value##_For_iPhone_Portrait,@"");\
NSAssert(k##value##_For_iPhone_Landscape,@"");


@interface ConfigSetting ()

@property (nonatomic, retain) GDataXMLDocument* configXMLDoc;

@end

@implementation ConfigSetting

@synthesize configXMLDoc;

- (void) configCheck
{
    //检测参数是否设置正确
    /*********************************************************************************************/
     configCheck(ScreenWidth)
    /*********************************************************************************************/
}


+ (ConfigSetting *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      sharedInstance = [[self alloc] init];
                    }
                  );    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        NSString* configPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
        NSData* configDate = [NSData dataWithContentsOfFile:configPath];
    
        self.configXMLDoc = [[[GDataXMLDocument alloc] initWithData:configDate options:0 error:nil] autorelease];
        
        [self performSelectorInBackground:@selector(configCheck) withObject:nil];
    }
    return self;
}

- (void)dealloc
{
    self.configXMLDoc = nil;
    [super dealloc];
}

//commonNode
/*********************************************************************************************/
- (GDataXMLElement*) commonNode
{
    static GDataXMLElement* retValue = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      retValue = [[self.configXMLDoc.rootElement elementsForName:@"Common"] objectAtIndex:0];
                  }
                  );  
    
    return retValue;
}

//commonNode_screenNode
/*********************************************************************************************/
- (GDataXMLElement*) commonNode_screenNode
{
    static GDataXMLElement* retValue = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      id parentNode = [self commonNode];
                      retValue = [[parentNode elementsForName:@"Screen"] objectAtIndex:0];
                  }
                  );  
    
    return retValue;
}


//ScreenWidthNode
/*********************************************************************************************/
- (GDataXMLElement*) commonNode_screenNode_screenWidthNode
{
    static GDataXMLElement* retValue = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      id parentNode = [self commonNode_screenNode];
                      retValue = [[parentNode elementsForName:toStr(ScreenWidth)] objectAtIndex:0];
                  }
                  );  
    return retValue;
}
/*********************************************************************************************/
/*********************************************************************************************/
/*********************************************************************************************/

//ScreenWidth
/*********************************************************************************************/
configFun_implementation(float, floatValue, ScreenWidth, [self commonNode_screenNode_screenWidthNode])
/*********************************************************************************************/
@end
