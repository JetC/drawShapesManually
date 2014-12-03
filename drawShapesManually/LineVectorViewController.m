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


@end

@implementation LineVectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _point1 = CGPointMake(100, 100);
    _point2 = CGPointMake(200, 200);
    _point3 = CGPointMake(250, 230);
    _point4 = CGPointMake(300, 220);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 300)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:_point1],[NSValue valueWithCGPoint:_point2],[NSValue valueWithCGPoint:_point3],[NSValue valueWithCGPoint:_point4], nil ,nil];
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)];
    [arr enumerateObjectsAtIndexes:set options:0 usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop){
        
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
    lineLayer.frame = CGRectMake(0, 150, 320, 400);
    lineLayer.fillColor = [UIColor greenColor].CGColor;
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    [view.layer addSublayer:lineLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)arcWithHorizonalLineWithPoint:(CGPoint)startPoint point:(CGPoint)endPoint
{
    CGPoint originPoint = CGPointMake(endPoint.x-startPoint.x, endPoint.y-startPoint.y);
    float bearingRadians = atan2f(originPoint.x, originPoint.y);
    float bearingDegrees = bearingRadians*180/M_PI;
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (bearingDegrees+360));
    return bearingDegrees;
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
