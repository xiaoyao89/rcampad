//
//  VFCDocumentHeaderView.h
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/18/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
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

@interface VFCDocumentHeaderView : UIView
@property (nonatomic, weak, readwrite) id<VFCDocumentHeaderViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *informationButton;
@property (nonatomic, strong, readonly) VFCCrumbTrailView *crumbTrailView;
- (void)moveCaratToIndex:(NSInteger)index;
@end
