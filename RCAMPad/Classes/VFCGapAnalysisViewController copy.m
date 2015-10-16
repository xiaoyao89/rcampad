//
//  VFCGapAnalysisViewController.m
//  RCAMPad
//

#import "VFCGapAnalysisViewController.h"
#import "VFCProductsViewController.h"
#import "VFCRecipesViewController.h"
#import "PureLayout.h"

#pragma mark - VFCGapAnalysisItemsViewController

#pragma mark - Private Interface

@interface VFCGapAnalysisItemsViewController : UIViewController

@end

#pragma mark - Private Implementation

@implementation VFCGapAnalysisItemsViewController

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    VFCProductsViewController *productsVC = [[VFCProductsViewController alloc] init];
    [[productsVC collectionView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[productsVC collectionView] setShowsVerticalScrollIndicator:NO];
    [self addChildViewController:productsVC];
    [[self view] addSubview:[productsVC collectionView]];
    [[productsVC collectionView] setBackgroundColor:[UIColor clearColor]];
    
    VFCRecipesViewController *recipesVC = [[VFCRecipesViewController alloc] init];
    [[recipesVC collectionView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[recipesVC collectionView] setShowsVerticalScrollIndicator:NO];
    [self addChildViewController:recipesVC];
    [[self view] addSubview:[recipesVC collectionView]];
    [[recipesVC collectionView] setBackgroundColor:[UIColor clearColor]];
    
    [UIView autoSetPriority:999.0
             forConstraints:^{
                 UIView *productsView = [productsVC collectionView];
                 UIView *recipesView = [recipesVC collectionView];
                 
                 [productsView autoPinEdgeToSuperviewEdge:ALEdgeTop];
                 [productsView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                 
                 [recipesView autoPinEdgeToSuperviewEdge:ALEdgeTop];
                 [recipesView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                 
                 NSArray *views = @[productsView, recipesView];
                 [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:60.0 insetSpacing:NO];
             }];
}

@end

#pragma mark - VFCTagSection

#pragma mark - Private Interface

@interface VFCTagSection : NSObject
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSArray *tags;
@end

#pragma mark - Private Implementation

@implementation VFCTagSection
@end

#pragma mark - VFCTagHeaderView

#pragma mark - Private Interface

@interface VFCTagHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong, readwrite) UILabel *label;
@end

#pragma mark - Private Implementation

@implementation VFCTagHeaderView

#pragma mark Initialization

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [UILabel newAutoLayoutView];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:[[label font] pointSize]]];
        [self setLabel:label];
        [[self contentView] addSubview:label];
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
                 }];
    }
    return self;
}

@end

#pragma mark - VFCTagCell

#pragma mark - Private Interface

@interface VFCTagCell : UITableViewCell
@property (nonatomic, strong, readwrite) UIView *selectionIndicator;
@end

#pragma mark - Private Implementation

@implementation VFCTagCell

#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setLayoutMargins:UIEdgeInsetsZero];
        [self setPreservesSuperviewLayoutMargins:NO];
        
        [[self textLabel] setTextColor:[UIColor blackColor]];
        
        UIView *selectionIndicator = [UIView newAutoLayoutView];
        [[self contentView] addSubview:selectionIndicator];
        [self setSelectionIndicator:selectionIndicator];
        [UIView autoSetPriority:999.0
                 forConstraints:^{
                     [selectionIndicator autoPinEdgeToSuperviewEdge:ALEdgeTop];
                     [selectionIndicator autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                     [selectionIndicator autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                     [selectionIndicator autoSetDimension:ALDimensionWidth toSize:5.0];
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

#pragma mark - VFCGapAnalysisTagsViewController

#pragma mark - Private Interface

static NSString *const VFCTagCellIdentifier = @"VFCTagCell";
static NSString *const VFCTagHeaderViewIdentifier = @"VFCTagHeaderView";

@interface VFCGapAnalysisTagsViewController : UITableViewController
@property (nonatomic, strong, readwrite) NSArray *tagSections;
@end

#pragma mark - Private Implementation

@implementation VFCGapAnalysisTagsViewController

#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tags" ofType:@"plist"];
        NSArray *tagSectionDicts = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *tagSections = [NSMutableArray array];
        for (NSDictionary *tagSectionDict in tagSectionDicts) {
            VFCTagSection *tagSection = [[VFCTagSection alloc] init];
            [tagSection setTitle:[tagSectionDict objectForKey:@"title"]];
            [tagSection setTags:[tagSectionDict objectForKey:@"tags"]];
            [tagSections addObject:tagSection];
        }
        [self setTagSections:[NSArray arrayWithArray:tagSections]];
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] setSeparatorInset:UIEdgeInsetsZero];
    [[self tableView] registerClass:[VFCTagCell class] forCellReuseIdentifier:VFCTagCellIdentifier];
    [[self tableView] registerClass:[VFCTagHeaderView class] forHeaderFooterViewReuseIdentifier:VFCTagHeaderViewIdentifier];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self tagSections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    VFCTagSection *tagSection = [[self tagSections] objectAtIndex:section];
    return [[tagSection tags] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFCTagCell *cell = [tableView dequeueReusableCellWithIdentifier:VFCTagCellIdentifier forIndexPath:indexPath];
    VFCTagSection *tagSection = [[self tagSections] objectAtIndex:[indexPath section]];
    NSString *tag = [[tagSection tags] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:tag];
    
    BOOL selected = (arc4random() % 2 == 0);
    UIColor *color = selected ? [UIColor venturaFoodsBlueColor] : [UIColor clearColor];
    [[cell selectionIndicator] setBackgroundColor:color];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VFCTagHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:VFCTagHeaderViewIdentifier];
    VFCTagSection *tagSection = [[self tagSections] objectAtIndex:section];
    [[headerView label] setText:[tagSection title]];
    [[headerView label] setTextColor:[UIColor whiteColor]];
    [[headerView contentView] setBackgroundColor:[UIColor venturaFoodsBlueColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

#pragma mark - VFCGapAnalysisViewController

#pragma mark - Private Interface

@interface VFCGapAnalysisViewController()
@end

#pragma mark - Public Implementation

@implementation VFCGapAnalysisViewController

- (instancetype)init {
    VFCGapAnalysisItemsViewController *itemsVC = [[VFCGapAnalysisItemsViewController alloc] init];
    self = [super initWithTopViewController:itemsVC];
    if (self) {
        [[itemsVC view] addGestureRecognizer:[self panGesture]];
        
        VFCGapAnalysisTagsViewController *tagsVC = [[VFCGapAnalysisTagsViewController alloc] initWithStyle:UITableViewStylePlain];
        [tagsVC setEdgesForExtendedLayout:UIRectEdgeTop|UIRectEdgeBottom|UIRectEdgeRight];
        [self setUnderRightViewController:tagsVC];
        [self setAnchorLeftRevealAmount:300.0];
        
        CALayer *layer = [[[self topViewController] view] layer];
        [layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
        [layer setShadowOpacity:1.0];
        [layer setShadowOffset:CGSizeZero];
        [layer setShadowRadius:1.0];
    }
    return self;
}

@end