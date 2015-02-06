//
//  VFCSegmentChoice.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/20/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCSegmentChoice.h"

#pragma mark - VFCSegmentChoice

#pragma mark - Public Implementation

@implementation VFCSegmentChoice

#pragma mark Public

+ (NSArray *)segmentChoices {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SegmentChoices" ofType:@"plist"];
    NSArray *choiceDicts = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:@"segmentChoices"];
    NSMutableArray *choices = [NSMutableArray array];
    for (NSDictionary *choiceDict in choiceDicts) {
        VFCSegmentChoice *choice = [[VFCSegmentChoice alloc] init];
        [choice setTitle:[choiceDict objectForKey:@"title"]];
        [choice setImageName:[choiceDict objectForKey:@"imageName"]];
        [choices addObject:choice];
    }
    return [NSArray arrayWithArray:choices];
}

@end
