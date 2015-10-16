//
//  VFCSegmentChoicesViewController.h
//  RCAMPad
//

@import UIKit;
#import "VFCKit.h"

@class VFCSegmentChoice;
@class VFCSegmentChoicesViewController;

#pragma mark - VFCSegmentChoicesViewControllerDelegate

#pragma mark - Public Protocol

@protocol VFCSegmentChoicesViewControllerDelegate <NSObject>
- (void)segmentChoicesViewController:(VFCSegmentChoicesViewController *)segmentChoicesViewController didSelectSegmentChoice:(VFCSegmentChoice *)segmentChoice;
@end

#pragma mark - VFCSegmentChoicesViewController

#pragma mark - Public Interface

@interface VFCSegmentChoicesViewController : UICollectionViewController
@property (nonatomic, weak, readwrite) id<VFCSegmentChoicesViewControllerDelegate> segmentChoicesViewControllerDelegate;
- (instancetype)initWithSegmentChoices:(NSArray *)segmentChoices;
- (void)hideHeader;
@end
