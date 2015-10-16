//
//  VFCPageView.h
//  RCAMPad
//

@import UIKit;

#pragma mark - VFCPageView

#pragma mark - Public Interface

@interface VFCPageView : UIView
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readwrite) NSArray *deepDiveImageNames;
@end