//
//  VFCDocumentsViewController.m
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "VFCDocument.h"
#import "VFCDocumentsViewController.h"
#import "UIColor+VFCAdditions.h"
#import "PureLayout.h"
#import "JTTableViewGestureRecognizer.h"
#import "JTTransformableTableViewCell.h"

#pragma mark - VFCDocumentCell

#pragma mark - Private Interface

@interface VFCDocumentCell : JTTransformableTableViewCell
@property (nonatomic, strong, readwrite) UIView *selectionIndicator;
@property (nonatomic, strong, readwrite) UITextField *textField;
@property (nonatomic, strong, readwrite) UILabel *label;
@end

#pragma mark - Private Implementation

@implementation VFCDocumentCell

#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:YES];
        [self setLayoutMargins:UIEdgeInsetsZero];
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setPreservesSuperviewLayoutMargins:NO];
        
        UIView *selectionIndicator = [UIView newAutoLayoutView];
        [selectionIndicator setBackgroundColor:[UIColor venturaBlueColor]];
        [[self contentView] addSubview:selectionIndicator];
        [self setSelectionIndicator:selectionIndicator];
        
        UITextField *textField = [UITextField newAutoLayoutView];
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setPlaceholder:@"Tap to edit title"];
        [[self contentView] addSubview:textField];
        [self setTextField:textField];
        
        UILabel *label = [UILabel newAutoLayoutView];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [selectionIndicator autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                     [selectionIndicator autoPinEdgeToSuperviewEdge:ALEdgeTop];
                     [selectionIndicator autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                     [selectionIndicator autoSetDimension:ALDimensionWidth toSize:5.0];
                     
                     [textField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
                     [textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
                     [textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0];
                     
                     [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
                     [label autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
                     [label autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0];
                     [label autoSetDimension:ALDimensionHeight toSize:20.0];
                     
                     [textField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:label];
                 }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *color = [[self selectionIndicator] backgroundColor];
    [super setHighlighted:highlighted animated:animated];
    [[self selectionIndicator] setBackgroundColor:color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *color = [[self selectionIndicator] backgroundColor];
    [super setSelected:selected animated:animated];
    [[self selectionIndicator] setBackgroundColor:color];
}

@end

#pragma mark - VFCDocumentsViewController

#pragma mark - Private Interface

#define ADDING_CELL @"Continue..."
#define DONE_CELL @"Done"
#define DUMMY_CELL @"Dummy"
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60

static NSString *VFCDocumentCellIdentifier = @"VFCDocumentCell";

@interface VFCDocumentsViewController () <JTTableViewGestureEditingRowDelegate, JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong, readwrite) NSMutableArray *documents;
@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readwrite) JTTableViewGestureRecognizer *tableViewRecognizer;
@end

#pragma mark - Public Implementation

@implementation VFCDocumentsViewController

#pragma mark Initialization

- (instancetype)initWithDocuments:(NSArray *)documents {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDoesRelativeDateFormatting:YES];
        [self setDateFormatter:dateFormatter];
        
        [self setDocuments:[NSMutableArray array]];
        [[self documents] addObjectsFromArray:documents];
        for (VFCDocument *doc in [self documents]) {
            [doc openWithCompletionHandler:^(BOOL success) {
                NSInteger index = [[self documents] indexOfObject:doc];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserverForName:VFCNotificationDidCreateDocument
                            object:nil
                             queue:[NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification *note) {
                            VFCDocument *doc = [note object];
                            [[self documents] insertObject:doc atIndex:0];
                            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            [[self tableView] insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                        }];
    }
    return self;
}

#pragma mark Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self tableView] registerClass:[VFCDocumentCell class] forCellReuseIdentifier:VFCDocumentCellIdentifier];
    [[self tableView] setRowHeight:NORMAL_CELL_FINISHING_HEIGHT];
    [self setTableViewRecognizer:[[self tableView] enableGestureTableViewWithDelegate:self]];
    
    [self setTitle:@"Evaluations"];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark JTTableViewGestureAddingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self documents] insertObject:ADDING_CELL atIndex:[indexPath row]];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    VFCDocumentCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];
    
    BOOL isFirstCell = indexPath.section == 0 && indexPath.row == 0;
    if (isFirstCell && cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
        [self removeDocumentAtIndexPath:indexPath];
    } else {
        VFCDocument *doc = [VFCDocument document];
        [doc openWithCompletionHandler:^(BOOL success) {
            
        }];
        [[self documents] replaceObjectAtIndex:[indexPath row] withObject:doc];
        cell.finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
        [[cell textField] setText:nil];
        [[cell textField] becomeFirstResponder];
    }
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeDocumentAtIndexPath:indexPath];
}

/*- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0 && [indexPath section] == 0) {
        return indexPath;
    }
    return nil;
}*/

