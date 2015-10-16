//
//  VFCSegmentChoicesViewController.m
//  RCAMPad
//

#import "VFCSegmentChoicesViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "VFCDeepDiveViewController.h"
#import "VFCPagesView.h"
#import "VFCPageView.h"
#import "VFCSegmentChoice.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"
#import "UIColor+VFCAdditions.h"
#import "UIImage+VFCAdditions.h"

#pragma mark - VFCSegmentChoiceHeaderView

#pragma mark - Private Interface

@interface VFCSegmentChoiceHeaderView : UICollectionReusableView
@property (nonatomic, strong, readwrite) VFCPagesView *pagesView;
@property (nonatomic, strong, readwrite) UIButton *infoButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@end

#pragma mark - Private Implementation

@implementation VFCSegmentChoiceHeaderView

#pragma mark Initialization

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

#pragma mark - VFCSegmentChoiceCell

#pragma mark - Private Interface

@interface VFCSegmentChoiceCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *label;
@end

#pragma mark - Private Implementation

@implementation VFCSegmentChoiceCell

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

@end

#pragma mark - VFCSegmentChoicesViewController

#pragma mark - Private Interface

static NSString *const VFCSegmentChoiceCellIdentifier = @"VFCSegmentChoiceCell";
static NSString *const VFCSegmentChoiceHeaderViewIdentifier = @"VFCSegmentChoiceHeaderView";

@interface VFCSegmentChoicesViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, readwrite) NSArray *segmentChoices;
@property (nonatomic, assign, readwrite) BOOL showHeaderView;
@end

@implementation VFCSegmentChoicesViewController

#pragma mark Initialization

- (instancetype)initWithSegmentChoices:(NSArray *)segmentChoices {
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(1024.0/2.0, 206.0);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.segmentChoices = segmentChoices;
        self.showHeaderView = NO;
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[VFCSegmentChoiceCell class] forCellWithReuseIdentifier:VFCSegmentChoiceCellIdentifier];
    [self.collectionView registerClass:[VFCSegmentChoiceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VFCSegmentChoiceHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[VFCSpeakerNotesManager speakerNotesManager] setSpeakerNotesKey:@"SegmentChoice"];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.segmentChoices.count;
    NSInteger rem = count % 1;
    return count + rem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCSegmentChoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFCSegmentChoiceCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.segmentChoices.count) {
        VFCSegmentChoice *choice = [self.segmentChoices objectAtIndex:indexPath.row];
        [cell.label setText:choice.title.uppercaseString];
        UIImage *image = [UIImage imageNamed:choice.imageName];
        cell.imageView.image = image;
    } else {
        cell.label.text = nil;
        cell.imageView.image = nil;
    }
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.showHeaderView = YES;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    if (indexPath.row < self.segmentChoices.count) {
        VFCSegmentChoice *choice = [self.segmentChoices objectAtIndex:indexPath.row];
        if ([self.segmentChoicesViewControllerDelegate respondsToSelector:@selector(segmentChoicesViewController:didSelectSegmentChoice:)]) {
            [self.segmentChoicesViewControllerDelegate segmentChoicesViewController:self didSelectSegmentChoice:choice];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        VFCSegmentChoiceHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                    withReuseIdentifier:VFCSegmentChoiceHeaderViewIdentifier
                                                                                           forIndexPath:indexPath];
        NSMutableArray *pageViews = [NSMutableArray array];
        NSArray *imageNames = @[@"DummyLayout", @"DummyLayout", @"DummyLayout", @"DummyLayout", @"DummyLayout"];
        for (NSInteger i=0; i<imageNames.count; i++) {
            VFCPageView *pageView = [VFCPageView newAutoLayoutView];
            pageView.imageView.image = [UIImage imageNamed:imageNames[i]];
            [pageViews addObject:pageView];
        }
        headerView.pagesView.pageViews = pageViews;
        
        [headerView.infoButton addTarget:self action:@selector(didSelectInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.closeButton addTarget:self action:@selector(hideHeader) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hideHeader)];
        [headerView addGestureRecognizer:tapRecognizer];
        
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.showHeaderView ? collectionView.frame.size : CGSizeZero;
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
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        if ([self.segmentChoicesViewControllerDelegate respondsToSelector:@selector(segmentChoicesViewController:didSelectSegmentChoice:)]) {
            [self.segmentChoicesViewControllerDelegate segmentChoicesViewController:self didSelectSegmentChoice:nil];
        }
    }
}

- (void)didSelectInfoButton:(UIButton *)button {
    NSArray *imageNames = nil;
    NSString *speakerNotesID = [NSString stringWithFormat:@"Millenials"];
    VFCDeepDiveSlidingViewController *slidingVC = [[VFCDeepDiveSlidingViewController alloc] initWithImageNames:imageNames speakerNotesIdentifier:speakerNotesID];
    [self presentViewController:slidingVC animated:YES completion:nil];
}

@end
