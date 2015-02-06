//
//  VFCApplicationInformationViewController.m
//  VFCKit
//

#import "VFCApplicationInformationViewController.h"
#import "VFCUser.h"
#import "UIColor+VFCAdditions.h"

#pragma mark - _VFCTableViewCell

#pragma mark - Private Interface

@interface _VFCTableViewCell : UITableViewCell
@end

#pragma mark - Private Implementation

@implementation _VFCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self detailTextLabel] setTextColor:[UIColor venturaBlueColor]];
        [self setPreservesSuperviewLayoutMargins:NO];
        [self setLayoutMargins:UIEdgeInsetsZero];
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    return self;
}

@end

#pragma mark - VFCApplicationInformationViewController

#pragma mark - Private Interface

@interface VFCApplicationInformationViewController() <UITextFieldDelegate>
@end

#pragma mark - Public Implementation

static NSString *VFCApplicationCellIdentifier = @"VFCApplicationCell";
static NSString *VFCApplicationTextFieldCellIdentifier = @"VFCApplicationTextFieldCell";

@implementation VFCApplicationInformationViewController

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    [self setTitle:[infoDict objectForKey:@"CFBundleName"]];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(dismiss)];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    [[self tableView] registerClass:[_VFCTableViewCell class] forCellReuseIdentifier:VFCApplicationCellIdentifier];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:VFCApplicationTextFieldCellIdentifier];
    
    [[self tableView] setAllowsSelection:NO];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([indexPath row] == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:VFCApplicationTextFieldCellIdentifier forIndexPath:indexPath];
        [cell setPreservesSuperviewLayoutMargins:NO];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [[cell textLabel] setText:@"User Email"];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        [textField setTextAlignment:NSTextAlignmentRight];
        [textField setPlaceholder:@"Tap to enter email"];
        [textField setDelegate:self];
        [textField setTextColor:[UIColor venturaBlueColor]];
        [cell setAccessoryView:textField];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:VFCApplicationCellIdentifier forIndexPath:indexPath];
        NSString *text = nil;
        NSString *detailText = nil;
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        UIDevice *device = [UIDevice currentDevice];
        
        switch ([indexPath row]) {
            case 0: {
                text = @"Application Version";
                detailText = [infoDict objectForKey:@"CFBundleShortVersionString"];
                break;
            }
            case 1: {
                text = @"Application Build Number";
                detailText = [infoDict objectForKey:@"CFBundleVersion"];
                break;
            }
            case 2: {
                text = @"iOS Version";
                detailText = [device systemVersion];
                break;
            }
            case 3: {
                text = @"Device Model";
                detailText = [device localizedModel];
                break;
            }
            case 4: {
                text = @"Device Name";
                detailText = [device name];
                break;
            }
            case 5: {
                text = @"Vendor Identifier";
                detailText = [[device identifierForVendor] UUIDString];
                break;
            }
            default:
                break;
        }
        [[cell textLabel] setText:text];
        [[cell detailTextLabel] setText:detailText];
    }
    
    return cell;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[VFCUser user] setEmail:[textField text]];
}

#pragma mark Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