#pragma mark JTTableViewGestureEditingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    UIColor *backgroundColor = nil;
    switch (state) {
        case JTTableViewCellEditingStateMiddle:
            backgroundColor = [UIColor whiteColor];
            break;
        case JTTableViewCellEditingStateLeft: {
            backgroundColor = [UIColor redColor];
            break;
        }
        default:
            break;
    }
    [[cell contentView] setBackgroundColor:backgroundColor];
    if ([cell isKindOfClass:[JTTransformableTableViewCell class]]) {
        [((JTTransformableTableViewCell *)cell) setTintColor:backgroundColor];
    }
}

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = [gestureRecognizer tableView];
    [tableView beginUpdates];
    if (state == JTTableViewCellEditingStateLeft) {
        [self removeDocumentAtIndexPath:indexPath];
    }
    [tableView endUpdates];
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];
}

- (CGFloat)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer lengthForCommitEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.5*[[gestureRecognizer tableView] frame].size.width;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didChangeContentViewTranslation:(CGPoint)translation forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", NSStringFromCGPoint(translation));
}

#pragma mark JTTableViewGestureMoveRowDelegate

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self documents] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFCDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:VFCDocumentCellIdentifier forIndexPath:indexPath];
    
    [[cell textField] setDelegate:self];
    [[cell textField] setTag:[indexPath row]];
    
    VFCDocument *doc = [[self documents] objectAtIndex:[indexPath row]];
    if ([doc isEqual:ADDING_CELL]) {
        cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
        NSString *text = nil;
        if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
            text = @"Release to cancel...";
        } else if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
            text = @"Release to create new evaluation...";
        } else {
            text = @"Continue pulling...";
        }

        [[cell textField] setText:text];
        [[cell contentView] setBackgroundColor:[UIColor clearColor]];
        [[cell selectionIndicator] setBackgroundColor:[UIColor clearColor]];
    } else {
        [[cell textField] setText:[doc title] ? [doc title] : @""];
        [[cell label] setText:[[self dateFormatter] stringFromDate:[doc fileModificationDate]]];
        
        VFCDocument *prevDoc = [VFCDocument previousDocument];
        if ([[[doc fileURL] lastPathComponent] isEqual:[[prevDoc fileURL] lastPathComponent]]) {
            [[cell selectionIndicator] setBackgroundColor:[UIColor venturaBlueColor]];
        } else {
            [[cell selectionIndicator] setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:NSLocalizedString(@"Delete", @"kDelete")
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                              VFCDocument *doc = [[self documents] objectAtIndex:[indexPath row]];
                                                                              [[NSFileManager defaultManager] removeItemAtURL:[doc fileURL] error:nil];
                                                                              if ([[self documentsViewControllerDelegate] respondsToSelector:@selector(documentsViewController:didRemoveDocument:)]) {
                                                                                  [[self documentsViewControllerDelegate] documentsViewController:self didRemoveDocument:doc];
                                                                              }
                                                                              VFCDocument *prevDoc = [VFCDocument previousDocument];
                                                                              if ([[[prevDoc fileURL] lastPathComponent] isEqual:[[doc fileURL] lastPathComponent]]) {
                                                                                  [VFCDocument saveAsPreviousDocument:nil];
                                                                              }
                                                                              [[self documents] removeObject:doc];
                                                                              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                          }];
    
    UITableViewRowAction *emailAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                           title:NSLocalizedString(@"Email", @"kEmail")
                                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                             MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                                                                             [mailVC setMailComposeDelegate:self];
                                                                             [[mailVC navigationBar] setTintColor:[UIColor whiteColor]];
                                                                             [self presentViewController:mailVC animated:YES completion:nil];
                                                                         }];
    [emailAction setBackgroundColor:[UIColor venturaBlueColor]];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:NSLocalizedString(@"Edit", @"kEdit")
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                            
                                                                        }];
    [editAction setBackgroundColor:[UIColor venturaBlueColor]];
    
    return @[deleteAction, emailAction, editAction];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VFCDocument *doc = [[self documents] objectAtIndex:[indexPath row]];
    [VFCDocument saveAsPreviousDocument:doc];
    if ([[self documentsViewControllerDelegate] respondsToSelector:@selector(documentsViewController:didSelectDocument:)]) {
        [[self documentsViewControllerDelegate] documentsViewController:self didSelectDocument:doc];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    VFCDocument *doc = [[self documents] objectAtIndex:[textField tag]];
    [doc setTitle:[textField text] ? [textField text] : @""];
}

#pragma mark Private

- (void)removeDocumentAtIndexPath:(NSIndexPath *)indexPath {
    VFCDocument *doc = [[self documents] objectAtIndex:[indexPath row]];
    if (![doc isEqual:ADDING_CELL]) {
        [doc closeWithCompletionHandler:^(BOOL success) {
            [[NSFileManager defaultManager] removeItemAtURL:[doc fileURL] error:nil];
        }];
    }
    [[self documents] removeObject:doc];
    [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

@end
