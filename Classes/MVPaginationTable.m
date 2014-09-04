//
//  MVPaginationTable.m
//  MVPagination
//
//  Created by Michael on 29/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MVPaginationTable.h"

@interface MVPaginationTable ()
@property (nonatomic, strong) MVPaginator *paginator;
@property (nonatomic, assign, getter = getActivityIndicatorSize) CGSize activityIndicatorSize;
@property (nonatomic, assign) int numberOfRetry;
@end

@implementation MVPaginationTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void) setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.separatorColor = [UIColor grayColor];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorInset = UIEdgeInsetsZero;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedSectionFooterHeight = kAppHeightForFooter;
    self.userInteractionEnabled = YES;
    self.scrollEnabled = YES;
    self.pagingEnabled = NO;
    self.clipsToBounds = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.autoresizesSubviews = NO;
    self.scrollsToTop = NO;
    self.delaysContentTouches = YES;
    self.canCancelContentTouches = NO;
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kMVPaginationHeaderFooterIdentifier];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), self.footerHeight)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = tableFooterView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshHandle) forControlEvents:UIControlEventValueChanged];
    if (!self.sections)
        [self clearSections];
    
    self.paginator = [[MVPaginator alloc] init];
    self.paginator.paginatorDelegate = self;
    
    self.noMoreItemsText = MVLocalizedString(@"No more content", nil);
    self.shouldShowRefreshing = NO;
    self.shouldShowLoading = NO;
    self.numberOfRetry = 0;
}
- (void) clearSections
{
    self.sections = [[NSMutableDictionary alloc] init];
}
- (NSArray*) headers
{
    if (self.isSectionEnabled && self.sections && [[self.sections allKeys] count] > 0) {
        if (self.headerSortDescriptor)
            return [[self.sections allKeys] sortedArrayUsingDescriptors:@[self.headerSortDescriptor]];
        else
            return [self.sections allKeys];
    } else if (self.sections && [[self.sections allKeys] count] > 0) {
        return @[[[self.sections allKeys] firstObject]];
    }
    return nil;
    
}
- (float)getFooterHeight
{
    if (self.estimatedSectionFooterHeight > 0.0) {
        return self.estimatedSectionFooterHeight;
    } else {
        return kAppHeightForFooter;
    }
}
- (CGSize) getActivityIndicatorSize
{
    if (self.activityStyle == UIActivityIndicatorViewStyleWhiteLarge) {
        return kAppActivityIndicatorLargeSize;
    } else {
        return kAppActivityIndicatorSize;
    }
}
- (void) reloadTableSamePosition
{
    CGPoint contentOffset = self.contentOffset;
    [self reloadTable];
    [self setContentOffset:contentOffset animated:NO];
}
- (void) reloadTable
{
    if ([NSThread isMainThread]) {
		@synchronized (self) {
            if (self.isHidden)
                [self setHidden:NO];
            [UIView setAnimationsEnabled:NO];
			[self reloadData];
            [UIView setAnimationsEnabled:YES];
		}
	} else {
        [UIView setAnimationsEnabled:NO];
        if (self.isHidden)
            [self setHidden:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
        [UIView setAnimationsEnabled:YES];
	}
}
- (void) paginate
{
    if (![self.refreshControl isDescendantOfView:self]) {
        [self addSubview:self.refreshControl];
        [self bringSubviewToFront:self.refreshControl];
    }
    if (self.paginator) {
        [self.paginator load];
    }
}
- (void) retry
{
    if (self.paginator) {
        [self.paginator fetchRetry];
    }
}
- (void) forcePaginate
{
    if (self.paginator) {
        [self forceRefreshHandle];
    }
}
- (void) refreshHandle
{
    if (self.isLoadingMore) return;
    if (self.isRefreshing) return;
    self.isRefreshing = YES;
    self.isLoadingMore = NO;
    if (self.paginator)
        [self.paginator setReset];
    [self paginationData];
}
- (void) forceRefreshHandle
{
    if (self.isLoadingMore) return;
    if (self.isRefreshing) return;
    [self clearSections];
    self.isRefreshing = YES;
    self.isLoadingMore = NO;
    if (self.paginator)
        [self.paginator forceReset];
    [self paginationData];
}
- (void) paginationData
{
    if (!self.isRefreshing && !self.isLoadingMore && self.canLoadMore) return;
    if (self.paginator && self.paginator.currentPage < 1 && !self.sections) {
        self.sections = [[NSMutableDictionary alloc] init];
    }
    self.isLoadingMore = YES;
    if (self.paginator)
        [self.paginator fetchNextPage];
}
- (void) paginationCompleted
{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    }
    if (self.paginator && self.paginator.currentPage >= self.paginator.totalPage) {
        self.canLoadMore = NO;
    } else {
        self.canLoadMore = YES;
    }
    if (self.paginator && self.paginator.totalPage > 0) {
        self.isEmpty = NO;
    } else {
        self.isEmpty = YES;
    }
    if (self.isLoadingMore) {
        [self hideActivityView];
    }
    self.isLoadingMore = NO;
}
- (void) showActivityView
{
    if (self.tableFooterView) {
        if (self.footerView && [self.footerView isDescendantOfView:self]) {
            [self.footerView removeFromSuperview];
        }
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentSize.height - self.footerHeight, self.contentSize.width, self.footerHeight)];
        [self addSubview:self.footerView];
        if (self.activityIndicator && [self.activityIndicator isDescendantOfView:self.tableFooterView]) {
            [self.activityIndicator startAnimating];
        } else {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.footerView.frame) - self.activityIndicatorSize.width)/2, (self.footerHeight - self.activityIndicatorSize.height)/2, self.activityIndicatorSize.width, self.activityIndicatorSize.height)];
            if (self.activityStyle)
                self.activityIndicator.activityIndicatorViewStyle = self.activityStyle;
            else
                self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            self.activityIndicator.hidesWhenStopped = YES;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            [self.footerView addSubview:self.activityIndicator];
        }
    }
}
- (void) hideActivityView
{
    if (self.activityIndicator)
        [self.activityIndicator stopAnimating];
}
- (void) addNoMoreView
{
    if (self.tableFooterView) {
        if (self.footerView && [self.footerView isDescendantOfView:self]) {
            [self.footerView removeFromSuperview];
        }
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentSize.height - self.footerHeight, self.contentSize.width, self.footerHeight)];
        [self addSubview:self.footerView];
        if (self.paginator && self.paginator.currentPage >= self.paginator.totalPage && self.paginator.totalPage > 1) {
            UILabel *noMoreLabel = (UILabel*)[self.footerView viewWithTag:kAppNoMoreLabelTag];
            if (noMoreLabel && [noMoreLabel isDescendantOfView:self.tableFooterView]) {
                [noMoreLabel setHidden:NO];
            } else {
                noMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.footerView.frame), self.footerHeight)];
                noMoreLabel.textAlignment = NSTextAlignmentCenter;
                noMoreLabel.text = self.noMoreItemsText;
                noMoreLabel.backgroundColor = [UIColor clearColor];
                noMoreLabel.textColor = self.textColor;
                noMoreLabel.font = self.font;
                [self.footerView addSubview:noMoreLabel];
            }
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:self];
    float locationHeight = (IS_RETINA ? 40.0 : 20.0);
    if (location.y > 0.0 && location.y < locationHeight && location.x > 0.0 && location.x < locationHeight) {
        [self touchOnStatusBar];
    }
}

