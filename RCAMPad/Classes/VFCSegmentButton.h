//
//  VFCSegmentButton.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/19/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

@import UIKit;

#pragma mark - VFCSegmentButton

#pragma mark - Public Interface

@interface VFCSegmentButton : UIButton
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, copy, readwrite) NSString *imageIdentifier;
@end
