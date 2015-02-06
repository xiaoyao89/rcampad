//
//  VFCDocumentViewController.h
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

@import UIKit;
@class VFCDocument;

#pragma mark - VFCDocumentViewController

#pragma mark - Public Interface

@interface VFCDocumentViewController : UIPageViewController
- (instancetype)initWithDocument:(VFCDocument *)document;
@end
