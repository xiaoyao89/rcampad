//
//  VFCDocumentsViewController.h
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFCDocumentsViewController;

#pragma mark - VFCDocumentsViewControllerDelegate

#pragma mark - Public Protocol

@protocol VFCDocumentsViewControllerDelegate <NSObject>
@optional
- (void)documentsViewController:(VFCDocumentsViewController *)documentsViewController didAddDocument:(VFCDocument *)document;
- (void)documentsViewController:(VFCDocumentsViewController *)documentsViewController didSelectDocument:(VFCDocument *)document;
- (void)documentsViewController:(VFCDocumentsViewController *)documentsViewController didRemoveDocument:(VFCDocument *)document;
@end

#pragma mark - VFCDocumentsViewController

#pragma mark - Public Interface

@interface VFCDocumentsViewController : UITableViewController
@property (nonatomic, weak, readwrite) id<VFCDocumentsViewControllerDelegate> documentsViewControllerDelegate;
- (instancetype)initWithDocuments:(NSArray *)documents;
@end
