//
//  VFCSegmentChoicesViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCSegmentChoicesViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "VFCPagesView.h"
#import "VFCPageView.h"
#import "VFCSegmentChoice.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"
#import "UIColor+VFCAdditions.h"

#pragma mark - VFCSegmentChoiceHeaderView

#pragma mark - Private Interface

@interface VFCSegmentChoiceHeaderView : UICollectionReusableView
@property (nonatomic, strong, readwrite) VFCPagesView *pagesView;
@property (nonatomic, strong, readwrite) UIButton *infoButton;
@end

#pragma mark - Private Implementation

@implementation VFCSegmentChoiceHeaderView

#pragma mark Initialization

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

#pragma mark - VFCSegmentChoiceCell

#pragma mark - Private Interface

@interface VFCSegmentChoiceCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *label;
@property (nonatomic, strong, readwrite) UIView *overlayView;
@end

#pragma mark - Private Implementation

@implementation VFCSegmentChoiceCell

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
    [layout setSectionInset:UIEdgeInsetsZero];
    [layout setMinimumInteritemSpacing:0.0];
    [layout setMinimumLineSpacing:0.0];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setItemSize:CGSizeMake(1024.0/3.0, 309.0)];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self setSegmentChoices:segmentChoices];
        [self setShowHeaderView:NO];
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self collectionView] setBackgroundColor:[UIColor whiteColor]];
    [[self collectionView] registerClass:[VFCSegmentChoiceCell class] forCellWithReuseIdentifier:VFCSegmentChoiceCellIdentifier];
    [[self collectionView] registerClass:[VFCSegmentChoiceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VFCSegmentChoiceHeaderViewIdentifier];
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
    NSInteger count = [[self segmentChoices] count];
    NSInteger rem = count % 3;
    return count + rem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCSegmentChoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFCSegmentChoiceCellIdentifier forIndexPath:indexPath];
    if ([indexPath row] < [[self segmentChoices] count]) {
        VFCSegmentChoice *choice = [[self segmentChoices] objectAtIndex:[indexPath row]];
        [[cell label] setText:[[choice title] uppercaseString]];
        [[cell overlayView] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        UIImage *image = [UIImage imageNamed:[choice imageName]];
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
    [[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    if ([indexPath row] < [[self segmentChoices] count]) {
        VFCSegmentChoice *choice = [[self segmentChoices] objectAtIndex:[indexPath row]];
        if ([[self segmentChoicesViewControllerDelegate] respondsToSelector:@selector(segmentChoicesViewController:didSelectSegmentChoice:)]) {
            [[self segmentChoicesViewControllerDelegate] segmentChoicesViewController:self didSelectSegmentChoice:choice];
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
        for (NSInteger i=0; i<[imageNames count]; i++) {
            VFCPageView *pageView = [VFCPageView newAutoLayoutView];
            [[pageView imageView] setImage:[UIImage imageNamed:imageNames[i]]];
            [pageViews addObject:pageView];
        }
        [[headerView pagesView] setPageViews:pageViews];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(hideHeader:)];
        [headerView addGestureRecognizer:recognizer];
        
        [[headerView infoButton] addTarget:self action:@selector(didSelectInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerView setBackgroundColor:[UIColor whiteColor]];
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
    if ([[self segmentChoicesViewControllerDelegate] respondsToSelector:@selector(segmentChoicesViewController:didSelectSegmentChoice:)]) {
        [[self segmentChoicesViewControllerDelegate] segmentChoicesViewController:self didSelectSegmentChoice:nil];
    }
}

- (void)didSelectInfoButton:(UIButton *)button {
    if ([[self segmentChoicesViewControllerDelegate] respondsToSelector:@selector(segmentChoicesViewControllerDidSelectInfoButton:)]) {
        [[self segmentChoicesViewControllerDelegate] segmentChoicesViewControllerDidSelectInfoButton:self];
    }
}

@end
