//
//  VFCRecipesViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 2/2/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCRecipesViewController.h"
#import "PureLayout.h"

#pragma mark - VFCRecipeCell

#pragma mark - Private Interface

@interface VFCRecipeCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *label;
@end

#pragma mark - Private Implementation

@implementation VFCRecipeCell

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

#pragma mark - VFCRecipesViewController

#pragma mark - Private Interface

@interface VFCRecipesViewController ()
@end

#pragma mark - Public Implementation

@implementation VFCRecipesViewController

static NSString * const VFCRecipeCellIdentifier = @"VFCRecipeCell";

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
    [self.collectionView registerClass:[VFCRecipeCell class] forCellWithReuseIdentifier:VFCRecipeCellIdentifier];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCRecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFCRecipeCellIdentifier forIndexPath:indexPath];
    
    NSInteger remainder = [indexPath row] % 3 + 1;
    NSString *imageName = [NSString stringWithFormat:@"Dummy%i", remainder];
    [[cell imageView] setImage:[UIImage imageNamed:imageName]];
    
    [[cell label] setText:[NSString stringWithFormat:@"Recipe %i", [indexPath row]+1]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VFCRecipeCell *cell = (VFCRecipeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGFloat alpha = ([cell alpha] == 1.0) ? 0.5 : 1.0;
    [cell setAlpha:alpha];
}

@end
