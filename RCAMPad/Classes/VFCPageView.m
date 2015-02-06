//
//  VFCPageView.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/30/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCPageView.h"
#import "PureLayout.h"

#pragma mark - VFCPageView

#pragma mark - Private Interface

@interface VFCPageView()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@end

#pragma mark - Public Implementation

@implementation VFCPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self setImageView:imageView];
        [self addSubview:imageView];
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                 }];
    }
    return self;
}

@end

#pragma mark - VFCPageView

#pragma mark - Public Implementation

@implementation VFCTypeAPageView
@end