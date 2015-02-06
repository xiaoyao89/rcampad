//
//  VFCDeepDiveViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 2/4/15.
//  Copyright (c) 2015 Xcelerate Media Inc. All rights reserved.
//

#import "VFCDeepDiveViewController.h"

#pragma mark - VFCDeepDiveViewController

#pragma mark - Private Interface

@interface VFCDeepDiveViewController ()
@end

#pragma mark - Public Implementation

@implementation VFCDeepDiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(dismiss)];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [self setTitle:@"Deep Dive"];
    
    UIImage *image = [UIImage imageNamed:@"NavigationBarLogo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    [[self navigationItem] setLeftBarButtonItem:item];
}

#pragma mark Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
