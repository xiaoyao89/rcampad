//
//  VFCDocumentViewController.m
//  RCAMPad
//

#import "VFCDocumentViewController.h"
#import "VFCCrumbTrailView.h"
#import "VFCDocument.h"
#import "VFCDocumentHeaderView.h"
#import "VFCGapAnalysisViewController.h"
#import "VFCMacroTrend.h"
#import "VFCMacroTrendsViewController.h"
#import "VFCSegmentButton.h"
#import "VFCSegmentChoice.h"
#import "VFCSegmentChoicesViewController.h"
#import "VFCSolutionViewController.h"
#import "PureLayout.h"

#pragma mark - VFCDocumentViewController

#pragma mark - Private Interface

@interface VFCDocumentViewController () <VFCDocumentHeaderViewDelegate, VFCMacroTrendsViewControllerDelegate, VFCSegmentChoicesViewControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) VFCDocument *document;
@property (nonatomic, strong, readwrite) VFCMacroTrendsViewController *macroTrendsViewController;
@property (nonatomic, strong, readwrite) VFCDocumentHeaderView *headerView;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIPageViewController *pageViewController;
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
@end

#pragma mark - Public Implementation

@implementation VFCDocumentViewController

#pragma mark Initialization

- (instancetype)initWithDocument:(VFCDocument *)document {
    self = [super init];
    if (self) {
        _document = document;
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
    
    [[headerView nextButton] addTarget:self action:@selector(continueToNextStep:) forControlEvents:UIControlEventTouchUpInside];
    [[headerView nextButton] setTag:[[[self document] step] integerValue]];
    
    [[headerView continueButton] addTarget:self action:@selector(continueToNextStep:) forControlEvents:UIControlEventTouchUpInside];
    [[headerView continueButton] setTag:[[[self document] step] integerValue]];
    
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
    
    UIView *contentView = [pageViewController view];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] addSubview:contentView];
    [NSLayoutConstraint autoSetPriority:999.0
             forConstraints:^{
                 [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
             }];
        
    VFCMacroTrendsViewController *macroTrendsVC = [[VFCMacroTrendsViewController alloc] initWithMacroTrends:[VFCMacroTrend macroTrends]];
    [macroTrendsVC setMacroTrendsViewControllerDelegate:self];
    [pageViewController setViewControllers:@[macroTrendsVC]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:nil];
    self.currentViewController = macroTrendsVC;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.headerView moveCaratToPoint:CGPointMake(399.0, 0.0)];
}

#pragma mark VFCDocumentHeaderViewDelegate

- (void)documentHeaderView:(VFCDocumentHeaderView *)documentHeaderView didSelectButtonAtIndex:(NSInteger)index {
    [self showStep:index animated:YES check:YES];
}

#pragma mark VFCMacroTrendsViewControllerDelegate

- (void)macroTrendsViewController:(VFCMacroTrendsViewController *)macroTrendsViewController didSelectMacroTrend:(VFCMacroTrend *)macroTrend {
    self.document.macroTrend = macroTrend.title ? macroTrend.title : @"";
    NSArray *crumbTrails = [self.document uppercaseCrumbTrails];
    [[self.headerView crumbTrailView] updateComponents:crumbTrails];
}

#pragma mark VFCSegmentChoicesViewControllerDelegate

- (void)segmentChoicesViewController:(VFCSegmentChoicesViewController *)segmentChoicesViewController didSelectSegmentChoice:(VFCSegmentChoice *)segmentChoice {
    [[self document] setSegmentChoice:[segmentChoice title] ? [segmentChoice title] : @""];
    NSArray *crumbTrails = [[self document] uppercaseCrumbTrails];
    [[[self headerView] crumbTrailView] updateComponents:crumbTrails];
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
        if (step == currentStep) {
            if ([self.currentViewController isKindOfClass:[VFCMacroTrendsViewController class]]) {
                [(VFCMacroTrendsViewController *)self.currentViewController hideHeader];
            } else if ([self.currentViewController isKindOfClass:[VFCSegmentChoicesViewController class]]) {
                [(VFCSegmentChoicesViewController *)self.currentViewController hideHeader];
            }
        } else {
            [self showStep:step animated:animated];
        }
    } else {
        [self showStep:step animated:animated];
    }
}

- (void)showStep:(NSInteger)step animated:(BOOL)animated {
    if (step >= VFCDocumentStepMacroTrend && step <= VFCDocumentStepSolution) {
        [[self document] setStep:@(step)];
        [[[self headerView] nextButton] setTag:step];
        [[[self headerView] continueButton] setTag:step];
        
        UIViewController *vc = nil;
        switch (step) {
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
                vc = [[VFCSolutionViewController alloc] initWithDocument:self.document];
                break;
            }
        }
                
        [[self headerView] moveCaratToIndex:step];
        NSArray *crumbTrails = [[self document] uppercaseCrumbTrails];
        [[[self headerView] crumbTrailView] updateComponents:crumbTrails];
        
        if (vc) {
            self.currentViewController = vc;
            NSInteger currentStep = [[[self document] step] integerValue];
            [[self pageViewController] setViewControllers:@[vc]
                                                direction:(currentStep < step) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                                 animated:animated
                                               completion:nil];
        }
    }
}

- (void)continueToNextStep:(UIButton *)button {
    VFCDocumentStep step = [button tag];
    VFCDocumentStep nextStep = step+1;
    if (nextStep < VFCDocumentStepGapAnaysis || nextStep == VFCDocumentStepSolution) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VFCDocumentheaderViewHideNextButton object:nil];
    }
    [self showStep:step+1 animated:YES];
}

@end
