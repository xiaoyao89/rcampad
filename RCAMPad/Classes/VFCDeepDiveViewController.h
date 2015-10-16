//
//  VFCDeepDiveViewController.h
//  RCAMPad
//

@import UIKit;

#import "ECSlidingViewController.h"

#pragma mark - VFCDeepDiveViewController

#pragma mark - Public Interface

@interface VFCDeepDiveViewController : UIViewController
- (instancetype)initWithImageNames:(NSArray *)imageNames speakerNotesIdentifier:(NSString *)speakerNotesIdentifier NS_DESIGNATED_INITIALIZER;
@end

#pragma mark - VFCDeepDiveSlidingViewController

@interface VFCDeepDiveSlidingViewController : ECSlidingViewController
- (instancetype)initWithImageNames:(NSArray *)imageNames speakerNotesIdentifier:(NSString *)speakerNotesIdentifier NS_DESIGNATED_INITIALIZER;
@end