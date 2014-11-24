//
//  PointView.m
//  drawShapesManually
//
//  Created by 孙培峰 on 11/24/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "PointView.h"
#import "Point.h"

@interface PointView()

@property float radius;
@property NSMutableArray *points;
@property float angleInterval;
@property NSInteger startAngle;
@property (assign) CGPoint originalPoint;
@property NSUInteger pointsCount;
@property CGPoint centerPoint;

@end

@implementation PointView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.startAngle = 0;
    self.angleInterval = 0.1;
    self.radius = 80;
    self.centerPoint = CGPointMake(400, 400);
    self.pointsCount = ((NSUInteger)(360/self.angleInterval));
    self.points = [[NSMutableArray alloc]initWithCapacity:_pointsCount];
    self.originalPoint = CGPointMake(self.radius, 0);
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *circle = [UIBezierPath new];
    circle.lineWidth = 0.5;
    circle.lineCapStyle = kCGLineCapRound;
    circle.lineJoinStyle = kCGLineCapRound;
    [circle moveToPoint:[self pointAtIndex:0]];
    
    for (NSInteger i = 0; i < _pointsCount; i++) {
        self.points[i] = [[SFPoint alloc]init];
        [self calculatePointAtIndex:i];
        NSLog(@"X:%f , Y:%f",((SFPoint *)self.points[i]).point.x,((SFPoint *)self.points[i]).point.y);
        [circle addLineToPoint:((SFPoint *)self.points[i]).point];
    }
    [circle stroke];
    
}

- (void)calculatePointAtIndex:(NSInteger)index
{
    //Start from UP side
    float currentAngle = index*self.angleInterval;
    float x = self.centerPoint.x;
    float y = self.centerPoint.y;
    
    x += sinf(currentAngle/M_PI)*self.radius;
    y += cosf(currentAngle/M_PI)*self.radius;
    
    self.points[index] = [SFPoint new];
    ((SFPoint *)self.points[index]).x = x;
    ((SFPoint *)self.points[index]).y = y;
    
}

- (CGPoint)pointAtIndex:(NSInteger)index
{
    CGPoint point;
    float currentAngle = index*self.angleInterval;
    point.x = self.centerPoint.x;
    point.y = self.centerPoint.y;
    
    point.x += sinf(currentAngle/M_PI)*self.radius;
    point.y += cosf(currentAngle/M_PI)*self.radius;
    return point;
}


@end
