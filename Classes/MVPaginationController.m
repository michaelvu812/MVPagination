//
//  MVPaginationController.m
//  Pods
//
//  Created by Michael on 30/8/14.
//
//

#import "MVPaginationController.h"

@interface MVPaginationController ()

@end

@implementation MVPaginationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)paginateTableView:(MVPaginationTable *)tableView didReceiveResults:(NSMutableArray *)results
{
    
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[MVPaginationTable class]] && scrollView.contentOffset.y > 0.0) {
        MVPaginationTable *tableView = (MVPaginationTable*)scrollView;
        float scrollPosition = tableView.contentSize.height - CGRectGetHeight(tableView.frame) - (tableView.shouldShowRefreshing ? tableView.contentOffset.y + tableView.refreshControl.frame.size.height : tableView.contentOffset.y);
        if (scrollPosition < tableView.footerHeight && !tableView.isLoadingMore && tableView.canLoadMore) {
            [tableView loadMore];
        } else if (!tableView.isLoadingMore && !tableView.canLoadMore && ![tableView.tableFooterView viewWithTag:kAppNoMoreLabelTag]) {
            [tableView addNoMoreView];
        }
    }
}
@end
