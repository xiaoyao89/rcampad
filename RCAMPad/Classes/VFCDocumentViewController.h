//
//  VFCDocumentViewController.h
//  RCAMPad
//

@import UIKit;
#import "VFCKit.h"

@class VFCDocument;

#pragma mark - VFCDocumentViewController

#pragma mark - Public Interface

@interface VFCDocumentViewController : UIViewController
- (instancetype)initWithDocument:(VFCDocument *)document;
@end
