//
//  ViewController.m
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "ViewController.h"
#import "VFCDocument.h"
#import "VFCDocumentViewController.h"
#import "VFCDocumentsViewController.h"
#import "VFCResourcesViewController.h"
#import "VFCSpeakerNotesViewController.h"

#pragma mark - ViewController

#pragma mark - Private Interface

@interface ViewController ()
@end

#pragma mark - Public Implementation

@implementation ViewController

#pragma mark Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (instancetype)init {
    VFCDocument *doc = [VFCDocument previousDocument];
    if (!doc) {
        NSArray *docs = [VFCDocument documents];
        if ([docs count] == 0) {
            doc = [VFCDocument document];
            [doc openWithCompletionHandler:nil];
        } else {
            doc = [docs firstObject];
        }
        [VFCDocument saveAsPreviousDocument:doc];
    }
    VFCDocumentViewController *docVC = [[VFCDocumentViewController alloc] initWithDocument:doc];
    self = [super initWithTopViewController:docVC];
    if (self) {
        [[docVC view] addGestureRecognizer:[self panGesture]];
        [self setAnchorRightRevealAmount:320.0];
        [self setAnchorLeftRevealAmount:320.0];
        
        NSArray *docs = [VFCDocument documents];
        VFCDocumentsViewController *docsVC = [[VFCDocumentsViewController alloc] initWithDocuments:docs];
        UINavigationController *docsNavController = [[UINavigationController alloc] initWithRootViewController:docsVC];
        [docsNavController setEdgesForExtendedLayout:UIRectEdgeTop|UIRectEdgeBottom|UIRectEdgeLeft];
        [self setUnderLeftViewController:docsNavController];
        
        VFCSpeakerNotesViewController *speakerNotesVC = [[VFCSpeakerNotesViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:speakerNotesVC];
        [navController setEdgesForExtendedLayout:UIRectEdgeTop|UIRectEdgeBottom|UIRectEdgeRight];
        [self setUnderRightViewController:navController];
        
        CALayer *layer = [[[self topViewController] view] layer];
        [layer setShadowColor:[[UIColor blackColor] CGColor]];
        [layer setShadowRadius:1.0];
        [layer setShadowOpacity:0.25];
    }
    return self;
}

@end
