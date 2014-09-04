//
//  MVPaginator.h
//  MVPagination
//
//  Created by Michael on 29/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MVPaginatorType) {
    MVPaginatorTypeDefault     = 0,
    MVPaginatorTypeArray       = 1 << 0,
    MVPaginatorTypeCoreData    = 1 << 1,
    MVPaginatorTypeUrl         = 1 << 2
};

typedef NS_OPTIONS(NSUInteger, MVPaginatorStatus) {
    MVPaginatorStatusNone           = 0,
    MVPaginatorStatusInProgress     = 1 << 0,
    MVPaginatorStatusDone           = 1 << 1
};

@class MVPaginator;

@protocol MVPaginatorDelegate <NSObject>
- (void) paginator:(MVPaginator*)paginator didReceiveResults:(NSMutableArray*)results;
@optional
- (void) paginatorWillLoad:(MVPaginator*)paginator;
- (void) paginatorDidLoad:(MVPaginator*)paginator;
- (void) paginatorDidFail:(MVPaginator*)paginator error:(NSError*)error;
- (void) paginatorDidReset:(MVPaginator*)paginator;
@end

@interface MVPaginator : NSObject
@property (nonatomic, assign) MVPaginatorType paginatorType;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL shouldResetDefault;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) NSMutableArray *collection;
@property (nonatomic, assign) id<MVPaginatorDelegate>  paginatorDelegate;
@property (nonatomic, assign) MVPaginatorStatus paginatorStatus;
@property (nonatomic, strong) id paginatorObject;
@property (nonatomic, strong) Class paginatorClass;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;
@property (nonatomic, strong) NSPredicate *predicateOption;
@property (nonatomic, strong) NSString *paginatorKey;
@property (nonatomic, strong) id orderOption;

//- (id) initWithArray:(NSMutableArray*)array delegate:(id<MVPaginatorDelegate>)delegate;
//- (id) initWithClass:(Class)className context:(NSManagedObjectContext*)context predicate:(NSPredicate*)predicate order:(id)order delegate:(id<MVPaginatorDelegate>)delegate;
//- (id) initWithUrl:(NSString*)url key:(NSString*)key delegate:(id<MVPaginatorDelegate>)delegate;
- (void) load;
- (void) setReset;
- (void) forceReset;
- (void) fetchFirstPage;
- (void) fetchNextPage;
- (void) fetchRetry;
@end