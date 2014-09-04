//
//  MultipeSectionViewController.m
//  Example
//
//  Created by Michael on 4/9/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MultipleSectionViewController.h"

@interface MultipleSectionViewController ()

@end

@implementation MultipleSectionViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *arr = [NSMutableArray array];
    int a = 65;
    for (; a < 91; a++) {
        [arr addObject:[NSString stringWithFormat:@"%c", (char)a]];
    }
    self.tableView = [[MVPaginationTable alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.paginationDelegate = self;
    self.tableView.sectionEnabled = YES;
    self.tableView.paginateArray = arr;
    self.tableView.activityStyle = UIActivityIndicatorViewStyleGray;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    self.tableView.headerSortDescriptor = sortDescriptor;
    [self.tableView reloadTable];
    [self.view addSubview:self.tableView];
    [self.tableView paginate];
}
- (void)paginateTableView:(MVPaginationTable *)tableView didReceiveResults:(NSMutableArray *)results
{
    for (NSString *key in results) {
        if (![[tableView.sections allKeys] containsObject:key]) {
            [tableView.sections setObject:[[NSMutableArray alloc] init] forKey:key];
        }
    }
    for (NSString *key in results) {
        if (![[tableView.sections objectForKey:key] containsObject:key]) {
            [[tableView.sections objectForKey:key] addObject:key];
        }
    }
    [tableView reloadTable];
}

- (void)paginateDidFail:(MVPaginationTable *)tableView error:(NSError *)error
{
    NSString *errorString;
    if (error) {
        errorString = [error localizedDescription];
    } else {
        errorString = @"Failed";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
    [alert show];
    return;
}
- (CGFloat)tableView:(MVPaginationTable *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (UIView *)tableView:(MVPaginationTable *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMVPaginationHeaderFooterIdentifier];
    headerview.contentView.backgroundColor = [UIColor grayColor];
    headerview.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self tableView:tableView heightForHeaderInSection:section]);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:headerview.bounds];
    nameLabel.text = [NSString stringWithFormat:@"Header %@", [tableView.headers objectAtIndex:section]];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    [headerview.contentView addSubview:nameLabel];
    return headerview.contentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return tableView.tableFooterView;
}
- (NSInteger)numberOfSectionsInTableView:(MVPaginationTable *)tableView
{
    if (tableView.isSectionEnabled) {
        return [tableView.headers count];
    } else if (!tableView.isEmpty || (tableView.sections && [[tableView.sections allKeys] count] > 0)) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(MVPaginationTable *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tableView.sections objectForKey:[tableView.headers objectAtIndex:section]] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(MVPaginationTable *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %@", [[tableView.sections objectForKey:[tableView.headers objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
    return cell;
}
@end
