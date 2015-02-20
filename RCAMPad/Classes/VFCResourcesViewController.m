//
//  VFCResourcesViewController.m
//  RCAMPad
//
//  Created by Xcelerate Media iMac on 12/22/14.
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

@import MessageUI;
#import "ReaderViewController.h"
#import "ReaderDocument.h"
#import "VFCResourcesViewController.h"
#import "UIColor+VFCAdditions.h"

#pragma mark - VFCResourceCell

#pragma mark - Private Interface

@interface VFCResourceCell : UITableViewCell
@end

#pragma mark - Private Implementation

@implementation VFCResourceCell

#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setLayoutMargins:UIEdgeInsetsZero];
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    return self;
}

@end

#pragma mark - VFCResourcesViewController

#pragma mark - Private Interface

static NSString *VFCResourceCellIdentifier = @"VFCResourceCell";

@interface VFCResourcesViewController() <MFMailComposeViewControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong, readwrite) NSArray *resources;
@end

#pragma mark - Public Implementation

@implementation VFCResourcesViewController

#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        NSArray *resources = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:@"resources"];
        [self setResources:resources];
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    [searchController setHidesNavigationBarDuringPresentation:NO];
    [[searchController searchBar] setDelegate:self];
    [searchController setDelegate:self];
    [searchController setSearchResultsUpdater:self];
    [[searchController searchBar] setPlaceholder:NSLocalizedString(@"Resources", @"kResources")];
    [[self navigationItem] setTitleView:[searchController searchBar]];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:VFCResourceCellIdentifier];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setText:nil];
}

#pragma mark UISearchControllerDelegate

#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    /*NSString *searchText = [[searchController searchBar] text];
    // Strip out leading and trailing white space
    NSString *strippedStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    XSCDocumentsViewController *filteredVC = (XSCDocumentsViewController *)[searchController searchResultsController];
    
    if ([strippedStr length] > 0) {
        NSMutableArray *filteredContents = [NSMutableArray array];
        NSArray *searchTerms = [searchText componentsSeparatedByString:@" "];
        NSMutableArray *dItems = [[self directoryContents] mutableCopy];
        for (NSString *item in dItems) {
            for (NSString *term in searchTerms) {
                if ([item containsString:term]) {
                    [filteredContents addObject:item];
                    break;
                }
            }
        }
        [filteredVC setDirectoryContents:[filteredContents mutableCopy]];
    } else {
        [filteredVC setDirectoryContents:[[self directoryContents] mutableCopy]];
    }*/
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self resources] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VFCResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:VFCResourceCellIdentifier forIndexPath:indexPath];
    NSString *resource = [[self resources] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:resource];
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:NSLocalizedString(@"Export", @"kExport")
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                                                                        [mailVC setMailComposeDelegate:self];
                                                                        [[mailVC navigationBar] setTintColor:[UIColor whiteColor]];
                                                                        [self presentViewController:mailVC animated:YES completion:nil];
                                                                    }];
    [action setBackgroundColor:[UIColor venturaBlueColor]];
    return @[action];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*NSString *resource = [[self resources] objectAtIndex:[indexPath row]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
    NSLog(@"%@", filePath);
    ReaderDocument *doc = [ReaderDocument withDocumentFilePath:filePath password:nil];
    NSLog(@"%@", doc);
    ReaderViewController *readerVC = [[ReaderViewController alloc] initWithReaderDocument:doc];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:readerVC];
    [self presentViewController:navController animated:YES completion:nil];*/
}

@end
