//
//  VFCSpeakerNotesManager.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 2/2/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - VFCSpeakerNotesManager

#pragma mark - Public Interface

@interface VFCSpeakerNotesManager : NSObject
@property (nonatomic, copy, readwrite) NSString *speakerNotesKey;
+ (VFCSpeakerNotesManager *)speakerNotesManager;
- (NSString *)speakerNotes;
@end
