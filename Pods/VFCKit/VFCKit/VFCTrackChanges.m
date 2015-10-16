//
//  VFCTrackChanges.m
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

#import "VFCTrackChanges.h"

#pragma mark - VFCTrackChanges

#pragma mark - Public Implementation

@implementation VFCTrackChanges

+ (void)submitTracking:(NSInteger)appID URLString:(NSString *)urlString dictionary:(NSDictionary *)dict {
    if (urlString && dict) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [manager GET:urlString
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             }];
    }
}

@end
