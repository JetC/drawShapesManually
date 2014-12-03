//
//  TuKeViewController.m
//  drawShapesManually
//
//  Created by 孙培峰 on 11/24/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "TuKeViewController.h"
#import "Point.h"

@interface TuKeViewController ()

@property (nonatomic, strong) NSMutableArray *pointsFromText;
@property (nonatomic, strong) NSMutableArray *remainingPoints;
@property (nonatomic, strong) NSMutableArray *convexHullPoints;
@property CGPoint minimumPoint;

@end

@implementation TuKeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"TUKE" ofType:@"txt"];
    NSArray *plainText = [[NSMutableString stringWithContentsOfFile:filePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    self.pointsFromText = [[NSMutableArray alloc]init];
    for (NSString *pointSourceString in plainText) {
        if ([pointSourceString isEqualToString:@""] || plainText.count < 2) {
            continue;
        }
        NSMutableString *mutableString = [[[NSMutableString stringWithString:pointSourceString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
        NSArray *separatedPointString = [mutableString componentsSeparatedByString:@"   "];
        CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@,%@}",separatedPointString[0],[NSString stringWithFormat:@"%f", ([separatedPointString[1] floatValue]+200)]]);
        
        [self.pointsFromText addObject:[NSValue valueWithCGPoint:point]];
    }
    self.remainingPoints = [[NSMutableArray alloc]initWithArray:self.pointsFromText];
    self.convexHullPoints = [[NSMutableArray alloc]initWithCapacity:self.pointsFromText.count];
    [self findMinimumPoint];
    [self findConvexHullPoints];
    for (NSValue *pointValue in self.pointsFromText) {
        CGPoint point = [pointValue CGPointValue];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, 2, 2)];
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
    }
    
    [self drawBezierPath];
}

- (void)drawBezierPath
{
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.convexHullPoints.count)];
    [bezierPath moveToPoint:self.minimumPoint];
    [self.convexHullPoints enumerateObjectsAtIndexes:set options:0 usingBlock:^(SFPoint *pointSource, NSUInteger idx, BOOL *stop){
        
        CGPoint point = pointSource.point;
        [bezierPath addLineToPoint:point];
        //（一）rect折线画法
        CGRect rect;
        rect.origin.x = point.x;
        rect.origin.y = point.y;
        rect.size.width = 4;
        rect.size.height = 4;
        
        //（二）rect射线画法
        //        CGRect rect = CGRectMake(10, 10, 1, 1);
        
        UIBezierPath *arc = [UIBezierPath bezierPathWithOvalInRect:rect];
        [bezierPath appendPath:arc];
    }];
//    [bezierPath stroke];
    //第三、UIBezierPath和CAShapeLayer关联
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.frame = self.view.frame;
    lineLayer.fillColor = [UIColor redColor].CGColor;
    lineLayer.path = bezierPath.CGPath;
    lineLayer.strokeColor = [UIColor redColor].CGColor;
    [view.layer addSublayer:lineLayer];
}



- (void)drawLine{
    
    //view是曲线的背景view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 300)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //第一、UIBezierPath绘制线段
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //四个点
    CGPoint point = CGPointMake(10, 10);
    CGPoint point1 = CGPointMake(200, 100);
    CGPoint point2 = CGPointMake(240, 200);
    CGPoint point3 = CGPointMake(290, 200);
    
    NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point],[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point3], nil ,nil];
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)];
    //第二、就是这句话绘制
    [arr enumerateObjectsAtIndexes:set options:0 usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop){
        
        CGPoint point = [pointValue CGPointValue];
        [path addLineToPoint:point];
        
        //（一）rect折线画法
        CGRect rect;
        rect.origin.x = point.x - 1.5;
        rect.origin.y = point.y - 1.5;
        rect.size.width = 4;
        rect.size.height = 4;
        
        //（二）rect射线画法
        //        CGRect rect = CGRectMake(10, 10, 1, 1);
        
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

//    //以下代码为附加的
//    //（一）像一个幕布一样拉开，显得有动画
//    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 400)];
//    view1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view1];
//    
//    [UIView animateWithDuration:5 animations:^{
//        view1.frame = CGRectMake(320, 100, 320, 400);
//    }];
    
}

