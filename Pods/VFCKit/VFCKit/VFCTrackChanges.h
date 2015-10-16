//
//  VFCTrackChanges.h
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

@import Foundation;
#import "AFNetworking.h"

#pragma mark - VFCTrackChanges

#pragma mark - Public Interface

/**
 *  Manages application tracking data.
 */
@interface VFCTrackChanges : NSObject

/**
 *  Sends application tracking data as a JSON dictionary.
 *
 *  @param appID     The application identifier
 *  @param urlString The URL
 *  @param dict      The dictionary representation of tracking data.
 */
+ (void)submitTracking:(NSInteger)appID URLString:(NSString *)urlString dictionary:(NSDictionary *)dict;

@end
