//
//  ViewController.m
//  RCAMPad
//

#import "ViewController.h"
#import "VFCDocument.h"
#import "VFCDocumentViewController.h"
#import "VFCResourcesViewController.h"
#import "VFCSpeakerNotesViewController.h"

#pragma mark - ViewController

#pragma mark - Private Interface

@interface ViewController ()
@end

#pragma mark - Public Implementation

@implementation ViewController

#pragma mark Initialization

- (instancetype)init {
    VFCDocument *doc = [[VFCDocument alloc] init];
    VFCDocumentViewController *docVC = [[VFCDocumentViewController alloc] initWithDocument:doc];
    self = [super initWithTopViewController:docVC];
    if (self) {
        [[docVC view] addGestureRecognizer:[self panGesture]];
        [self setAnchorRightRevealAmount:320.0];
        [self setAnchorLeftRevealAmount:320.0];
                
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
