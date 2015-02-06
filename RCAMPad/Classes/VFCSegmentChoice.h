//
//  VFCSegmentChoice.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - VFCSegmentChoice

#pragma mark - Public Interface

@interface VFCSegmentChoice : NSObject
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *imageName;
+ (NSArray *)segmentChoices;
@end
