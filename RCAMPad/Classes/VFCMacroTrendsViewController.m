//
//  VFCMacroTrendsViewController.m
//  RCAMPad
//

#import "VFCMacroTrendsViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "VFCDeepDiveViewController.h"
#import "VFCMacroTrend.h"
#import "VFCPagesView.h"
#import "VFCPageView.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"
#import "UIColor+VFCAdditions.h"
#import "UIImage+VFCAdditions.h"

#pragma mark - VFCHeaderView

#pragma mark - Private Interface

@interface VFCHeaderView : UICollectionReusableView
@property (nonatomic, strong, readwrite) UIButton *selectButton;
@property (nonatomic, strong, readwrite) UIButton *unselectButton;
@property (nonatomic, strong, readwrite) UIButton *infoButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, strong, readwrite) VFCPagesView *pagesView;
@end

#pragma mark - Private Implementation

@implementation VFCHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        VFCPagesView *pagesView = [VFCPagesView newAutoLayoutView];
        self.pagesView = pagesView;
        [self addSubview:pagesView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [self addSubview:button];
        self.infoButton = button;
        
        UIButton *closeButton = [UIButton newAutoLayoutView];
        UIImage *image = [UIImage imageNamed:@"Close"];
        image = [image tintedImageWithColor:[UIColor blueColor]];
        [closeButton setImage:image forState:UIControlStateNormal];
        [self addSubview:closeButton];
        self.closeButton = closeButton;
        
        [NSLayoutConstraint autoSetPriority:999.0
                 forConstraints:^{
                     [pagesView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                     [button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
                     [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
                     
                     [closeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
                     [closeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
                 }];
    }
    return self;
}

@end

#pragma mark - VFCMacroTrendCell

#pragma mark - Private Interface

@interface VFCMacroTrendCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *label;
@property (nonatomic, strong, readwrite) UILabel *comingSoonLabel;
@property (nonatomic, strong, readwrite) UIView *overlayView;
@end

#pragma mark - Private Implementation

@implementation VFCMacroTrendCell

#pragma mark Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *layer = self.contentView.layer;
        layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        layer.borderWidth = 0.5;
        
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UIView *overlayView = [UIView newAutoLayoutView];
        overlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        self.overlayView = overlayView;
        [imageView addSubview:overlayView];
        
        UILabel *comingSoonLabel = [UILabel newAutoLayoutView];
        comingSoonLabel.textAlignment = NSTextAlignmentCenter;
        comingSoonLabel.font = [UIFont boldSystemFontOfSize:30.0];
        comingSoonLabel.numberOfLines = 2;
        comingSoonLabel.text = NSLocalizedString(@"COMING SOON", @"kComingSoon");
        [overlayView addSubview:comingSoonLabel];
        
        [NSLayoutConstraint autoSetPriority:999.0
                 forConstraints:^{
                     [overlayView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                     [comingSoonLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
                 }];
        
        UILabel *label = [UILabel newAutoLayoutView];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:30.0];
        label.textColor = [UIColor venturaFoodsBlueColor];
        label.numberOfLines = 0;
        [[self contentView] addSubview:label];
        self.label = label;
        
        [NSLayoutConstraint autoSetPriority:999.0
                 forConstraints:^{
                     [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
                     [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0];
                     [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0];
                     [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:imageView];
                     
                     [label autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
                     [label autoPinEdgeToSuperviewEdge:ALEdgeTop];
                     [label autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                     [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:10.0];
                 }];
    }
    return self;
}

- (void)enable:(BOOL)enable {
    self.overlayView.hidden = enable;
    self.label.textColor = [[UIColor venturaFoodsBlueColor] colorWithAlphaComponent:enable ? 1.0 : 0.5];
}

@end

#pragma mark - VFCMacroTrendsViewController

#pragma mark - Private Interface

static NSString *const VFCMacroTrendCellIdentifier = @"VFCMacroTrendCell";
static NSString *const VFCHeaderViewIdentifier = @"VFCHeaderView";

@interface VFCMacroTrendsViewController () <UICollectionViewDelegateFlowLayout, VFCPagesViewDelegate>
@property (nonatomic, strong, readwrite) NSArray *macroTrends;
@property (nonatomic, assign, readwrite) BOOL showHeaderView;
@property (nonatomic, strong, readwrite) VFCHeaderView *headerView;
@property (nonatomic, strong, readwrite) VFCMacroTrend *macroTrend;
@property (nonatomic, strong, readwrite) NSString *speakerNotesKey;
@end

#pragma mark - Public Implementation

@implementation VFCMacroTrendsViewController

#pragma mark Initialization

- (instancetype)initWithMacroTrends:(NSArray *)macroTrends {
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(1024.0/2.0, 309.0);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.macroTrends = macroTrends;
        self.showHeaderView = NO;
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[VFCMacroTrendCell class] forCellWithReuseIdentifier:VFCMacroTrendCellIdentifier];
    [self.collectionView registerClass:[VFCHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VFCHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[VFCSpeakerNotesManager speakerNotesManager] setSpeakerNotesKey:@"MacroTrends"];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.macroTrends.count;
    NSInteger rem = count % 1;
    return self.macroTrends.count + rem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCMacroTrendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFCMacroTrendCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.macroTrends.count) {
        VFCMacroTrend *trend = [self.macroTrends objectAtIndex:indexPath.row];
        cell.label.text = trend.title.uppercaseString;
        UIImage *image = [UIImage imageNamed:trend.imageName];
        cell.imageView.image = image;
        [cell enable:trend.pages.count > 0];
    } else {
        cell.label.text = nil;
        cell.imageView.image = nil;
    }
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCMacroTrend *trend = [[self.macroTrends objectAtIndex:indexPath.row] copy];
    if (trend.pages.count > 0) {
        self.showHeaderView = YES;
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        if ([self.macroTrendsViewControllerDelegate respondsToSelector:@selector(macroTrendsViewController:didSelectMacroTrend:)]) {
            self.macroTrend = trend;
            [self.macroTrendsViewControllerDelegate macroTrendsViewController:self didSelectMacroTrend:trend];
            
            self.speakerNotesKey = [NSString stringWithFormat:@"%@1", self.macroTrend.identifier];
            [VFCSpeakerNotesManager speakerNotesManager].speakerNotesKey = self.speakerNotesKey;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        VFCHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:VFCHeaderViewIdentifier forIndexPath:indexPath];
        NSMutableArray *pageViews = [NSMutableArray array];
        VFCMacroTrend *macroTrend = self.macroTrends[indexPath.row];
        for (VFCMacroTrendPage *page in macroTrend.pages) {
            VFCPageView *pageView = [VFCPageView newAutoLayoutView];
            pageView.imageView.image = [UIImage imageNamed:page.imageName];
            [pageViews addObject:pageView];
        }
        headerView.pagesView.pageViews = pageViews;
        headerView.backgroundColor = [UIColor whiteColor];
        
        [headerView.infoButton addTarget:self action:@selector(didSelectInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.closeButton addTarget:self action:@selector(hideHeader) forControlEvents:UIControlEventTouchUpInside];
        
        headerView.pagesView.delegate = self;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hideHeader)];
        [headerView addGestureRecognizer:tapRecognizer];
        
        self.headerView = headerView;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.showHeaderView ? collectionView.frame.size : CGSizeZero;
}

#pragma mark VFCPagesViewDelegate

- (void)pagesView:(VFCPagesView *)pagesView didUpdatePage:(NSInteger)page {
    VFCMacroTrend *macroTrend = self.macroTrend;
    self.speakerNotesKey = [NSString stringWithFormat:@"%@%i", macroTrend.identifier, page+1];
    [VFCSpeakerNotesManager speakerNotesManager].speakerNotesKey = self.speakerNotesKey;
}

#pragma mark Private

- (void)setShowHeaderView:(BOOL)showHeaderView {
    if (_showHeaderView != showHeaderView) {
        _showHeaderView = showHeaderView;
        [self.collectionView setScrollEnabled:!_showHeaderView];
    }
}

- (void)hideHeader {
    if (self.showHeaderView) {
        self.showHeaderView = NO;
        [VFCSpeakerNotesManager speakerNotesManager].speakerNotesKey = @"MacroTrends";
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        if ([self.macroTrendsViewControllerDelegate respondsToSelector:@selector(macroTrendsViewController:didSelectMacroTrend:)]) {
            [self.macroTrendsViewControllerDelegate macroTrendsViewController:self didSelectMacroTrend:nil];
        }
    }
}

- (void)didSelectInfoButton:(UIButton *)button {
    NSInteger index = self.headerView.pagesView.pageControl.currentPage;
    VFCMacroTrendPage *page = self.macroTrend.pages[index];
    NSArray *imageNames = page.deepDiveImageNames;
    VFCDeepDiveSlidingViewController *slidingVC = [[VFCDeepDiveSlidingViewController alloc] initWithImageNames:imageNames speakerNotesIdentifier:self.speakerNotesKey];
    [self presentViewController:slidingVC animated:YES completion:nil];
}

@end
