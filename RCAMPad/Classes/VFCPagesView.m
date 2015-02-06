//
//  VFCPagesView.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 2/2/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCPagesView.h"
#import "VFCPageView.h"
#import "PureLayout.h"

#pragma mark - VFCPagesView

#pragma mark - Private Interface

@interface VFCPagesView() <UIScrollViewDelegate>
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;
@end

#pragma mark - Public Implementation

@implementation VFCPagesView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setDelegate:self];
        [self setScrollView:scrollView];
        [self addSubview:scrollView];
        
        UIPageControl *pageControl = [UIPageControl newAutoLayoutView];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];
        [self setPageControl:pageControl];
        [self addSubview:pageControl];
        
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop];
                     [scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                     [scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight];
                     
                     [pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                     [pageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                     [pageControl autoPinEdgeToSuperviewEdge:ALEdgeRight];
                     
                     [scrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:pageControl];
                     [pageControl autoSetDimension:ALDimensionHeight toSize:30.0];
                 }];
    }
    return self;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [scrollView contentOffset].x / [scrollView frame].size.width;
    [[self pageControl] setCurrentPage:page];
}

#pragma mark Property Overrides

- (void)setPageViews:(NSArray *)pageViews {
    if (_pageViews != pageViews) {
        for (VFCPageView *pageView in [[self scrollView] subviews]) {
            [pageView removeFromSuperview];
        }
        
        _pageViews = pageViews;
        
        
        for (VFCPageView *pageView in _pageViews) {
            [[self scrollView] addSubview:pageView];
            [pageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [pageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        }
        
        [[[self scrollView] subviews] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0];
        
        CGSize contentSize = [[self scrollView] contentSize];
        contentSize.width = [_pageViews count]*[[self scrollView] frame].size.width;
        [[self scrollView] setContentSize:contentSize];
        
        [[self scrollView] setContentOffset:CGPointZero];
        
        [[self pageControl] setNumberOfPages:[_pageViews count]];
        [[self pageControl] setCurrentPage:0];
    }
}

@end
