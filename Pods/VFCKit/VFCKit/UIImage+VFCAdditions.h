//
//  UIImage+VFCAdditions.h
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

@import UIKit;

#pragma mark - UIImage

#pragma mark - Public Interface (VFCAdditions)

@interface UIImage (VFCAdditions)

/**
 *  Creates an image with the tint color.
 *
 *  @param tintColor The tint color.
 *
 *  @return UIImage object.
 */
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;

/**
 *  Creates an image with gradient effect using the tint color.
 *
 *  @param tintColor The tint color.
 *
 *  @return UIImage object.
 */
- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor;

@end