- (void) touchOnStatusBar
{
    [self setContentOffset:CGPointZero animated:YES];
}
- (void) loadMore
{
    if (self.isLoadingMore && !self.canLoadMore) return;
    [self showActivityView];
    self.isLoadingMore = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self addMoreItem];
    });
}
- (void) addMoreItem
{
    [self paginationData];
}
- (void)paginatorWillLoad:(MVPaginator *)paginator
{
    if (self.shouldShowRefreshing && self.refreshControl && !self.isRefreshing) {
    } else if (self.shouldShowLoading) {
        [self setIsWaiting:YES];
    }
    if (self.paginationDelegate && [self.paginationDelegate respondsToSelector:@selector(willPaginateTableView:)]) {
        [self.paginationDelegate willPaginateTableView:self];
    }
}

- (void)paginatorDidLoad:(MVPaginator *)paginator
{
    if (self.shouldShowRefreshing && self.refreshControl && !self.isRefreshing) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            CGPoint newPoint = self.contentOffset;
            newPoint.y += self.refreshControl.frame.size.height;
            self.contentOffset = newPoint;
        } completion:^(BOOL finished){
            [self.refreshControl endRefreshing];
            self.shouldShowRefreshing = NO;
        }];
    }
    if (self.shouldShowLoading) {
        [self setIsWaiting:NO];
    }
    if (self.paginationDelegate && [self.paginationDelegate respondsToSelector:@selector(didPaginateTableView:)]) {
        [self.paginationDelegate didPaginateTableView:self];
    }
}

