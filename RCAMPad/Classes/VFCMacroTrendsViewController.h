//
//  VFCMacroTrendsViewController.h
//  RCAMPad
//

@import UIKit;
#import "VFCKit.h"

@class VFCMacroTrend;
@class VFCMacroTrendsViewController;

#pragma mark - VFCMacroTrendsViewControllerDelegate

#pragma mark - Public Protocol

@protocol VFCMacroTrendsViewControllerDelegate <NSObject>
@optional
- (void)macroTrendsViewController:(VFCMacroTrendsViewController *)macroTrendsViewController didSelectMacroTrend:(VFCMacroTrend *)macroTrend;
@end

#pragma mark - VFCMacroTrendsViewController

#pragma mark - Public Interface

@interface VFCMacroTrendsViewController : UICollectionViewController
@property (nonatomic, weak, readwrite) id<VFCMacroTrendsViewControllerDelegate> macroTrendsViewControllerDelegate;
- (instancetype)initWithMacroTrends:(NSArray *)macroTrends;
- (void)hideHeader;
@end
