//
//  VFCSegmentButton.h
//  RCAMPad
//

@import UIKit;

#pragma mark - VFCSegmentButton

#pragma mark - Public Interface

@interface VFCSegmentButton : UIButton
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, copy, readwrite) NSString *imageIdentifier;
@end
