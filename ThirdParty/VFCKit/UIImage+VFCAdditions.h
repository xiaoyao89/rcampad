//
//  UIImage+VFCAdditions.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

@import UIKit;

#pragma mark - UIImage

#pragma mark - Public Interface (VFCAdditions)

@interface UIImage (VFCAdditions)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;
- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor;

@end
