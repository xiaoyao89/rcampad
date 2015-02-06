//
//  VFCProductsViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 2/2/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCProductsViewController.h"
#import "PureLayout.h"

#pragma mark - VFCProductCell

#pragma mark - Private Interface

@interface VFCProductCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *label;
@end

#pragma mark - Private Implementation

@implementation VFCProductCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [[self contentView] addSubview:imageView];
        [self setImageView:imageView];
        
        UILabel *label = [UILabel newAutoLayoutView];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:17.0]];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
                     [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                     [imageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
                     
                     [label autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                     [label autoPinEdgeToSuperviewEdge:ALEdgeRight];
                     [label autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                     [label autoSetDimension:ALDimensionHeight toSize:40.0];
                     
                     [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:label];
                 }];
    }
    return self;
}

@end

#pragma mark - VFCProductsViewController

#pragma mark - Private Interface

@interface VFCProductsViewController ()
@end

#pragma mark - Public Implementation

@implementation VFCProductsViewController

static NSString * const VFCProductCellIdentifier = @"VFCProductCell";

#pragma mark Initialization

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:0.0];
    [layout setMinimumLineSpacing:0.0];
    [layout setItemSize:CGSizeMake(256.0, 256.0)];
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = 15.0;
    [layout setSectionInset:insets];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[VFCProductCell class] forCellWithReuseIdentifier:VFCProductCellIdentifier];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFCProductCellIdentifier forIndexPath:indexPath];
    
    NSInteger remainder = [indexPath row] % 3 + 1;
    NSString *imageName = [NSString stringWithFormat:@"Dummy%i", remainder];
    [[cell imageView] setImage:[UIImage imageNamed:imageName]];
    
    [[cell label] setText:[NSString stringWithFormat:@"Product %i", [indexPath row]+1]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCProductCell *cell = (VFCProductCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGFloat alpha = ([cell alpha] == 1.0) ? 0.5 : 1.0;
    [cell setAlpha:alpha];
}

@end
