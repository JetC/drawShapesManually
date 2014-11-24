//
//  Point.m
//  drawShapesManually
//
//  Created by 孙培峰 on 11/5/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "Point.h"

@interface SFPoint()

@property (readwrite) BOOL isInitialized;

@end


@implementation SFPoint

- (instancetype)init
{
    self = [super init];
    self.x = 0;
    self.y = 0;
    self.isInitialized = NO;
    return self;
}

- (void)setX:(float)x
{
    _x = x;
    self.isInitialized = YES;
}

- (void)setY:(float)y
{
    _y  = y;
    self.isInitialized = YES;
}

- (CGPoint)point
{
    CGPoint point = CGPointMake(self.x, self.y);
    return point;
}

@end
