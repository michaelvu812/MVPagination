//
//  MultipleViewController.m
//  Example
//
//  Created by Michael on 4/9/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MultipleViewController.h"

@interface MultipleViewController ()

@end

@implementation MultipleViewController

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
    int total = 50;
    NSMutableArray *arr = [NSMutableArray array];
    for(int x = 0; x < total; x++)
        [arr addObject:[NSNumber numberWithInt:x]];
    
    float padding = 5, width = CGRectGetWidth(self.view.bounds)/2 - (padding*2), height = CGRectGetHeight(self.view.bounds)/2 - (padding*2);
    
    self.tableViewOne = [[MVPaginationTable alloc] initWithFrame:CGRectMake(padding, padding, width, height)];
    self.tableViewOne.dataSource = self;
    self.tableViewOne.delegate = self;
    self.tableViewOne.paginationDelegate = self;
    self.tableViewOne.paginateArray = arr;
    self.tableViewOne.activityStyle = UIActivityIndicatorViewStyleGray;
    self.tableViewOne.layer.borderColor = [UIColor grayColor].CGColor;
    self.tableViewOne.layer.borderWidth = 1.0;
    [self.tableViewOne reloadTable];
    [self.view addSubview:self.tableViewOne];
    [self.tableViewOne paginate];
    
    self.tableViewTwo = [[MVPaginationTable alloc] initWithFrame:CGRectMake(width + padding * 2, padding, width, height)];
    self.tableViewTwo.dataSource = self;
    self.tableViewTwo.delegate = self;
    self.tableViewTwo.paginationDelegate = self;
    self.tableViewTwo.paginateArray = arr;
    self.tableViewTwo.activityStyle = UIActivityIndicatorViewStyleGray;
    self.tableViewTwo.layer.borderColor = [UIColor grayColor].CGColor;
    self.tableViewTwo.layer.borderWidth = 1.0;
    [self.tableViewTwo reloadTable];
    [self.view addSubview:self.tableViewTwo];
    [self.tableViewTwo paginate];
    
    self.tableViewThree = [[MVPaginationTable alloc] initWithFrame:CGRectMake(padding, height+padding*2, width, height)];
    self.tableViewThree.dataSource = self;
    self.tableViewThree.delegate = self;
    self.tableViewThree.paginationDelegate = self;
    self.tableViewThree.paginateArray = arr;
    self.tableViewThree.activityStyle = UIActivityIndicatorViewStyleGray;
    self.tableViewThree.layer.borderColor = [UIColor grayColor].CGColor;
    self.tableViewThree.layer.borderWidth = 1.0;
    [self.tableViewThree reloadTable];
    [self.view addSubview:self.tableViewThree];
    [self.tableViewThree paginate];
    
    self.tableViewFour = [[MVPaginationTable alloc] initWithFrame:CGRectMake(width + padding * 2, height + padding*2, width, height)];
    self.tableViewFour.dataSource = self;
    self.tableViewFour.delegate = self;
    self.tableViewFour.paginationDelegate = self;
    self.tableViewFour.paginateArray = arr;
    self.tableViewFour.activityStyle = UIActivityIndicatorViewStyleGray;
    self.tableViewFour.layer.borderColor = [UIColor grayColor].CGColor;
    self.tableViewFour.layer.borderWidth = 1.0;
    [self.tableViewFour reloadTable];
    [self.view addSubview:self.tableViewFour];
    [self.tableViewFour paginate];
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