- (void)paginator:(MVPaginator *)paginator didReceiveResults:(NSMutableArray *)results
{
    self.numberOfRetry = 0;
    if (self.paginationDelegate && [self.paginationDelegate respondsToSelector:@selector(paginateTableView:didReceiveResults:)]) {
        [self.paginationDelegate paginateTableView:self didReceiveResults:results];
    }
    [self paginationCompleted];
}

- (void)paginatorDidFail:(MVPaginator *)paginator error:(NSError *)error
{
    if (self.numberOfRetry < kAppNumberFailedRetry) {
        if (self.paginationDelegate && [self.paginationDelegate respondsToSelector:@selector(paginateDidFail:error:)]) {
            [self.paginationDelegate paginateDidFail:self error:error];
        }
    } else {
        self.isEmpty = YES;
    }
}
- (void)setIsWaiting:(BOOL)waiting
{
    if (waiting) {
        [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    } else {
        [MBProgressHUD hideAllHUDsForView:self.superview animated:YES];
    }
}
- (void)setSectionEnabled:(BOOL)sectionEnabled
{
    _sectionEnabled = sectionEnabled;
    if (self.isSectionEnabled) {
        self.estimatedSectionFooterHeight = 0.0;
    }
}
- (void)setPaginateUrl:(NSURL *)paginateUrl
{
    if (self.paginator && paginateUrl) {
        self.paginator.paginatorObject = paginateUrl;
    }
}
- (void)setPaginateResponseKey:(NSString *)paginateResponseKey
{
    if (self.paginator && paginateResponseKey) {
        self.paginator.paginatorKey = paginateResponseKey;
    }
}
- (void)setPaginateUrl:(NSURL *)paginateUrl responseKey:(NSString*)responseKey
{
    if (self.paginator && paginateUrl) {
        self.paginator.paginatorObject = paginateUrl;
        if (responseKey)
            self.paginator.paginatorKey = responseKey;
    }
}
- (void)setPaginateArray:(NSMutableArray *)paginateArray
{
    if (self.paginator && paginateArray) {
        self.paginator.paginatorObject = paginateArray;
    }
}
- (void)setPaginateClass:(Class)paginateClass
{
    if (self.paginator && paginateClass) {
        self.paginator.paginatorClass = paginateClass;
    }
}
- (void)setContext:(NSManagedObjectContext *)context
{
    if (self.paginator && context && self.paginator.paginatorType == MVPaginatorTypeCoreData) {
        self.paginator.managedContext = context;
    }
}
- (void)setPaginateClass:(Class)paginateClass context:(NSManagedObjectContext *)context predicate:(NSPredicate*)predicate order:(id)order
{
    if (self.paginator) {
        if (paginateClass)
            self.paginator.paginatorClass = paginateClass;
        if (context)
            self.paginator.managedContext = context;
            if (predicate)
                self.paginator.predicateOption = predicate;
            if (order)
                self.paginator.orderOption = order;
    }
}
- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle
{
    _activityStyle = activityStyle;
    if (self.activityIndicator) {
        self.activityIndicator.frame = CGRectMake((CGRectGetWidth(self.tableFooterView.frame) - self.activityIndicatorSize.width)/2, (self.footerHeight - self.activityIndicatorSize.height)/2, self.activityIndicatorSize.width, self.activityIndicatorSize.height);
    }
}
- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    UIView *noMoreLabel = [self.tableFooterView viewWithTag:kAppNoMoreLabelTag];
    if (noMoreLabel) {
        [(UILabel*)noMoreLabel setTextColor:_textColor];
    }
}
- (void)setFont:(UIFont *)font
{
    _font = font;
    UIView *noMoreLabel = [self.tableFooterView viewWithTag:kAppNoMoreLabelTag];
    if (noMoreLabel) {
        [(UILabel*)noMoreLabel setFont:self.font];
    }
}
@end
