//
//  VFCUser.h
//  VFCKit
//
//  Copyright (C) 2015 Xcelerate Media Inc. All Rights Reserved.
//  See License.txt for licensing information.
//

@import Foundation;

#pragma mark - VFCUser

#pragma mark - Pubic Interface

/**
 *  The user class represents a real-world user of any application built for Ventura Foods. The user class captures the email.
 */
@interface VFCUser : NSObject

/**
 *  The email.
 *
 *  The email is stored in the user's NSUserDefaults.
 */
@property (nonatomic, strong, readwrite) NSString *email;

/**
 *  The singleton user object.
 *
 *  @return VFCUser object.
 */
+ (VFCUser *)user;

@end
