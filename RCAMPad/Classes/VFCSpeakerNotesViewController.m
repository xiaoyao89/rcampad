//
//  VFCSpeakerNotesViewController.m
//  RCAMPad
//

#import "VFCSpeakerNotesViewController.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"

#pragma mark - VFCSpeakerNotesViewController

#pragma mark - Private Interface

@interface VFCSpeakerNotesViewController()
@property (nonatomic, strong, readwrite) UITextView *textView;
@end

#pragma mark - Public Implementation

@implementation VFCSpeakerNotesViewController

#pragma mark Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *textView = [UITextView newAutoLayoutView];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setFont:[UIFont systemFontOfSize:17.0]];
    [textView setEditable:NO];
    [[self view] addSubview:textView];
    [NSLayoutConstraint autoSetPriority:999.0
                         forConstraints:^{
                             [textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                         }];
    [self setTextView:textView];
    
    [self setTitle:@"Speaker Notes"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *speakerNotes = [[VFCSpeakerNotesManager speakerNotesManager] speakerNotes];
    [[self textView] setText:speakerNotes];
}

#pragma mark Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
