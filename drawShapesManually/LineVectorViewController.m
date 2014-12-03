//
//  LineVectorViewController.m
//  drawShapesManually
//
//  Created by 孙培峰 on 12/3/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "LineVectorViewController.h"

@interface LineVectorViewController ()

@property CGPoint point1;
@property CGPoint point2;
@property CGPoint point3;
@property CGPoint point4;
//@property (nonatomic, strong) NSMutableArray *pointsArray;

@end

@implementation LineVectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _point1 = CGPointMake(100, 100);
    _point2 = CGPointMake(200, 200);
    _point3 = CGPointMake(250, 250);
    _point4 = CGPointMake(400, 300);
    
    NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:_point1],[NSValue valueWithCGPoint:_point2],[NSValue valueWithCGPoint:_point3],[NSValue valueWithCGPoint:_point4],nil];
    [self drawPoints:arr];
    
    [self drawLinesThroughMiddleLinesOfPoint:_point1 point2:_point2];
    [self drawLinesThroughMiddleLinesOfPoint:_point2 point2:_point3];
    [self drawLinesThroughMiddleLinesOfPoint:_point3 point2:_point4];

   

    
    
}

- (void)drawLinesThroughMiddleLinesOfPoint:(CGPoint)point1 point2:(CGPoint)point2
{
    CGFloat arc = [self arcWithHorizonalLineWithPoint:point1 point:point2];
    arc = -(90-arc);
    
    CGPoint middlePoint1 = [self middlePointOfPoint1:point1 point2:point2];
    CGPoint sidePoint11 = [self pointFromMiddlePoint:middlePoint1 withAngle:arc distance:90];
    CGPoint sidePoint12 = [self pointFromMiddlePoint:middlePoint1 withAngle:arc distance:-90];
    
    NSArray *middlePointsAsset1 = @[[NSValue valueWithCGPoint:sidePoint11],[NSValue valueWithCGPoint:middlePoint1],[NSValue valueWithCGPoint:sidePoint12]];
    [self drawPoints:middlePointsAsset1];
}

- (void)drawPoints:(NSArray *)pointsArray
{
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, pointsArray.count)];
    [pointsArray enumerateObjectsAtIndexes:set options:0 usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop){
        
        CGPoint point = [pointValue CGPointValue];
        [path addLineToPoint:point];
        
        //rect折线画法
        CGRect rect;
        rect.origin.x = point.x;
        rect.origin.y = point.y;
        rect.size.width = 4;
        rect.size.height = 4;
        
        UIBezierPath *arc = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path appendPath:arc];
    }];
    //第三、UIBezierPath和CAShapeLayer关联
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.frame = self.view.frame;
    lineLayer.fillColor = [UIColor greenColor].CGColor;
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    [view.layer addSublayer:lineLayer];

}

- (CGFloat)arcWithHorizonalLineWithPoint:(CGPoint)startPoint point:(CGPoint)endPoint
{
    CGPoint originPoint = CGPointMake(endPoint.x-startPoint.x, endPoint.y-startPoint.y);
    float bearingRadians = atan2f(originPoint.x, originPoint.y);
    float bearingDegrees = bearingRadians*180/M_PI;
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (bearingDegrees+360));
    return bearingDegrees;
}

- (CGPoint)middlePointOfPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    return CGPointMake((point1.x+point2.x)/2, (point1.y+point2.y)/2);
}

- (CGPoint)pointFromMiddlePoint:(CGPoint)middlePoint withAngle:(CGFloat)angle distance:(CGFloat)distance
{
    CGFloat x = middlePoint.x + cosf(angle/180*M_PI)*distance;
    CGFloat y = middlePoint.y + sinf(angle/180*M_PI)*distance;
    return CGPointMake(x, y);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
