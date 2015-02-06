//
//  VFCMacroTrend.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - VFCMacroTrend

#pragma mark - Public Interface

@interface VFCMacroTrend : NSObject <NSCopying>
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *imageName;
+ (NSArray *)macroTrends;
@end
