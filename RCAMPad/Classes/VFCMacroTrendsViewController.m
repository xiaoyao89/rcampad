//
//  VFCMacroTrendsViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/22/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "VFCMacroTrendsViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "VFCMacroTrend.h"
#import "VFCPagesView.h"
#import "VFCPageView.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"
#import "UIColor+VFCAdditions.h"

#pragma mark - VFCHeaderView

#pragma mark - Private Interface

@interface VFCHeaderView : UICollectionReusableView
@property (nonatomic, strong, readwrite) UIButton *selectButton;
@property (nonatomic, strong, readwrite) UIButton *unselectButton;
@property (nonatomic, strong, readwrite) UIButton *infoButton;
@property (nonatomic, strong, readwrite) VFCPagesView *pagesView;
@end

#pragma mark - Private Implementation

@implementation VFCHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        VFCPagesView *pagesView = [VFCPagesView newAutoLayoutView];
        [self setPagesView:pagesView];
        [self addSubview:pagesView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [self addSubview:button];
        [self setInfoButton:button];
        
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [pagesView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                     [button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
                     [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
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
@property (nonatomic, strong, readwrite) UIView *overlayView;
@end

#pragma mark - Private Implementation

@implementation VFCMacroTrendCell

#pragma mark Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [imageView setContentMode:UIViewContentModeCenter];
        [[self contentView] addSubview:imageView];
        [self setImageView:imageView];
        
        UIView *overlayView = [UIView newAutoLayoutView];
        [overlayView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        [[self contentView] addSubview:overlayView];
        [self setOverlayView:overlayView];
        
        UILabel *label = [UILabel newAutoLayoutView];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:30.0]];
        [label setTextColor:[UIColor venturaBlueColor]];
        [label setNumberOfLines:0];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                     [overlayView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                     [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
                 }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [[self overlayView] setBackgroundColor:highlighted ? [UIColor clearColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.5]];
}

@end

#pragma mark - VFCMacroTrendsViewController

#pragma mark - Private Interface

static NSString *const VFCMacroTrendCellIdentifier = @"VFCMacroTrendCell";
static NSString *const VFCHeaderViewIdentifier = @"VFCHeaderView";

@interface VFCMacroTrendsViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, readwrite) NSArray *macroTrends;
@property (nonatomic, assign, readwrite) BOOL showHeaderView;
@end

#pragma mark - Public Implementation

@implementation VFCMacroTrendsViewController

#pragma mark Initialization

- (instancetype)initWithMacroTrends:(NSArray *)macroTrends {
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    [layout setSectionInset:UIEdgeInsetsZero];
    [layout setMinimumInteritemSpacing:0.0];
    [layout setMinimumLineSpacing:0.0];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setItemSize:CGSizeMake(1024.0/2.0, 309.0)];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self setMacroTrends:macroTrends];
        [self setShowHeaderView:NO];
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self collectionView] setBackgroundColor:[UIColor whiteColor]];
    [[self collectionView] registerClass:[VFCMacroTrendCell class] forCellWithReuseIdentifier:VFCMacroTrendCellIdentifier];
    [[self collectionView] registerClass:[VFCHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VFCHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[VFCSpeakerNotesManager speakerNotesManager] setSpeakerNotesKey:@"Millenials1"];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[self macroTrends] count];
    NSInteger rem = count % 3;
    return [[self macroTrends] count] + rem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCMacroTrendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFCMacroTrendCellIdentifier forIndexPath:indexPath];
    if ([indexPath row] < [[self macroTrends] count]) {
        VFCMacroTrend *trend = [[self macroTrends] objectAtIndex:[indexPath row]];
        [[cell label] setText:[[trend title] uppercaseString]];
        [[cell overlayView] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        UIImage *image = [UIImage imageNamed:[trend imageName]];
        [[cell imageView] setImage:image];
    } else {
        [[cell label] setText:nil];
        [[cell imageView] setImage:nil];
        [[cell overlayView] setBackgroundColor:[UIColor clearColor]];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setShowHeaderView:YES];
    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    if ([[self macroTrendsViewControllerDelegate] respondsToSelector:@selector(macroTrendsViewController:didSelectMacroTrend:)]) {
        VFCMacroTrend *trend = [[[self macroTrends] objectAtIndex:[indexPath row]] copy];
        [[self macroTrendsViewControllerDelegate] macroTrendsViewController:self didSelectMacroTrend:trend];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        VFCHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:VFCHeaderViewIdentifier forIndexPath:indexPath];
        NSMutableArray *pageViews = [NSMutableArray array];
        NSArray *imageNames = @[@"Millenials_1", @"MillenialsLayout_1", @"Millenials_2", @"MillenialsLayout_2", @"Millenials_3", @"MillenialsLayout_3"];
        for (NSInteger i=0; i<[imageNames count]; i++) {
            VFCPageView *pageView = [VFCPageView newAutoLayoutView];
            [[pageView imageView] setImage:[UIImage imageNamed:imageNames[i]]];
            [pageViews addObject:pageView];
        }
        [[headerView pagesView] setPageViews:pageViews];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(hideHeader:)];
        [headerView addGestureRecognizer:recognizer];
        
        [[headerView infoButton] addTarget:self action:@selector(didSelectInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self showHeaderView] ? [collectionView frame].size : CGSizeZero;
}

#pragma mark Private

- (void)setShowHeaderView:(BOOL)showHeaderView {
    if (_showHeaderView != showHeaderView) {
        _showHeaderView = showHeaderView;
        [[self collectionView] setScrollEnabled:!_showHeaderView];
    }
}

- (void)hideHeader:(UITapGestureRecognizer *)recognizer {
    [self setShowHeaderView:NO];
    [[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:0]];
    if ([[self macroTrendsViewControllerDelegate] respondsToSelector:@selector(macroTrendsViewController:didSelectMacroTrend:)]) {
        [[self macroTrendsViewControllerDelegate] macroTrendsViewController:self didSelectMacroTrend:nil];
    }
}

- (void)didSelectInfoButton:(UIButton *)button {
    if ([[self macroTrendsViewControllerDelegate] respondsToSelector:@selector(macroTrendsViewControllerDidSelectInfoButton:)]) {
        [[self macroTrendsViewControllerDelegate] macroTrendsViewControllerDidSelectInfoButton:self];
    }
}

@end
