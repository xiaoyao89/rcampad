//
//  VFCMacroTrend.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCMacroTrend.h"

#pragma mark - VFCMacroTrend

#pragma mark - Public Implementation

@implementation VFCMacroTrend

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    id trend = [[[self class] alloc] init];
    if (trend) {
        [trend setTitle:[self title]];
        [trend setImageName:[self imageName]];
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
        [mTrend setTitle:[trendDict objectForKey:@"title"]];
        [mTrend setImageName:[trendDict objectForKey:@"imageName"]];
        [macroTrends addObject:mTrend];
    }
    return [NSArray arrayWithArray:macroTrends];
}

@end
