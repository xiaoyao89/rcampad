//
//  VFCMacroTrend.m
//  RCAMPad
//

#import "VFCMacroTrend.h"

#pragma mark - VFCMacroTrendPage

@implementation VFCMacroTrendPage
@end

#pragma mark - VFCMacroTrend

#pragma mark - Public Implementation

@implementation VFCMacroTrend

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    id trend = [[[self class] alloc] init];
    if (trend) {
        [trend setIdentifier:self.identifier];
        [trend setTitle:self.title];
        [trend setImageName:self.imageName];
        [trend setPages:[self.pages copy]];
    }
    return trend;
}

#pragma mark Public

+ (NSArray *)macroTrends {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MacroTrends" ofType:@"plist"];
    NSDictionary *macroTrendsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *trendDicts = [macroTrendsDict objectForKey:@"macroTrends"];
    NSMutableArray *macroTrends = [NSMutableArray array];
    for (NSDictionary *trendDict in trendDicts) {
        VFCMacroTrend *mTrend = [[VFCMacroTrend alloc] init];
        mTrend.identifier = trendDict[@"identifier"];
        mTrend.title = trendDict[@"title"];
        mTrend.imageName = trendDict[@"imageName"];
        NSArray *pageDicts = trendDict[@"pages"];
        NSMutableArray *pages = [NSMutableArray array];
        for (NSDictionary *pageDict in pageDicts) {
            VFCMacroTrendPage *page = [[VFCMacroTrendPage alloc] init];
            page.imageName = pageDict[@"imageName"];
            page.deepDiveImageNames = pageDict[@"deepDive"];
            [pages addObject:page];
        }
        mTrend.pages = [NSArray arrayWithArray:pages];
        [macroTrends addObject:mTrend];
    }
    return [NSArray arrayWithArray:macroTrends];
}

@end
