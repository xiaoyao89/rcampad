//
//  VFCSegmentChoice.h
//  RCAMPad
//

@import Foundation;

#pragma mark - VFCSegmentChoice

#pragma mark - Public Interface

@interface VFCSegmentChoice : NSObject
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *imageName;
+ (NSArray *)segmentChoices;
@end
