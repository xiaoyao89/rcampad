//
//  VFCDeepDiveViewController.m
//  RCAMPad
//

#import "VFCDeepDiveViewController.h"
#import "VFCSpeakerNotesManager.h"
#import "VFCSpeakerNotesViewController.h"
#import "PureLayout.h"
#import "UIViewController+ECSlidingViewController.h"

#pragma mark - VFCDeepDiveSlidingViewController

@implementation VFCDeepDiveSlidingViewController

- (instancetype)initWithImageNames:(NSArray *)imageNames speakerNotesIdentifier:(NSString *)speakerNotesIdentifier {
    VFCDeepDiveViewController *deepDiveVC = [[VFCDeepDiveViewController alloc] initWithImageNames:imageNames speakerNotesIdentifier:speakerNotesIdentifier];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:deepDiveVC];
    self = [super initWithTopViewController:navController];
    if (self) {
        [[deepDiveVC view] addGestureRecognizer:[self panGesture]];
        [self setAnchorRightRevealAmount:320.0];
        [self setAnchorLeftRevealAmount:320.0];
        
        VFCSpeakerNotesViewController *speakerNotesVC = [[VFCSpeakerNotesViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:speakerNotesVC];
        [navController setEdgesForExtendedLayout:UIRectEdgeTop|UIRectEdgeBottom|UIRectEdgeRight];
        [self setUnderRightViewController:navController];
        
        CALayer *layer = [[[self topViewController] view] layer];
        [layer setShadowColor:[[UIColor blackColor] CGColor]];
        [layer setShadowRadius:1.0];
        [layer setShadowOpacity:0.25];
    }
    return self;
}

@end

#pragma mark - VFCDeepDiveViewController

#pragma mark - Private Interface

@interface VFCDeepDiveViewController () <UIScrollViewDelegate>
@property (nonatomic, strong, readwrite) NSArray *imageNames;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;
@property (nonatomic, strong, readwrite) NSString *speakerNotesIdentifier;
@end

#pragma mark - Public Implementation

@implementation VFCDeepDiveViewController

- (instancetype)initWithImageNames:(NSArray *)imageNames speakerNotesIdentifier:(NSString *)speakerNotesIdentifier {
    self = [super init];
    if (self) {
        self.imageNames = imageNames;
        self.speakerNotesIdentifier = speakerNotesIdentifier;
        [VFCSpeakerNotesManager speakerNotesManager].speakerNotesKey = [NSString stringWithFormat:@"%@DeepDive1", self.speakerNotesIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(dismiss)];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [self setTitle:@"Deep Dive"];
        
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                              target:self
                                                                              action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = stopItem;
    
    UIBarButtonItem *speakerNotesItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(toggleSpeakerNotes)];
    self.navigationItem.rightBarButtonItem = speakerNotesItem;
    
    if (self.imageNames.count > 1) {
        UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setDelegate:self];
        [self setScrollView:scrollView];
        [self.view addSubview:scrollView];
        
        UIPageControl *pageControl = [UIPageControl newAutoLayoutView];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];
        [pageControl setNumberOfPages:self.imageNames.count];
        [pageControl setCurrentPage:0];
        [self setPageControl:pageControl];
        [self.view addSubview:pageControl];
        
        [NSLayoutConstraint autoSetPriority:999.0
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
        
        for (NSString *imageName in self.imageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [UIImageView newAutoLayoutView];
            [imageView setImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [scrollView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        }
        
        [[scrollView subviews] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0];
    } else {
        NSString *imageName = [self.imageNames firstObject];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    CGSize contentSize = [self.scrollView contentSize];
    contentSize.width = self.imageNames.count * self.view.frame.size.width;
    contentSize.height = self.view.frame.size.height-self.pageControl.frame.size.height;
    self.scrollView.contentSize = contentSize;
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [scrollView contentOffset].x / [scrollView frame].size.width;
    [[self pageControl] setCurrentPage:page];
    
    NSString *speakerNotesID = [NSString stringWithFormat:@"%@DeepDive%i", self.speakerNotesIdentifier, self.pageControl.currentPage+1];
    [VFCSpeakerNotesManager speakerNotesManager].speakerNotesKey = speakerNotesID;
}

#pragma mark Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleSpeakerNotes {
    ECSlidingViewController *slidingVC = self.slidingViewController;
    if (slidingVC.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [slidingVC anchorTopViewToLeftAnimated:YES];
    } else {
        [slidingVC resetTopViewAnimated:YES];
    }
}

@end
