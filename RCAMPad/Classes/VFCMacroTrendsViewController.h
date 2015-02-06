//
//  VFCMacroTrendsViewController.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/22/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VFCMacroTrend;
@class VFCMacroTrendsViewController;

#pragma mark - VFCMacroTrendsViewControllerDelegate

#pragma mark - Public Protocol

@protocol VFCMacroTrendsViewControllerDelegate <NSObject>
@optional
- (void)macroTrendsViewController:(VFCMacroTrendsViewController *)macroTrendsViewController didSelectMacroTrend:(VFCMacroTrend *)macroTrend;
- (void)macroTrendsViewControllerDidSelectInfoButton:(VFCMacroTrendsViewController *)macroTrendsViewController;
@end

#pragma mark - VFCMacroTrendsViewController

#pragma mark - Public Interface

@interface VFCMacroTrendsViewController : UICollectionViewController
@property (nonatomic, weak, readwrite) id<VFCMacroTrendsViewControllerDelegate> macroTrendsViewControllerDelegate;
- (instancetype)initWithMacroTrends:(NSArray *)macroTrends;
@end
