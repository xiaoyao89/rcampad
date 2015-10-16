//
//  UIColor+VFCAdditions.m
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

#import "UIColor+VFCAdditions.h"

#pragma mark - UIColor

#pragma mark - Public Implementation (VFCAdditions)

@implementation UIColor (VFCAdditions)

#pragma mark Public

+ (UIColor *)venturaFoodsBlueColor {
    return [UIColor colorDictionary][@"blue"];
}

+ (UIColor *)venturaFoodsBlackColor {
    return [UIColor colorDictionary][@"black"];
}

#pragma mark Private

/**
 *  Dictionary that contains all the colors.
 *
 *  @return NSDictionary object
 */
+ (NSDictionary *)colorDictionary {
    static dispatch_once_t onceToken;
    static NSDictionary *_dict = nil;
    dispatch_once(&onceToken, ^{
        _dict = @{
                  @"black"  : [UIColor normalizedColorWithRed:2.0 green:2.0 blue:2.0 alpha:1.0],
                  @"blue"   : [UIColor normalizedColorWithRed:27.0 green:39.0 blue:119.0 alpha:1.0]
                  };
    });
    return _dict;
}

/**
 *  Convenient method to normalized the values of the color components.
 *
 *  @param red   value between 0-255
 *  @param green value between 0-255
 *  @param blue  value between 0-255
 *  @param alpha value between 0-1
 *
 *  @return UIColor object
 */
+ (UIColor *)normalizedColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
