//
//  VFCDocumentHeaderView.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/18/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "VFCDocumentHeaderView.h"
#import "VFCCarat.h"
#import "VFCCrumbTrailView.h"
#import "VFCSegmentButton.h"
#import "PureLayout.h"
#import "UIColor+VFCAdditions.h"
#import "UIImage+VFCAdditions.h"

#pragma mark - VFCDocumentHeaderView

#pragma mark - Private Interface

@interface VFCDocumentHeaderView()
@property (nonatomic, strong, readwrite) VFCCarat *carat;

@property (nonatomic, strong, readwrite) UIButton *informationButton;

@property (nonatomic, strong, readwrite) NSArray *segmentButtons;
@property (nonatomic, strong, readwrite) VFCSegmentButton *selectedSegmentButton;

@property (nonatomic, strong, readwrite) VFCCrumbTrailView *crumbTrailView;

@property (nonatomic, strong, readwrite) UIColor *selectedColor;

@end

#pragma mark - Public Implementation

@implementation VFCDocumentHeaderView

#pragma mark Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSelectedColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        
        UIView *topView = [UIView newAutoLayoutView];
        [topView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:topView];
        
        UIView *bottomView = [UIView newAutoLayoutView];
        [bottomView setBackgroundColor:[UIColor venturaBlueColor]];
        [self addSubview:bottomView];
        
        [topView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [topView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [topView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [bottomView autoSetDimension:ALDimensionHeight toSize:50.0];
        
        [topView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:bottomView];
        
        UIButton *button = [UIButton newAutoLayoutView];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:[UIImage imageNamed:@"HeaderIcon"] forState:UIControlStateNormal];
        [topView addSubview:button];
        [self setInformationButton:button];
        
        [button autoSetDimension:ALDimensionWidth toSize:316.0];
        [button autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [button autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        UIView *buttonsContainer = [UIView newAutoLayoutView];
        [buttonsContainer setBackgroundColor:[UIColor clearColor]];
        [topView addSubview:buttonsContainer];
        
        [buttonsContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:[self informationButton]];
        [buttonsContainer autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [buttonsContainer autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [buttonsContainer autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        NSMutableArray *buttons = [NSMutableArray array];
        
        NSArray *imageIDs = @[@"MacroTrend", @"MacroTrend", @"SegmentChoice", @"SuggestedSolution", @"SuggestedSolution"];
        NSArray *imageNames = @[@"MacroTrend", @"MacroTrend", @"SegmentChoice", @"SuggestedSolution", @"SuggestedSolution"];
        NSArray *textStrings = @[@"OVERVIEW", @"MACRO TREND", @"SEGMENT CHOICE", @"GAP ANALYSIS", @"SOLUTION"];
        NSInteger count = [imageIDs count];
        for (NSInteger i=0; i<count; i++) {
            VFCSegmentButton *button = [VFCSegmentButton newAutoLayoutView];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(moveCarat:) forControlEvents:UIControlEventTouchUpInside];
            
            // Image ID
            NSString *imageID = imageIDs[i];
            [button setImageIdentifier:imageID];
            
            // Image
            NSString *imageName = imageNames[i];
            UIImage *image = [UIImage imageNamed:imageName];
            image = [image tintedImageWithColor:[self selectedColor]];
            [[button iconImageView] setImage:image];
            
            // Label
            [[button label] setTextColor:[self selectedColor]];
            NSString *text = textStrings[i];
            [[button label] setText:text];
            
            [button setTag:i];
            [button addTarget:self action:@selector(moveCarat:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsContainer addSubview:button];

            [button autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            
            [buttons addObject:button];
        }
        [buttons autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0];
        
        // Carat
        VFCCarat *carat = [VFCCarat newAutoLayoutView];
        button = [buttons firstObject];
        [carat setFrame:CGRectMake([button frame].origin.x-0.5*[button frame].size.width, [topView frame].size.height-15.0, 30.0, 15.0)];
        [carat setBackgroundColor:[UIColor clearColor]];
        [self setCarat:carat];
        [topView addSubview:carat];
        [carat autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [carat autoSetDimensionsToSize:CGSizeMake(30.0, 15.0)];
        
        // Crumbtrail view
        VFCCrumbTrailView *ctView = [VFCCrumbTrailView newAutoLayoutView];
        [ctView setBackgroundColor:[UIColor clearColor]];
        [bottomView addSubview:ctView];
        [self setCrumbTrailView:ctView];
        [ctView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
        
        [self setSegmentButtons:[NSArray arrayWithArray:buttons]];
    }
    return self;
}

#pragma mark Public

- (void)moveCaratToIndex:(NSInteger)index {
    [self moveCarat:[[self segmentButtons] objectAtIndex:index]];
}

#pragma mark Private

- (void)moveCarat:(VFCSegmentButton *)button {
    if (![button isEqual:[self selectedSegmentButton]]) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             CGRect frame = [[self carat] frame];
                             frame.origin.x = [button frame].origin.x + 0.5*([button frame].size.width-frame.size.width) + [[self informationButton] frame].size.width;
                             frame.origin.y = [[[self carat] superview] frame].size.height - frame.size.height;
                             [[self carat] setFrame:frame];
                         }];
        
        [[self selectedSegmentButton] setBackgroundColor:[UIColor clearColor]];
        [[[self selectedSegmentButton] label] setTextColor:[self selectedColor]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [[self selectedSegmentButton] imageIdentifier]]];
        image = [image tintedImageWithColor:[self selectedColor]];
        [[[self selectedSegmentButton] iconImageView] setImage:image];
        
        [button setBackgroundColor:[self selectedColor]];
        [[button label] setTextColor:[UIColor whiteColor]];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Filled", [button imageIdentifier]]];
        image = [image tintedImageWithColor:[UIColor whiteColor]];
        [[button iconImageView] setImage:image];
        [self setSelectedSegmentButton:button];
        if ([[self delegate] respondsToSelector:@selector(documentHeaderView:didSelectButtonAtIndex:)]) {
            [[self delegate] documentHeaderView:self didSelectButtonAtIndex:[button tag]];
        }
    }
}

@end
