//
//  VFCMacroTrend.h
//  RCAMPad
//

@import Foundation;

#pragma mark - VFCMacroTrendPage

#pragma mark - Public Interface

@interface VFCMacroTrendPage : NSObject
@property (nonatomic, copy, readwrite) NSString *imageName;
@property (nonatomic, strong, readwrite) NSArray *deepDiveImageNames;
@end

#pragma mark - VFCMacroTrend

#pragma mark - Public Interface

@interface VFCMacroTrend : NSObject <NSCopying>
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *imageName;
@property (nonatomic, strong, readwrite) NSArray *pages;
+ (NSArray *)macroTrends;
@end