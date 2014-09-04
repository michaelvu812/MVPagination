//
//  SingleViewController.m
//  Example
//
//  Created by Michael on 4/9/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "SingleViewController.h"

@interface SingleViewController ()

@end

@implementation SingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int total = 20;
    NSMutableArray *arr = [NSMutableArray array];
    for(int x = 0; x < total; x++)
        [arr addObject:[NSNumber numberWithInt:x]];
    self.tableView = [[MVPaginationTable alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.paginationDelegate = self;
    self.tableView.paginateArray = arr;
    self.tableView.activityStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView reloadTable];
    [self.view addSubview:self.tableView];
    [self.tableView paginate];
}
- (void)paginateTableView:(MVPaginationTable *)tableView didReceiveResults:(NSMutableArray *)results
{
    NSString *key = @"object";
    NSMutableArray *array = [tableView.sections objectForKey:key];
    if (!array)
        array = [[NSMutableArray alloc] init];
    for (NSNumber *number in results) {
        if (![array containsObject:number]) {
            [array addObject:number];
        }
    }
    [tableView.sections setObject:array forKey:key];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d - %d", indexPath.section, indexPath.row];
    return cell;
}
@end
