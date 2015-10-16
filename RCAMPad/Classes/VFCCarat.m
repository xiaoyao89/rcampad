//
//  VFCCarat.m
//  RCAMPad
//

#import "VFCCarat.h"

#pragma mark - VFCCarat

#pragma mark - Public Implementation

@implementation VFCCarat

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGPoint point = CGPointMake(0.5*rect.size.width, 0.0);
    CGContextMoveToPoint(context, point.x, point.y);
    point = CGPointMake(rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, point.x, point.y);
    point = CGPointMake(0.0, rect.size.height);
    CGContextAddLineToPoint(context, point.x, point.y);
    point = CGPointMake(0.5*rect.size.width, 0.0);
    CGContextAddLineToPoint(context, point.x, point.y);
    
    [[UIColor venturaFoodsBlueColor] setFill];
    CGContextFillPath(context);
}

@end
