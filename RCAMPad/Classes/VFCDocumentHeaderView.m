//
//  VFCDocumentHeaderView.m
//  RCAMPad
//

#import "VFCDocumentHeaderView.h"
#import "VFCCarat.h"
#import "VFCCrumbTrailView.h"
#import "VFCSegmentButton.h"
#import "PureLayout.h"
#import "ECSlidingViewController.h"
#import "UIImage+VFCAdditions.h"

#pragma mark - VFCDocumentHeaderView

#pragma mark - Private Interface

@interface VFCDocumentHeaderView()
@property (nonatomic, strong, readwrite) VFCCarat *carat;

@property (nonatomic, strong, readwrite) UIButton *informationButton;

@property (nonatomic, strong, readwrite) NSArray *segmentButtons;
@property (nonatomic, strong, readwrite) VFCSegmentButton *selectedSegmentButton;

@property (nonatomic, strong, readwrite) VFCCrumbTrailView *crumbTrailView;

@property (nonatomic, strong, readwrite) UIColor *selectedColor;

@property (nonatomic, strong, readwrite) UIButton *speakerNotesButton;
@property (nonatomic, strong, readwrite) UIButton *nextButton;
@property (nonatomic, strong, readwrite) UIButton *continueButton;

@end

#pragma mark - Public Implementation

NSString *const VFCDocumentHeaderViewShowNextButton = @"VFCDocumentHeaderViewShowNextButton";
NSString *const VFCDocumentheaderViewHideNextButton = @"VFCDocumentheaderViewHideNextButton";

