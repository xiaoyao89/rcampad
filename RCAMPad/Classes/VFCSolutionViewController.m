//
//  VFCSolutionViewController.m
//  RCAMPad
//

#import "VFCSolutionViewController.h"
#import "VFCDocument.h"
#import "VFCMacroTrend.h"
#import "VFCSegmentChoice.h"
#import "PureLayout.h"

#pragma mark - VFCSolutionHeaderView

#pragma mark - Private Interface

@interface VFCSolutionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong, readwrite) UILabel *label;
@end

#pragma mark - Private Implementation

@implementation VFCSolutionHeaderView

#pragma mark Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel newAutoLayoutView];
        label.font = [UIFont systemFontOfSize:17.0];
        self.label = label;
        [self.contentView addSubview:label];
        [NSLayoutConstraint autoSetPriority:999.0 forConstraints:^{
            [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
        }];
    }
    return self;
}

@end

#pragma mark - VFCSolutionViewController

#pragma mark - Private Interface

@interface VFCSolutionViewController()
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) VFCDocument *document;
@end

#pragma mark - Public Implementation

@implementation VFCSolutionViewController

#pragma mark View Lifecycle

- (instancetype)initWithDocument:(VFCDocument *)document {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.document = document;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[VFCSolutionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([VFCSolutionHeaderView class])];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 44.0;
    }
    return (tableView.frame.size.height - ([self numberOfSectionsInTableView:tableView]-1)*[self tableView:tableView heightForHeaderInSection:indexPath.section]-44.0) / ([self numberOfSectionsInTableView:tableView]-1.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    if (indexPath.section == 3) {
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Generate PDF";
        cell.textLabel.textColor = [UIColor blueColor];
    } else {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia, ipsum sit amet dictum egestas, risus arcu fringilla erat, nec euismod risus ipsum a leo. Pellentesque gravida ex cursus elementum blandit. Etiam commodo sapien sed nunc molestie, vel aliquet nibh dapibus. Cras auctor tristique ipsum, id finibus enim tempus vitae. Proin eget pharetra metus, fringilla eleifend lacus. Pellentesque sollicitudin interdum maximus. Sed ut nisl eu odio ultricies tempus eget tincidunt lorem. Sed tellus lorem, euismod eget facilisis sed, auctor at leo. Vestibulum cursus, augue vel condimentum tincidunt, diam nibh luctus diam, vel porta leo risus vel quam. Donec neque eros, ultricies gravida mauris quis, tincidunt rhoncus nulla. Nulla eu nunc in est aliquet tempor vel quis odio.";
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 0.0;
    }
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VFCSolutionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([VFCSolutionHeaderView class])];
    NSString *title = nil;
    switch (section) {
        case 0: {
            title = [NSString stringWithFormat:@"Macro Trend: %@", self.document.macroTrend];
            break;
        }
        case 1: {
            title = [NSString stringWithFormat:@"Segment Choice: %@", self.document.segmentChoice];
            break;
        }
        case 2: {
            title = @"Gap Analysis";
            break;
        }
        default:
            break;
    }
    headerView.label.text = title;
    return headerView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 3) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Generating PDF..."
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
