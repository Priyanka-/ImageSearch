//
//  ISSearchViewController.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/29/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISSearchViewController.h"
#import "ISResultsViewController.h"

#import "ISLocalPersistence.h"

#define kSearchHistoryCellIdentifier @"SearchHistory"
#define kTableViewTag 0x6000
#define kSearchBarTag 0x6001
#define kTableTitleTag 0x6002

@interface ISSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ISSearchViewController

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Add a search bar on top
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, navBarFrame.origin.y + navBarFrame.size.height + 4.0f, self.view.bounds.size.width, 44.0)];
    searchBar.delegate = self;
    searchBar.placeholder = NSLocalizedString(@"SearchBarPlaceholder", nil);
    searchBar.tag = kSearchBarTag;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:searchBar];
    
    CGRect searchBarFrame = searchBar.frame;

    
    CGRect frame = CGRectMake(0.0f, searchBarFrame.origin.y + searchBarFrame.size.height + 4.0f, self.view.bounds.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSearchHistoryCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.rowHeight = 40.0f;
    tableView.tag = kTableViewTag;
    
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [tableView backgroundColor];
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    tableTitle.text = NSLocalizedString(@"SearchHistoryText", nil);
    tableTitle.tag = kTableTitleTag;
    [tableTitle sizeToFit];
    tableView.tableHeaderView = tableTitle;
    [self.view addSubview:tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    UITableView* tableView = (UITableView*)[self.view viewWithTag:kTableViewTag];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helper methods
/*
Saves the query in local persistence and then pushes ResultsViewController to act on it
 */
- (void) processQuery:(NSString*)query{
    [[ISLocalPersistence singletonInstance] saveSearch:query];
    ISResultsViewController* resultsViewController = [[ISResultsViewController alloc] initWithQuery:query];
    [self.navigationController pushViewController:resultsViewController animated:YES];
}

-(void) localeDidChange:(NSNotification*) notification {
    UIView* view = [self.view viewWithTag:kSearchBarTag];
    if ([view isKindOfClass:[UISearchBar class]]) {
        ((UISearchBar*)view).placeholder = NSLocalizedString(@"SearchBarPlaceholder", nil);
        [view setNeedsLayout];
    }
    view = [self.view viewWithTag:kTableTitleTag];
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel*)view).text = NSLocalizedString(@"SearchHistoryText", nil);
        [view setNeedsLayout];
    }
}

#pragma mark Search delegate

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self.datafetcher clearData];
    //[self.collectionView reloadData];
    
    NSString* searchTerm = searchBar.text;
    searchTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(!searchTerm || [searchTerm isEqualToString:@""]) {
        return;
    }
    //TODO: Show activity indicator
    
    //remove the keyboard
    [searchBar resignFirstResponder];
    [self processQuery:searchTerm];
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[ISLocalPersistence singletonInstance] numberOfSavedQueries];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSearchHistoryCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchHistoryCellIdentifier];
    }
    cell.textLabel.text = [[ISLocalPersistence singletonInstance] queryAtIndex:indexPath.row];
    [cell.textLabel sizeToFit];
    
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger historyIndex = indexPath.row;
    NSString* query = [[ISLocalPersistence singletonInstance] queryAtIndex:historyIndex];
    [self processQuery:query];
}

@end
