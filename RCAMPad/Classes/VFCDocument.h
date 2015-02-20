//
//  VFCDocument.h
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "XSCKit.h"
@import UIKit;

#pragma mark - VFCDocument

#pragma mark - Public Interface

extern NSString *const VFCNotificationDidCreateDocument;

typedef NS_ENUM(NSInteger, VFCDocumentStep) {
    VFCDocumentStepMacroTrend,
    VFCDocumentStepSegmentChoice,
    VFCDocumentStepGapAnaysis,
    VFCDocumentStepSolution,
};

@interface VFCDocument : UIDocument
@property (nonatomic, assign, readwrite) VFCDocumentStep documentStep;

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readwrite) NSString *version;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *macroTrend;
@property (nonatomic, copy, readwrite) NSString *segmentChoice;
@property (nonatomic, strong, readwrite) NSNumber *state;
@property (nonatomic, strong, readwrite) NSNumber *step;

+ (VFCDocument *)previousDocument;
+ (VFCDocument *)document;
+ (NSArray *)documents;

+ (void)saveAsPreviousDocument:(VFCDocument *)document;

+ (NSString *)extension;
- (NSArray *)crumbTrails;
- (NSArray *)uppercaseCrumbTrails;

@end