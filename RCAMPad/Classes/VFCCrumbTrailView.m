//
//  VFCCrumbTrailView.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/19/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "VFCCrumbTrailView.h"
#import "PureLayout.h"
#import "UIColor+VFCAdditions.h"

#pragma mark - VFCCrumbTrailCarat

#pragma mark - Private Interface

@interface VFCCrumbTrailCarat : UIView
@end

@implementation VFCCrumbTrailCarat

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGPoint point = CGPointZero;
    CGContextMoveToPoint(context, point.x, point.y);
    point = CGPointMake(rect.size.width, 0.5*rect.size.height);
    CGContextAddLineToPoint(context, point.x, point.y);
    point = CGPointMake(0.0, rect.size.height);
    CGContextAddLineToPoint(context, point.x, point.y);
    point = CGPointZero;
    CGContextAddLineToPoint(context, point.x, point.y);
    
    [[UIColor venturaBlueColor] setFill];
    CGContextFillPath(context);
}

@end

#pragma mark - VFCCrumbTrailView

#pragma mark - Private Interface

@interface VFCCrumbTrailView()
@property (nonatomic, strong, readwrite) NSArray *components;
@end

#pragma mark - Public Implementation

@implementation VFCCrumbTrailView

- (void)updateComponents:(NSArray *)titles {
    if (titles) {
        for (UIView *subview in [self components]) {
            [subview removeFromSuperview];
        }
        
        NSMutableArray *components = [NSMutableArray array];
        CGFloat xOffset = 0.0;
        for (NSString *title in titles) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont boldSystemFontOfSize:17.0]];
            [label setText:title];
            [label sizeToFit];
            CGRect frame = [label frame];
            frame.origin.y = 0.0;
            frame.origin.x = xOffset;
            frame.size.height = [self frame].size.height;
            [self addSubview:label];
            [components addObject:label];
            
            if (![title isEqual:[titles lastObject]]) {
                VFCCrumbTrailCarat *carat = [[VFCCrumbTrailCarat alloc] initWithFrame:CGRectMake(frame.origin.x+frame.size.width, 0.0, 15.0, frame.size.height)];
                [carat setBackgroundColor:[UIColor clearColor]];
                CALayer *layer = [carat layer];
                [layer setShadowColor:[[UIColor blackColor] CGColor]];
                [layer setShadowOpacity:0.5];
                [layer setShadowOffset:CGSizeMake(2.0, 0.0)];
                [layer setShadowRadius:1.0];
                [self addSubview:carat];
                [components addObject:carat];
                xOffset = [carat frame].origin.x + [carat frame].size.width;
            }
        }
        
        [self setComponents:[NSArray arrayWithArray:components]];
        
        UIView *prevView = nil;
        for (UIView *view in [self components]) {
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            if ([view isEqual:[[self components] firstObject]]) {
                [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
            }
            if (prevView) {
                [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:prevView withOffset:15.0];
            }
            if ([view isKindOfClass:[VFCCrumbTrailCarat class]]) {
                [view autoSetDimension:ALDimensionWidth toSize:15.0];
            }
            prevView = view;
        }
    }
}

@end
