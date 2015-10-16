//
//  VFCSolutionViewController.h
//  RCAMPad
//

@import UIKit;
#import "VFCKit.h"

@class VFCDocument;

#pragma mark - VFCSolutionViewController

#pragma mark - Public Interface

@interface VFCSolutionViewController : UITableViewController
- (instancetype)initWithDocument:(VFCDocument *)document NS_DESIGNATED_INITIALIZER;
@end
