//
//  OEBBookModelSelectFun.m
//  DocinBookReader
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OEBBookModelSelectFun.h"
#import "OEBTextModelSelectFun.h"

@implementation OEBBookModel(select)

#pragma mark-
#pragma mark select
- (void) setSelectStartLocation:(id)selectStartLocation
{
    [super setSelectStartLocation:selectStartLocation];
    
    OEBTextModel* textModel = [self textModelFromLocation:selectStartLocation];
    
    textModel.selectStartLocation = selectStartLocation;
}

- (void) setSelectStopLocation:(id)selectStopLocation
{
    [super setSelectStopLocation:selectStopLocation];

    OEBTextModel* textModel = [self textModelFromLocation:selectStopLocation];
    
    textModel.selectStopLocation = selectStopLocation;
}

- (void) setIsSelecting:(bool)isSelecting
{
    [super setIsSelecting:isSelecting];
    
    for (OEBTextModel* textModel in [textModelDic allValues])
    {
        textModel.isSelecting = isSelecting;
    }
}

- (id) sentenceStartLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel sentenceStartLocationWithPoint:point inPageIndex:pageIndexInTextModel];
}
- (id) sentenceStoptLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel sentenceStoptLocationWithPoint:point inPageIndex:pageIndexInTextModel];
}
- (id) startLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel startLocationWithPoint:point inPageIndex:pageIndexInTextModel];
}
- (id) stopLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel stopLocationWithPoint:point inPageIndex:pageIndexInTextModel];
}

- (id) accessbilityWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel accessbilityWithPoint:point inPageIndex:pageIndexInTextModel];
}

- (id) startSelectingElementInPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel startSelectingElementInPageIndex:pageIndexInTextModel];
}
- (id) stopSelectingElementInPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel stopSelectingElementInPageIndex:pageIndexInTextModel];
}

@end
