//
//  VFCSpeakerNotesManager.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 2/2/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCSpeakerNotesManager.h"

#pragma mark - VFCSpeakerNotesManager

#pragma mark - Private Interface

@interface VFCSpeakerNotesManager()
@property (nonatomic, strong, readwrite) NSDictionary *speakerNotesDictionary;
@end

#pragma mark - Public Implementation

@implementation VFCSpeakerNotesManager

#pragma mark Class Methods

+ (VFCSpeakerNotesManager *)speakerNotesManager {
    static VFCSpeakerNotesManager *_speakerNotesManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _speakerNotesManager = [[[self class] alloc] init];
    });
    return _speakerNotesManager;
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SpeakerNotes" ofType:@"plist"];
        [self setSpeakerNotesDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
    }
    return self;
}

#pragma mark Public

- (NSString *)speakerNotes {
    return [[self speakerNotesDictionary] objectForKey:[self speakerNotesKey]];
}

@end
