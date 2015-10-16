//
//  VFCSegmentChoice.m
//  RCAMPad
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
        choice.title = [choiceDict objectForKey:@"title"];
        choice.imageName = [choiceDict objectForKey:@"imageName"];
        [choices addObject:choice];
    }
    return [NSArray arrayWithArray:choices];
}

@end