@implementation VFCDocumentHeaderView

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setSelectedColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        
        UIView *topView = [UIView newAutoLayoutView];
        [topView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:topView];
        
        UIView *bottomView = [UIView newAutoLayoutView];
        [bottomView setBackgroundColor:[UIColor venturaFoodsBlueColor]];
        [self addSubview:bottomView];
        
        [topView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [topView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [topView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [bottomView autoSetDimension:ALDimensionHeight toSize:50.0];
        
        [topView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:bottomView];
        
        UIButton *button = [UIButton newAutoLayoutView];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:[UIImage imageNamed:@"HeaderIcon"] forState:UIControlStateNormal];
        [topView addSubview:button];
        [self setInformationButton:button];
        
        [button autoSetDimension:ALDimensionWidth toSize:316.0];
        [button autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [button autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        UIView *buttonsContainer = [UIView newAutoLayoutView];
        [buttonsContainer setBackgroundColor:[UIColor clearColor]];
        [topView addSubview:buttonsContainer];
        
        [buttonsContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:[self informationButton]];
        [buttonsContainer autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [buttonsContainer autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        UIButton *speakerNotesButton = [UIButton newAutoLayoutView];
        [speakerNotesButton setBackgroundColor:[UIColor clearColor]];
        UIImage *image = [UIImage imageNamed:@"Menu"];
        image = [image tintedImageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        [speakerNotesButton setImage:image forState:UIControlStateNormal];
        [[speakerNotesButton imageView] setContentMode:UIViewContentModeCenter];
        [speakerNotesButton addTarget:self action:@selector(toggleSpeakerNotes:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:speakerNotesButton];
        
        [speakerNotesButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [speakerNotesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [speakerNotesButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [speakerNotesButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:buttonsContainer];
        [speakerNotesButton autoSetDimension:ALDimensionWidth toSize:44.0];
        
        NSMutableArray *buttons = [NSMutableArray array];
        
        NSArray *imageIDs = @[@"MacroTrend", @"SegmentChoice", @"GapAnalysis", @"SuggestedSolution"];
        NSArray *imageNames = @[@"MacroTrend", @"SegmentChoice", @"GapAnalysis", @"SuggestedSolution"];
        NSArray *textStrings = @[@"MACRO TREND", @"SEGMENT CHOICE", @"GAP ANALYSIS", @"SOLUTION"];
        NSInteger count = [imageIDs count];
        for (NSInteger i=0; i<count; i++) {
            VFCSegmentButton *button = [VFCSegmentButton newAutoLayoutView];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(moveCarat:) forControlEvents:UIControlEventTouchUpInside];
            
            // Image ID
            NSString *imageID = imageIDs[i];
            [button setImageIdentifier:imageID];
            
            // Image
            NSString *imageName = imageNames[i];
            UIImage *image = [UIImage imageNamed:imageName];
            image = [image tintedImageWithColor:[self selectedColor]];
            [[button iconImageView] setImage:image];
            
            // Label
            [[button label] setTextColor:[self selectedColor]];
            NSString *text = textStrings[i];
            [[button label] setText:text];
            
            [button setTag:i];
            [button addTarget:self action:@selector(moveCarat:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsContainer addSubview:button];

            [button autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            
            [buttons addObject:button];
        }
        [buttons autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0];
        
        VFCSegmentButton *segButton = [buttons firstObject];
        [segButton setBackgroundColor:[self selectedColor]];
        [[segButton label] setTextColor:[UIColor whiteColor]];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Filled", [segButton imageIdentifier]]];
        image = [image tintedImageWithColor:[UIColor whiteColor]];
        [[segButton iconImageView] setImage:image];
        self.selectedSegmentButton = segButton;
        
        // Carat
        VFCCarat *carat = [VFCCarat newAutoLayoutView];
        button = [buttons firstObject];
        [carat setFrame:CGRectMake(83.0, [topView frame].size.height-15.0, 30.0, 15.0)];
        [carat setBackgroundColor:[UIColor clearColor]];
        [self setCarat:carat];
        [topView addSubview:carat];
        [carat autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [carat autoSetDimensionsToSize:CGSizeMake(30.0, 15.0)];
        
        // Crumbtrail view
        VFCCrumbTrailView *ctView = [VFCCrumbTrailView newAutoLayoutView];
        ctView.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:ctView];
        self.crumbTrailView = ctView;
        [ctView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [ctView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [ctView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
        
        UIButton *nextButton = [UIButton newAutoLayoutView];
        nextButton.backgroundColor = [UIColor clearColor];
        image = [UIImage imageNamed:@"Next"];
        image = [image tintedImageWithColor:[UIColor whiteColor]];
        [nextButton setImage:image forState:UIControlStateNormal];
        [bottomView addSubview:nextButton];
        [nextButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [nextButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
        self.nextButton = nextButton;
        self.nextButton.alpha = 0.0;
        
        UIButton *continueButton = [UIButton newAutoLayoutView];
        continueButton.backgroundColor = [UIColor clearColor];
        [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        continueButton.alpha = 0.0;
        [bottomView addSubview:continueButton];
        self.continueButton = continueButton;
        
        [continueButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [continueButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [continueButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:nextButton withOffset:-5.0];
        [ctView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:continueButton];

        self.segmentButtons = [NSArray arrayWithArray:buttons];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserverForName:VFCDocumentHeaderViewShowNextButton
                            object:nil
                             queue:[NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification *note) {
                            [self flashNextButton:3];
                        }];
        
        [center addObserverForName:VFCDocumentheaderViewHideNextButton
                            object:nil
                             queue:[NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification *note) {
                            self.nextButton.alpha = 0.0;
                            self.continueButton.alpha = 0.0;
                        }];
    }
    return self;
}

#pragma mark Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Public

- (void)moveCaratToPoint:(CGPoint)point {
    CGPoint center = self.carat.center;
    center.x = point.x;
    self.carat.center = center;
}

- (void)moveCaratToIndex:(NSInteger)index {
    [self moveCarat:[[self segmentButtons] objectAtIndex:index]];
}

#pragma mark Private

- (void)moveCarat:(VFCSegmentButton *)button {
    if (![button isEqual:[self selectedSegmentButton]]) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             CGRect frame = [[self carat] frame];
                             frame.origin.x = [button frame].origin.x + 0.5*([button frame].size.width-frame.size.width) + [[self informationButton] frame].size.width;
                             frame.origin.y = [[[self carat] superview] frame].size.height - frame.size.height;
                             [[self carat] setFrame:frame];
                         }];
        
        [[self selectedSegmentButton] setBackgroundColor:[UIColor clearColor]];
        [[[self selectedSegmentButton] label] setTextColor:[self selectedColor]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [[self selectedSegmentButton] imageIdentifier]]];
        image = [image tintedImageWithColor:[self selectedColor]];
        [[[self selectedSegmentButton] iconImageView] setImage:image];
        
        [button setBackgroundColor:[self selectedColor]];
        [[button label] setTextColor:[UIColor whiteColor]];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Filled", [button imageIdentifier]]];
        image = [image tintedImageWithColor:[UIColor whiteColor]];
        [[button iconImageView] setImage:image];
        [self setSelectedSegmentButton:button];
    }
    
    if ([[self delegate] respondsToSelector:@selector(documentHeaderView:didSelectButtonAtIndex:)]) {
        [[self delegate] documentHeaderView:self didSelectButtonAtIndex:[button tag]];
    }
}

- (void)toggleSpeakerNotes:(UIButton *)button {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    ECSlidingViewController *slidingVC = (ECSlidingViewController *)[window rootViewController];
    if ([slidingVC currentTopViewPosition] == ECSlidingViewControllerTopViewPositionCentered) {
        [slidingVC anchorTopViewToLeftAnimated:YES];
    } else {
        [slidingVC resetTopViewAnimated:YES];
    }
}

- (void)flashNextButton:(NSInteger)flashes {
    if (flashes > 0) {
        [UIView animateWithDuration:0.125
                         animations:^{
                             [[self nextButton] setAlpha:0.0];
                             self.continueButton.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.125
                                              animations:^{
                                                  [[self nextButton] setAlpha:1.0];
                                                  self.continueButton.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished) {
                                                  [self flashNextButton:flashes-1];
                                              }];
                         }];
    }
}

@end
