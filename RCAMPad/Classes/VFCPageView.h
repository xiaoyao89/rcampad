//
//  VFCPageView.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/30/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

@import UIKit;

#pragma mark - VFCPageView

#pragma mark - Public Interface

@interface VFCPageView : UIView
@property (nonatomic, strong, readonly) UIImageView *imageView;
@end

#pragma mark - VFCPageView

#pragma mark - Public Interface

@interface VFCTypeAPageView : VFCPageView
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UITextView *textView;
@end