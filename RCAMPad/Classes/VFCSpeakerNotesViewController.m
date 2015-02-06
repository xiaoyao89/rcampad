//
//  VFCSpeakerNotesViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 1/29/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCSpeakerNotesViewController.h"
#import "VFCSpeakerNotesManager.h"
#import "PureLayout.h"

#pragma mark - VFCSpeakerNotesViewController

#pragma mark - Private Interface

@interface VFCSpeakerNotesViewController()
@property (nonatomic, strong, readwrite) UITextView *textView;
@property (nonatomic, strong, readwrite) AVSpeechSynthesizer *speechSynthesizer;
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
    [UIView autoSetPriority:999.0
             forConstraints:^{
                 [textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
             }];
    [self setTextView:textView];
    
    [self setTitle:@"Speaker Notes"];
    
    AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [self setSpeechSynthesizer:speechSynthesizer];
    
    UIBarButtonItem *speakerItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Volume"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(speakNotes:)];
    [[self navigationItem] setRightBarButtonItem:speakerItem];
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

- (void)speakNotes:(UIBarButtonItem *)item {
    //AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[[self textView] text]];
    //[utterance setRate:0.25];
    //[[self speechSynthesizer] speakUtterance:utterance];
}

@end
