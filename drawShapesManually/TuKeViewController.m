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
//@property (nonatomic, strong) NSMutableArray *sortedPoints;
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
        CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@,%@}",separatedPointString[0],separatedPointString[1]]);
        
        [self.pointsFromText addObject:[NSValue valueWithCGPoint:point]];
    }
    self.remainingPoints = [[NSMutableArray alloc]initWithArray:self.pointsFromText];
//    self.sortedPoints = [[NSMutableArray alloc]initWithCapacity:self.pointsFromText.count];
    self.convexHullPoints = [[NSMutableArray alloc]initWithCapacity:self.pointsFromText.count];
    [self findMinimumPoint];
    [self findConvexHullPoints];
    
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
