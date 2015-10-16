//
//  VFCDocument.h
//  RCAMPad
//

#import "XSCKit.h"
@import UIKit;

#pragma mark - VFCDocument

#pragma mark - Public Interface

typedef NS_ENUM(NSInteger, VFCDocumentStep) {
    VFCDocumentStepMacroTrend,
    VFCDocumentStepSegmentChoice,
    VFCDocumentStepGapAnaysis,
    VFCDocumentStepSolution,
};

@interface VFCDocument : NSObject
@property (nonatomic, assign, readwrite) VFCDocumentStep documentStep;
@property (nonatomic, copy, readwrite) NSString *version;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *macroTrend;
@property (nonatomic, copy, readwrite) NSString *segmentChoice;
@property (nonatomic, strong, readwrite) NSNumber *state;
@property (nonatomic, strong, readwrite) NSNumber *step;

- (NSArray *)crumbTrails;
- (NSArray *)uppercaseCrumbTrails;

@end