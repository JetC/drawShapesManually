//
//  TuKeViewController.m
//  drawShapesManually
//
//  Created by 孙培峰 on 11/24/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "TuKeViewController.h"

@interface TuKeViewController ()

@property (nonatomic, strong) NSMutableArray *pointsFromText;
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
    [self findMinimumPoint];
    
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




- (CGPoint)pointAtIndex:(NSInteger)index
{
    CGPoint point;
    point = [(NSValue *)self.pointsFromText[index] CGPointValue];
    return point;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
