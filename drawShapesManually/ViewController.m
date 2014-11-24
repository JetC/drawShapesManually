//
//  ViewController.m
//  drawShapesManually
//
//  Created by 孙培峰 on 11/5/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "ViewController.h"
#import "Point.h"
#import "ContainerView.h"
#import "PointView.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[[PointView alloc] initWithFrame:self.view.frame]];

}

- (void)viewWillAppear:(BOOL)animated
{
//    CGMutablePathRef mutablePathRef = CGPathCreateMutable();;
//    [mutablePathRef ]

    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pointV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    
//    // align pointV from the top
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60.5-[pointV]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pointV)]];
//    
//    // width constraint
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pointV(==768)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pointV)]];
//    
//    // height constraint
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointV(==1136)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pointV)]];
//    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
