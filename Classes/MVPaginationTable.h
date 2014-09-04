//
//  MVPaginationTable.h
//  MVPagination
//
//  Created by Michael on 29/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPaginationConstants.h"
#import "MVPaginator.h"

@class MVPaginationTable;

@protocol MVPaginationTableDelegate <NSObject>
- (void) paginateTableView:(MVPaginationTable*)tableView didReceiveResults:(NSMutableArray*)results;
@optional
- (void) willPaginateTableView:(MVPaginationTable*)tableView;
- (void) didPaginateTableView:(MVPaginationTable*)tableView;
- (void) paginateDidFail:(MVPaginationTable*)tableView error:(NSError*)error;
- (void) paginateDidReset:(MVPaginationTable*)tableView;
@end

@interface MVPaginationTable : UITableView <UIScrollViewDelegate, MVPaginatorDelegate>
@property (nonatomic, assign) id<MVPaginationTableDelegate>  paginationDelegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableDictionary *sections;
@property(nonatomic, getter = isSectionEnabled) BOOL sectionEnabled;
@property (nonatomic, retain) NSSortDescriptor *headerSortDescriptor;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) BOOL isLoadingMore;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *emptyText;
@property (nonatomic, strong) NSString *noMoreItemsText;
@property (nonatomic, assign) BOOL shouldShowLoading;
@property (nonatomic, assign) BOOL shouldShowRefreshing;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, strong) NSMutableArray *paginateArray;
@property (nonatomic, strong) NSURL *paginateUrl;
@property (nonatomic, assign) Class paginateClass;
@property (nonatomic, strong) NSString *paginateResponseKey;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign, getter = getFooterHeight) float footerHeight;
@property (nonatomic, strong) UIView *footerView;
- (void) clearSections;
- (NSArray*) headers;
- (void) reloadTableSamePosition;
- (void) reloadTable;
- (void) paginate;
- (void) forcePaginate;
- (void) refreshHandle;
- (void) forceRefreshHandle;
- (void) loadMore;
- (void) addNoMoreView;
- (void) paginationCompleted;
- (void)setPaginateUrl:(NSURL *)paginateUrl responseKey:(NSString*)responseKey;
- (void)setPaginateClass:(Class)paginateClass context:(NSManagedObjectContext *)context predicate:(NSPredicate*)predicate order:(id)order;
@end
