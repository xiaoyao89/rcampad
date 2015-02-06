//
//  VFCDocumentViewController.m
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "VFCDocumentViewController.h"
#import "VFCCrumbTrailView.h"
#import "VFCDeepDiveViewController.h"
#import "VFCDocument.h"
#import "VFCDocumentHeaderView.h"
#import "VFCDocumentsViewController.h"
#import "VFCGapAnalysisViewController.h"
#import "VFCMacroTrend.h"
#import "VFCMacroTrendsViewController.h"
#import "VFCOverviewViewController.h"
#import "VFCSegmentButton.h"
#import "VFCSegmentChoice.h"
#import "VFCSegmentChoicesViewController.h"
#import "VFCSolutionViewController.h"
#import "PureLayout.h"
#import "VFCApplicationInformationViewController.h"

#pragma mark - VFCDocumentViewController

#pragma mark - Private Interface

@interface VFCDocumentViewController () <VFCDocumentsViewControllerDelegate, VFCDocumentHeaderViewDelegate, VFCMacroTrendsViewControllerDelegate, VFCSegmentChoicesViewControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) VFCDocument *document;
@property (nonatomic, strong, readwrite) VFCMacroTrendsViewController *macroTrendsViewController;
@property (nonatomic, strong, readwrite) VFCDocumentHeaderView *headerView;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIPageViewController *pageViewController;
@end

#pragma mark - Public Implementation

@implementation VFCDocumentViewController

#pragma mark Initialization

- (instancetype)initWithDocument:(VFCDocument *)document {
    self = [super init];
    if (self) {
        [self setDocument:document];
    }
    return self;
}

#pragma mark View Lifecycle

