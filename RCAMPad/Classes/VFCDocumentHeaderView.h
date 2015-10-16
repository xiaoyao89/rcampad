//
//  VFCDocumentHeaderView.h
//  RCAMPad
//

@import UIKit;
#import "VFCKit.h"

@class VFCCrumbTrailView;
@class VFCDocumentHeaderView;
@class VFCSegmentButton;

#pragma mark - VFCDocumentHeaderViewDelegate

#pragma mark - Public Protocol

@protocol VFCDocumentHeaderViewDelegate<NSObject>
@optional
- (void)documentHeaderView:(VFCDocumentHeaderView *)documentHeaderView didSelectButtonAtIndex:(NSInteger)index;
@end

#pragma mark - VFCDocumentHeaderView

#pragma mark - Public Interface

extern NSString *const VFCDocumentHeaderViewShowNextButton;
extern NSString *const VFCDocumentheaderViewHideNextButton;

@interface VFCDocumentHeaderView : UIView
@property (nonatomic, weak, readwrite) id<VFCDocumentHeaderViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *informationButton;
@property (nonatomic, strong, readonly) VFCCrumbTrailView *crumbTrailView;
@property (nonatomic, strong, readonly) UIButton *nextButton;
@property (nonatomic, strong, readonly) UIButton *continueButton;
- (void)moveCaratToPoint:(CGPoint)point;
- (void)moveCaratToIndex:(NSInteger)index;
@end
