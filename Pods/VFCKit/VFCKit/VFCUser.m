//
//  VFCUser.m
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

#import "VFCUser.h"

#pragma mark - NSUserDefaults

#pragma mark - Private Interface

static NSString *NSUserDefaultsKeyEmail = @"com.venturafoods.email";

@interface NSUserDefaults (VFCUserAdditions)

- (NSString *)email;
- (void)setEmail:(NSString *)email;

@end

#pragma masrk - Private Implementation

@implementation NSUserDefaults (VFCUserAdditions)

- (NSString *)email {
    return [self objectForKey:NSUserDefaultsKeyEmail];
}

- (void)setEmail:(NSString *)email {
    [self setObject:email forKey:NSUserDefaultsKeyEmail];
    [self synchronize];
}

@end

#pragma mark - VFCUser

#pragma mark - Public Implementation

@implementation VFCUser
@dynamic email;

#pragma mark Public

+ (VFCUser *)user {
    static VFCUser *_user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[self alloc] init];
    });
    return _user;
}

#pragma mark Properties

- (NSString *)email {
    return [[NSUserDefaults standardUserDefaults] email];
}

- (void)setEmail:(NSString *)email {
    [[NSUserDefaults standardUserDefaults] setEmail:email];
}

@end
