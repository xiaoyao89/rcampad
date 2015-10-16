//
//  VFCDocument.m
//  RCAMPad
//

#import "VFCDocument.h"

#pragma mark - VFCDocument

#pragma mark - Private Interface

@interface VFCDocument()
@end

#pragma mark - Public Implementation

@implementation VFCDocument

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setMacroTrend:@"Millenials"];
        [self setSegmentChoice:@"Fast Casual"];
    }
    return self;
}

#pragma mark Public

- (NSArray *)crumbTrails {
    NSMutableArray *crumbTrails = [NSMutableArray array];
    
    NSInteger step = self.step.integerValue;
    
    if (step >= VFCDocumentStepMacroTrend) {
        if (step == VFCDocumentStepMacroTrend) {
            [crumbTrails addObject:(self.macroTrend.length > 0) ? self.macroTrend : @"Select a macro trend"];
        } else {
            [crumbTrails addObject:(self.macroTrend.length > 0) ? self.macroTrend : @"Macro Trend"];
        }
    }
    if (step >= VFCDocumentStepSegmentChoice) {
        if (step == VFCDocumentStepSegmentChoice) {
            [crumbTrails addObject:(self.segmentChoice.length > 0) ? self.segmentChoice : @"Select a segment choice"];
        } else {
            [crumbTrails addObject:(self.segmentChoice.length > 0) ? self.segmentChoice : @"Segment Choice"];
        }
    }
    if (step >= VFCDocumentStepGapAnaysis) {
        [crumbTrails addObject:@"Gap Analysis"];
    }
    if (step >= VFCDocumentStepSolution) {
        [crumbTrails addObject:@"Suggested Solution"];
    }
    
    return [NSArray arrayWithArray:crumbTrails];
}

- (NSArray *)uppercaseCrumbTrails {
    NSArray *crumbTrails = [self crumbTrails];
    NSMutableArray *uppercaseCrumbTrails = [NSMutableArray array];
    for (NSString *crumbTrail in crumbTrails) {
        [uppercaseCrumbTrails addObject:[crumbTrail uppercaseString]];
    }
    return [NSArray arrayWithArray:uppercaseCrumbTrails];
}

#pragma mark Private

+ (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    return path;
}

@end
