//
//  VFCSegmentChoicesViewController.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

@import UIKit;
@class VFCSegmentChoice;
@class VFCSegmentChoicesViewController;

#pragma mark - VFCSegmentChoicesViewControllerDelegate

#pragma mark - Public Protocol

@protocol VFCSegmentChoicesViewControllerDelegate <NSObject>
- (void)segmentChoicesViewController:(VFCSegmentChoicesViewController *)segmentChoicesViewController didSelectSegmentChoice:(VFCSegmentChoice *)segmentChoice;
- (void)segmentChoicesViewControllerDidSelectInfoButton:(VFCSegmentChoicesViewController *)segmentChoicesViewController;
@end

#pragma mark - VFCSegmentChoicesViewController

#pragma mark - Public Interface

@interface VFCSegmentChoicesViewController : UICollectionViewController
@property (nonatomic, weak, readwrite) id<VFCSegmentChoicesViewControllerDelegate> segmentChoicesViewControllerDelegate;
- (instancetype)initWithSegmentChoices:(NSArray *)segmentChoices;
@end
