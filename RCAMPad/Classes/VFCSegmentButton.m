//
//  VFCSegmentButton.m
//  RCAMPad
//

#import "VFCSegmentButton.h"
#import "PureLayout.h"

#pragma mark - VFCSegmentButton

#pragma mark - Private Interface

@interface VFCSegmentButton()
@property (nonatomic, strong, readwrite) UILabel *label;
@property (nonatomic, strong, readwrite) UIImageView *iconImageView;
@end

#pragma mark - Public Implementation

@implementation VFCSegmentButton

- (instancetype)init {
    self = [super init];
    if (self) {
        UILabel *label = [UILabel newAutoLayoutView];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:12.0]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"TEXT"];
        [self addSubview:label];
        [self setLabel:label];
        
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:imageView];
        [self setIconImageView:imageView];
        
        [label autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0];
        [label autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [label autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [label autoSetDimension:ALDimensionHeight toSize:30.0];
        [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView];
    }
    return self;
}

@end