- (void)loadView {
    // Root view
    UIView *rootView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [rootView setBackgroundColor:[UIColor whiteColor]];
    [self setView:rootView];
    
    // Header view
    VFCDocumentHeaderView *headerView = [VFCDocumentHeaderView newAutoLayoutView];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [[headerView informationButton] addTarget:self action:@selector(showInformation:) forControlEvents:UIControlEventTouchUpInside];
    [headerView setDelegate:self];
    [self setHeaderView:headerView];
    [rootView addSubview:headerView];
    
    [headerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [headerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [headerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [headerView autoSetDimension:ALDimensionHeight toSize:150.0];
    [headerView setClipsToBounds:NO];
    
    CALayer *layer = [headerView layer];
    [layer setShadowColor:[[UIColor whiteColor] CGColor]];
    [layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [layer setShadowOpacity:0.25];
    [layer setShadowRadius:0.5];
    
    UIView *contentView = [UIView newAutoLayoutView];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self setContentView:contentView];
    [rootView addSubview:contentView];
    
    [contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [contentView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [headerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:contentView];
    
    [rootView bringSubviewToFront:headerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                             options:nil];
    [self setPageViewController:pageViewController];
    [self addChildViewController:pageViewController];
    
    VFCOverviewViewController *overviewVC = [[VFCOverviewViewController alloc] init];
    [pageViewController setViewControllers:@[overviewVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIView *contentView = [pageViewController view];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] addSubview:contentView];
    [UIView autoSetPriority:999.0
             forConstraints:^{
                 [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
             }];
    
    [[self headerView] moveCaratToIndex:[[[self document] step] integerValue]];
}

#pragma mark VFCDocumentHeaderViewDelegate

- (void)documentHeaderView:(VFCDocumentHeaderView *)documentHeaderView didSelectButtonAtIndex:(NSInteger)index {
    [self showStep:index animated:YES check:YES];
}

#pragma mark VFCDocumentsViewControllerDelegate

- (void)documentsViewController:(VFCDocumentsViewController *)documentsViewController didAddDocument:(VFCDocument *)document {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentsViewController:(VFCDocumentsViewController *)documentsViewController didSelectDocument:(VFCDocument *)document {
    [self setDocument:document];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentsViewController:(VFCDocumentsViewController *)documentsViewController didRemoveDocument:(VFCDocument *)document {
    if ([document isEqual:[self document]]) {
        [self setDocument:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VFCMacroTrendsViewControllerDelegate

- (void)macroTrendsViewController:(VFCMacroTrendsViewController *)macroTrendsViewController didSelectMacroTrend:(VFCMacroTrend *)macroTrend {
    [[self document] setMacroTrend:[macroTrend title] ? [macroTrend title] : @""];
    NSArray *crumbTrails = [[self document] uppercaseCrumbTrails];
    [[[self headerView] crumbTrailView] updateComponents:crumbTrails];
}

- (void)macroTrendsViewControllerDidSelectInfoButton:(VFCMacroTrendsViewController *)macroTrendsViewController {
    VFCDeepDiveViewController *deepDiveVC = [[VFCDeepDiveViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:deepDiveVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark VFCSegmentChoicesViewControllerDelegate

- (void)segmentChoicesViewController:(VFCSegmentChoicesViewController *)segmentChoicesViewController didSelectSegmentChoice:(VFCSegmentChoice *)segmentChoice {
    [[self document] setSegmentChoice:[segmentChoice title] ? [segmentChoice title] : @""];
    NSArray *crumbTrails = [[self document] uppercaseCrumbTrails];
    [[[self headerView] crumbTrailView] updateComponents:crumbTrails];
}

- (void)segmentChoicesViewControllerDidSelectInfoButton:(VFCSegmentChoicesViewController *)segmentChoicesViewController {
    VFCDeepDiveViewController *deepDiveVC = [[VFCDeepDiveViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:deepDiveVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark Public

- (void)setDocument:(VFCDocument *)document  {
    if (_document != document) {
        _document = document;
        [self showStep:[[_document step] integerValue] animated:NO];
    }
}

#pragma mark Private

- (void)showInformation:(UIButton *)button {
    VFCApplicationInformationViewController *infoVC = [[VFCApplicationInformationViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:infoVC];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showStep:(NSInteger)step animated:(BOOL)animated check:(BOOL)check {
    if (check) {
        NSInteger currentStep = [[[self document] step] integerValue];
        if (step != currentStep) {
            [self showStep:step animated:animated];
        }
    } else {
        [self showStep:step animated:animated];
    }
}

- (void)showStep:(NSInteger)step animated:(BOOL)animated {
    [[self document] setStep:@(step)];

    UIViewController *vc = nil;
    switch (step) {
        case VFCDocumentStepOverview: {
            vc = [[VFCOverviewViewController alloc] init];
            break;
        }
        case VFCDocumentStepMacroTrend: {
            vc = [[VFCMacroTrendsViewController alloc] initWithMacroTrends:[VFCMacroTrend macroTrends]];
            [(VFCMacroTrendsViewController *)vc setMacroTrendsViewControllerDelegate:self];
            break;
        }
        case VFCDocumentStepSegmentChoice: {
            vc = [[VFCSegmentChoicesViewController alloc] initWithSegmentChoices:[VFCSegmentChoice segmentChoices]];
            [(VFCSegmentChoicesViewController *)vc setSegmentChoicesViewControllerDelegate:self];
            break;
        }
        case VFCDocumentStepGapAnaysis: {
            vc = [[VFCGapAnalysisViewController alloc] init];
            break;
        }
        case VFCDocumentStepSolution: {
            vc = [[VFCSolutionViewController alloc] init];
            break;
        }
    }
    
    NSArray *crumbTrails = [[self document] uppercaseCrumbTrails];
    [[[self headerView] crumbTrailView] updateComponents:crumbTrails];
    [[self headerView] moveCaratToIndex:step];
    
    if (vc) {
        NSInteger currentStep = [[[self document] step] integerValue];
        [[self pageViewController] setViewControllers:@[vc]
                                            direction:(currentStep < step) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                             animated:animated
                                           completion:nil];
    }
}

@end
