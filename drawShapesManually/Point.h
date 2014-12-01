//
//  Point.h
//  drawShapesManually
//
//  Created by 孙培峰 on 11/5/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface SFPoint : NSObject

@property (readonly) BOOL isInitialized;
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (readonly, nonatomic) CGPoint point;
@property float angleFromHorizonalLine;

- (SFPoint *)initWithPoint:(CGPoint)point;
- (SFPoint *)initWithX:(float)x y:(float)y;

@end
