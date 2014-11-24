//
//  ContainerView.m
//  drawShapesManually
//
//  Created by 孙培峰 on 11/24/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "ContainerView.h"
#import "Point.h"

@interface ContainerView()

@property float radius;
@property NSMutableArray *points;
@property float angleInterval;
@property NSInteger originalAngle;
@property (assign) CGPoint originalPoint;
@property NSUInteger pointsCount;

@end

@implementation ContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.originalAngle = 0;
    self.angleInterval = 0.1;
    self.radius = 80;
    self.pointsCount = ((NSUInteger)(360/self.angleInterval));
    self.points = [[NSMutableArray alloc]initWithCapacity:_pointsCount];
    self.originalPoint = CGPointMake(self.radius, 0);
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *circle = [UIBezierPath new];
    circle.lineWidth = 5;
    circle.lineCapStyle = kCGLineCapRound;
    circle.lineJoinStyle = kCGLineCapRound;
    [circle moveToPoint:CGPointMake(400, 400)];
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
    //    if (((SFPoint *)[self.points objectAtIndex:index]).isInitialized != NO) {
    //        return ((SFPoint *)[self.points objectAtIndex:index]).point;
    //    }
    //    if (index == 0) {
    //        return self.originalPoint;
    //    }
    double pointAngle = (double)(self.originalAngle + index*self.angleInterval);
    float x = 0;
    float y = 0;
    
    double temp0 = (double)(90-pointAngle/2-(self.originalAngle+index*self.angleInterval));
    x = self.originalPoint.x - 2*self.radius*sin(pointAngle/2/360*M_PI)*cos(temp0/360*M_PI);
    y = self.originalPoint.y - 2*self.radius*sin(pointAngle/2/360*M_PI)*sin(temp0/360*M_PI);
    
    ((SFPoint *)self.points[index]).x = x+300;
    ((SFPoint *)self.points[index]).y = y+300;
    
    self.originalPoint = CGPointMake(x, y);
    
}


@end
