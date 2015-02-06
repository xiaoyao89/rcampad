//
//  VFCUser.h
//  VFCKit
//

#import <Foundation/Foundation.h>

#pragma mark - VFCUser

#pragma mark - Public Interface

@interface VFCUser : NSObject
+ (VFCUser *)user;
- (NSString *)email;
- (void)setEmail:(NSString *)email;
@end