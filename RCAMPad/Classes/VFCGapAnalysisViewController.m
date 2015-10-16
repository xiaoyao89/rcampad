//
//  VFCGapAnalysisViewController.m
//  RCAMPad
//

#import "VFCGapAnalysisViewController.h"
#import "VFCProductsViewController.h"
#import "VFCRecipesViewController.h"
#import "PureLayout.h"

#pragma mark - Resource

#pragma mark - Private Interface

@interface Resource : NSObject
@property (nonatomic, copy, readwrite) NSString *filename;
@end

#pragma mark - Private Interface

@implementation Resource
@end

#pragma mark - ResourceCell

#pragma mark - Public Interface

static void *ResourceCellFrameContext = &ResourceCellFrameContext;

typedef NS_ENUM(NSInteger, ResourceCellState) {
    ResourceCellStateNone,
    ResourceCellStateSelected,
    ResourceCellStateInclude,
};

@interface ResourceCell : UITableViewCell
@property (nonatomic, strong, readwrite) UIImageView *resourceImageView;
@property (nonatomic, strong, readwrite) UILabel *resourceLabel;
@property (nonatomic, assign, getter=isTracking) BOOL tracking;
@property (nonatomic, assign, readwrite) ResourceCellState state;
@property (nonatomic, strong, readwrite) UIColor *highlightColor;
@end

#pragma mark - Private Implementation

@implementation ResourceCell

#pragma mark Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _state = ResourceCellStateNone;
        _tracking = NO;
        
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.resourceImageView = imageView;
        [self.contentView addSubview:imageView];
        
        UILabel *label = [UILabel newAutoLayoutView];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:17.0];
        self.resourceLabel = label;
        [self.contentView addSubview:label];
        
        [NSLayoutConstraint autoSetPriority:999.0 forConstraints:^{
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            
            [label autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [label autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [label autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0];
            [label autoSetDimension:ALDimensionHeight toSize:30.0];
            
            [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:label withOffset:-15.0];
        }];
        
        self.highlightColor = [UIColor venturaFoodsBlueColor];
        
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew context:ResourceCellFrameContext];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(frame))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.isTracking) {
        if (context == ResourceCellFrameContext) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(frame))]) {
                CGRect frame = self.frame;
                CGFloat x = frame.origin.x;
                if (x == 0) {
                    if (self.state != ResourceCellStateNone) {
                        self.state = ResourceCellStateNone;
                        self.contentView.backgroundColor = [UIColor clearColor];
                        self.resourceLabel.textColor = [UIColor lightGrayColor];
                    }
                } else if (x > -75.0 && x < 75.0) {
                    if (self.state != ResourceCellStateSelected) {
                        self.state = ResourceCellStateSelected;
                        self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
                        self.resourceLabel.textColor = [UIColor blackColor];
                    }
                } else if (x < -150.0) {
                    if (self.state != ResourceCellStateInclude) {
                        self.state = ResourceCellStateInclude;
                        self.contentView.backgroundColor = self.highlightColor;
                        self.resourceLabel.textColor = [UIColor whiteColor];
                    }
                }
            }
        }
    }
}

@end

#pragma mark - VFCGapAnalysisViewController

#pragma mark - Private Interface

@interface VFCGapAnalysisViewController() <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readwrite) NSMutableArray *resources;
@property (nonatomic, strong, readwrite) NSMutableArray *selectedResources;
@property (nonatomic, strong, readwrite) ResourceCell *selectedCell;
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UITableView *selectedResourcesTableView;
@end

#pragma mark Public Implementation

@implementation VFCGapAnalysisViewController

#pragma mark Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSArray *filenames = [NSMutableArray arrayWithArray:dict[@"resources"]];
        self.resources = [NSMutableArray array];
        for (NSString *filename in filenames) {
            Resource *resource = [[Resource alloc] init];
            resource.filename = filename;
            [self.resources addObject:resource];
        }
        
        self.selectedResources = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [UITableView newAutoLayoutView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView registerClass:[ResourceCell class] forCellReuseIdentifier:NSStringFromClass([ResourceCell class])];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [tableView addGestureRecognizer:panRecognizer];
    
    [tableView.panGestureRecognizer requireGestureRecognizerToFail:panRecognizer];
    
    UITableView *selectedResourcesTableView = [UITableView newAutoLayoutView];
    selectedResourcesTableView.separatorInset = UIEdgeInsetsZero;
    selectedResourcesTableView.dataSource = self;
    selectedResourcesTableView.delegate = self;
    [selectedResourcesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:selectedResourcesTableView];
    self.selectedResourcesTableView = selectedResourcesTableView;
    
    [NSLayoutConstraint autoSetPriority:999.0 forConstraints:^{
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [selectedResourcesTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [selectedResourcesTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [selectedResourcesTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [selectedResourcesTableView autoSetDimension:ALDimensionWidth toSize:320.0];
        [selectedResourcesTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:tableView];
    }];
    
    [tableView reloadData];
    [selectedResourcesTableView reloadData];
}

#pragma mark Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint touchLocation = [recognizer locationInView:recognizer.view];
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchLocation];
            ResourceCell *cell = (ResourceCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            self.selectedCell = cell;
            self.selectedCell.tracking = YES;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [recognizer translationInView:recognizer.view];
            CGRect frame = self.selectedCell.frame;
            frame.origin.x += translation.x;
            self.selectedCell.frame = frame;
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
            break;
        }
        default: {
            switch (self.selectedCell.state) {
                case ResourceCellStateInclude: {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.selectedCell];
                    Resource *resource = self.resources[indexPath.row];
                    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:self.selectedResources.count inSection:0];
                    [self.selectedResources addObject:resource];
                    [self.selectedResourcesTableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [self.resources removeObject:resource];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                }
                default:
                    break;
            }
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.selectedCell.frame;
                frame.origin.x = 0.0;
                self.selectedCell.frame = frame;
            } completion:^(BOOL finished) {
                self.selectedCell.tracking = NO;
                self.selectedCell = nil;
            }];
            break;
        }
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    return fabs(velocity.x) > fabs(velocity.y) && velocity.x < 0.0;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableView isEqual:self.tableView] ? self.resources.count : self.selectedResources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([tableView isEqual:self.tableView]) ? 240.0 : 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // #HACK
    return [tableView isEqual:self.tableView] ? @"   Available Resources (drag to the left to select)" : @"   Selected Resources (tap to remove)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        ResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResourceCell class]) forIndexPath:indexPath];
        Resource *resource = self.resources[indexPath.row];
        NSString *imageName = nil;
        NSInteger row = indexPath.row;
        if (row % 2 == 0) {
            imageName = @"Dummy1";
        } else {
            imageName = @"Dummy2";
        }
        cell.resourceImageView.image = [UIImage imageNamed:imageName];
        cell.resourceLabel.text = [resource.filename stringByDeletingPathExtension];
        cell.resourceLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    Resource *resource = self.resources[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Dummy1"];
    cell.textLabel.text = [resource.filename stringByDeletingPathExtension];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![tableView isEqual:self.tableView]) {
        [self.selectedResources removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end