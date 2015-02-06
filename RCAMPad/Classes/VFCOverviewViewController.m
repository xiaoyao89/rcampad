//
//  VFCOverviewViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/29/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCOverviewViewController.h"
#import "VFCPagesView.h"
#import "VFCPageView.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"

#pragma mark - VFCOverviewViewController

#pragma mark - Private Interface

@interface VFCOverviewViewController()
@property (nonatomic, strong, readwrite) VFCPagesView *pagesView;
@end

#pragma mark - Public Implementation

@implementation VFCOverviewViewController

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VFCPagesView *pagesView = [VFCPagesView newAutoLayoutView];
    [self setPagesView:pagesView];
    [[self view] addSubview:pagesView];
    [UIView autoSetPriority:999.0
             forConstraints:^{
                 [pagesView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
             }];
    
    NSMutableArray *pageViews = [NSMutableArray array];
    NSArray *imageNames = @[@"ContentPlaceholder", @"ContentPlaceholder", @"ContentPlaceholder", @"ContentPlaceholder", @"ContentPlaceholder"];
    for (NSInteger i=0; i<[imageNames count]; i++) {
        VFCPageView *pageView = [VFCPageView newAutoLayoutView];
        [[pageView imageView] setImage:[UIImage imageNamed:imageNames[i]]];
        [pageViews addObject:pageView];
    }
    [pagesView setPageViews:pageViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[VFCSpeakerNotesManager speakerNotesManager] setSpeakerNotesKey:@"Overview"];
}

@end
