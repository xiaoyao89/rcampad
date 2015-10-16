//
//  VFCPagesView.h
//  RCAMPad
//

@import UIKit;

@class VFCPagesView;

#pragma mark - VFCPagesViewDelegate

@protocol VFCPagesViewDelegate <NSObject>
- (void)pagesView:(VFCPagesView *)pagesView didUpdatePage:(NSInteger)page;
@end

#pragma mark - VFCPagesView

#pragma mark - Public Interface

@interface VFCPagesView : UIView
@property (nonatomic, weak, readwrite) id<VFCPagesViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, strong, readwrite) NSArray *pageViews;
@end
