//
//  VFCSolutionViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/30/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCSolutionViewController.h"
#import "PureLayout.h"

#pragma mark - VFCSolutionViewController

#pragma mark - Private Interface

@interface VFCSolutionViewController()
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@end

#pragma mark - Public Implementation

@implementation VFCSolutionViewController

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    
    UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
    [[self view] addSubview:scrollView];
    [self setScrollView:scrollView];
    
    [UIView autoSetPriority:999.0
             forConstraints:^{
                 [scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
             }];
}

@end