- (void)findMinimumPoint
{
    float minX;
    float minY;
    minX = [self pointAtIndex:0].x;
    minY = [self pointAtIndex:0].y;
    for (int i = 1; i < self.pointsFromText.count; i++) {
        if ([self pointAtIndex:i].x < minX) {
            minX = [self pointAtIndex:i].x;
        }
        if ([self pointAtIndex:i].y < minY) {
            minY = [self pointAtIndex:i].y;
        }
    }
    self.minimumPoint = CGPointMake(minX, minY);
}

- (void)findConvexHullPoints
{
    NSMutableArray *convexHullPoints = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.pointsFromText.count ; i++) {
        if (i == 0) {
            ;
            [convexHullPoints addObject:[[self sortPointsAccordingToAngleWithVertex:self.minimumPoint] firstObject]];
            continue;
        }
        [convexHullPoints addObject:[[self sortPointsAccordingToAngleWithVertex:((SFPoint *)[convexHullPoints lastObject]).point] firstObject]];
    }
    for (NSInteger i = 0; i < convexHullPoints.count; i++) {
        if (i != 0) {
            if (((SFPoint *)convexHullPoints[i]).angleFromHorizonalLine < ((SFPoint *)convexHullPoints[i-1]).angleFromHorizonalLine) {
                NSRange range;
                range = NSMakeRange(i, convexHullPoints.count-i);
                [convexHullPoints removeObjectsInRange:range];
            }
        }
    }
    self.convexHullPoints = convexHullPoints;
    NSLog(@"Finished");
}

/**
 *  此处 Angle 指 minimumPoint 为顶点，与水平线和所给点的夹角
 */
- (NSMutableArray *)sortPointsAccordingToAngleWithVertex:(CGPoint)vertex
{
    NSMutableArray *remainingPoints = [[NSMutableArray alloc]initWithArray:self.remainingPoints];
    NSMutableArray *sortedPoints = [[NSMutableArray alloc]init];
    while (remainingPoints.count != 0) {
        
        CGPoint sourcePoint = [[remainingPoints firstObject] CGPointValue];
        float arc = [self arcWithHorizonalLineWithPoint:vertex point:sourcePoint];
        SFPoint *point = [[SFPoint alloc]initWithX:sourcePoint.x y:sourcePoint.y];
        point.angleFromHorizonalLine = arc;
        [sortedPoints addObject:point];
        [remainingPoints removeObjectAtIndex:0];
    }
    sortedPoints = [[sortedPoints sortedArrayUsingComparator:^NSComparisonResult(SFPoint *obj1, SFPoint *obj2) {
        if (obj1.angleFromHorizonalLine < obj2.angleFromHorizonalLine) {
            return NSOrderedAscending;
        }
        else if(obj1.angleFromHorizonalLine > obj2.angleFromHorizonalLine) {
            return NSOrderedDescending;
        }
        else{
            return NSOrderedSame;
        }
    }] mutableCopy];
    return sortedPoints;
}

- (CGFloat)arcWithHorizonalLineWithPoint:(CGPoint)startPoint point:(CGPoint)endPoint
{
    CGPoint originPoint = CGPointMake(endPoint.x-startPoint.x, endPoint.y-startPoint.y);
    float bearingRadians = atan2f(originPoint.x, originPoint.y);
    float bearingDegrees = bearingRadians*180/M_PI;
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (bearingDegrees+360));
    return bearingDegrees;
}


- (CGPoint)pointAtIndex:(NSInteger)index
{
    CGPoint point;
    point = [(NSValue *)self.pointsFromText[index] CGPointValue];
    return point;
}

- (CGPoint)pointAtIndex:(NSInteger)index fromArray:(NSArray *)sourceArray
{
    CGPoint point;
    point = [(NSValue *)sourceArray[index] CGPointValue];
    return point;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
