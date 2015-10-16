//
//  VFCPageView.m
//  RCAMPad
//

#import "VFCPageView.h"
#import "PureLayout.h"

#pragma mark - VFCPageView

#pragma mark - Private Interface

@interface VFCPageView()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@end

#pragma mark - Public Implementation

@implementation VFCPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self setImageView:imageView];
        [self addSubview:imageView];
        [NSLayoutConstraint autoSetPriority:999.0
                 forConstraints:^{
                     [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                 }];
    }
    return self;
}

@end