//
//  MVPaginator.m
//  MVPagination
//
//  Created by Michael on 29/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MVPaginator.h"

#define MVPaginatorDefaultPageSize 10

@implementation MVPaginator
- (id) init
{
    self = [super init];
    if (self) {
        self.paginatorType = MVPaginatorTypeDefault;
        [self setDefaultValues];
        self.shouldResetDefault = YES;
        if (!self.collection)
            self.collection = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)setPaginatorObject:(id)paginatorObject
{
    if ([paginatorObject isKindOfClass:[NSArray class]] || [paginatorObject isKindOfClass:[NSMutableArray class]]) {
        _paginatorObject = paginatorObject;
        self.paginatorType = MVPaginatorTypeArray;
    } else if ([paginatorObject isKindOfClass:[NSString class]] || [paginatorObject isKindOfClass:[NSURL class]]) {
        if ([paginatorObject isKindOfClass:[NSURL class]]) {
            _paginatorObject = [(NSURL*)paginatorObject path];
        } else {
            _paginatorObject = paginatorObject;
        }
        self.paginatorType = MVPaginatorTypeUrl;
    }
}
- (void)setPaginatorClass:(Class)paginatorClass
{
    _paginatorClass = paginatorClass;
    self.paginatorType = MVPaginatorTypeCoreData;
}
- (void) setDefaultValues
{
    if (!self.shouldResetDefault) return;
    if (self.pageSize <= 0)
        self.pageSize = MVPaginatorDefaultPageSize;
    self.isFirstLoad = YES;
    if (self.totalCount <= 0)
        self.totalCount = 0;
    if (self.totalPage <= 0)
        self.totalPage = 0;
    if (self.currentPage <= 0)
        self.currentPage = 0;
    self.collection = [[NSMutableArray alloc] init];
    self.paginatorStatus = MVPaginatorStatusNone;
}
- (void) setForceDefaultValues
{
    if (self.pageSize <= 0)
        self.pageSize = MVPaginatorDefaultPageSize;
    self.isFirstLoad = YES;
    self.totalCount = 0;
    self.totalPage = 0;
    self.currentPage = 0;
    self.collection = [[NSMutableArray alloc] init];
    self.paginatorStatus = MVPaginatorStatusNone;
}
- (void) load
{
    if ([self.paginatorDelegate respondsToSelector:@selector(paginatorWillLoad:)]) {
        [self.paginatorDelegate paginatorWillLoad:self];
    }
    [self reset];
    self.isFirstLoad = YES;
    [self fetchNextPage];
}
- (void) setReset
{
    self.shouldResetDefault = YES;
    [self reset];
}
- (void) reset
{
    [self setDefaultValues];
    if ([self.paginatorDelegate respondsToSelector:@selector(paginatorDidReset:)]) {
        [self.paginatorDelegate paginatorDidReset:self];
    }
}
- (void) forceReset
{
    [self setForceDefaultValues];
    if ([self.paginatorDelegate respondsToSelector:@selector(paginatorDidReset:)]) {
        [self.paginatorDelegate paginatorDidReset:self];
    }
}
- (BOOL) isLastPage
{
    if (self.paginatorStatus == MVPaginatorStatusNone)
        return NO;
    return (self.currentPage >= self.totalPage);
}
- (void) fetchFirstPage
{
    [self load];
}
- (void) fetchNextPage
{
    if (self.paginatorStatus == MVPaginatorStatusInProgress) return;
    if (![self isLastPage]) {
        self.paginatorStatus = MVPaginatorStatusInProgress;
        [self fetchResultsWithPage:(self.shouldResetDefault ? 1 : self.currentPage+1) pageSize:self.pageSize];
    }
}
- (void) fetchRetry
{
    if (self.paginatorStatus == MVPaginatorStatusInProgress) return;
    if (![self isLastPage]) {
        self.paginatorStatus = MVPaginatorStatusInProgress;
        [self fetchResultsWithPage:self.currentPage pageSize:self.pageSize];
    }
}
- (void) fetchResultsWithPage:(int)page pageSize:(int)size
{
    if (self.paginatorType == MVPaginatorTypeDefault || self.paginatorType == MVPaginatorTypeArray) {
        NSMutableArray *array;
        if ([self.paginatorObject isKindOfClass:[NSArray class]]) {
            array = [NSMutableArray arrayWithArray:self.paginatorObject];
        } else {
            array = [self.paginatorObject mutableCopy];
        }
        int arrayCount = (int)[array count];
        if (arrayCount > 0) {
            int location = (page * size) - size;
            int length = 0;
            if (self.totalCount > 0 && (self.totalCount - location) > 0 && (self.totalCount - location) < size) {
                length = (self.totalCount - location);
            } else if (arrayCount < size) {
                length = arrayCount;
            } else {
                length = size;
            }
            NSArray *results = [array subarrayWithRange:NSMakeRange(location, length)];
            [self receivedResults:results total:(int)[array count]];
        } else {
            [self receivedResults:[[NSArray alloc] init] total:0];
        }
    } else if (self.paginatorType == MVPaginatorTypeCoreData) {
        if ([self.paginatorClass isSubclassOfClass:[NSManagedObject class]]) {
            NSArray *array = [[NSArray alloc] init];
            if (self.predicateOption) {
                if (self.orderOption)
                    array = [self.paginatorClass where:self.predicateOption inContext:self.managedContext order:self.orderOption];
                else
                    array = [self.paginatorClass where:self.predicateOption inContext:self.managedContext];
            } else {
                if (self.orderOption)
                    array = [self.paginatorClass allInContext:self.managedContext order:self.orderOption];
                else
                    array = [self.paginatorClass allInContext:self.managedContext];
            }
            int arrayCount = (int)[array count];
            if (arrayCount > 0) {
                int location = (page * size) - size;
                int length = 0;
                if (self.totalCount > 0 && (self.totalCount - location) > 0 && (self.totalCount - location) < size) {
                    length = (self.totalCount - location);
                } else if (arrayCount < size) {
                    length = arrayCount;
                } else {
                    length = size;
                }
                NSArray *results = [array subarrayWithRange:NSMakeRange(location, length)];
                [self receivedResults:results total:(int)[array count]];
            } else {
                [self receivedResults:[[NSArray alloc] init] total:0];
            }
        } else {
            [self receivedResults:[[NSArray alloc] init] total:0];
        }
    } else if (self.paginatorType == MVPaginatorTypeUrl) {
        NSArray *array = [[NSArray alloc] init];
        int total = 0;
        NSString *urlString;
        if ([(NSString*)self.paginatorObject rangeOfString:@"?"].location != NSNotFound) {
            urlString = [(NSString*)self.paginatorObject stringByAppendingFormat:@"&page=%d&per_page=%d", page, size];
        } else {
            urlString = [(NSString*)self.paginatorObject stringByAppendingFormat:@"?page=%d&per_page=%d", page, size];
        }
        if ([self connected]) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject && [responseObject valueForKey:self.paginatorKey]) {
                    [self receivedResults:[responseObject valueForKey:self.paginatorKey] total:[[responseObject valueForKey:@"total_count"] intValue]];
                } else {
                    [self receivedResults:array total:total];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (operation.responseObject && [operation.responseObject valueForKeyPath:@"error"]) {
                    [self receivedFailedResults:[self errorWithMessage:[operation.responseObject valueForKeyPath:@"error"]]];
                } else {
                    [self receivedFailedResults:[self errorWithMessage:[error localizedDescription]]];
                }
            }];
        } else {
            [self receivedFailedResults:[self errorWithMessage:MVLocalizedString(@"No Internet Connection", nil)]];
        }
    } else {
        [self receivedFailedResults:[self errorWithMessage:MVLocalizedString(@"Wrong pagination type", nil)]];
    }
}
- (NSError*) errorWithMessage:(NSString*)message
{
    NSMutableDictionary *errorDetail = [[NSMutableDictionary alloc] init];
    [errorDetail setValue:message forKey:NSLocalizedDescriptionKey];
    return [[NSError alloc] initWithDomain:@"MVPaginator" code:NSURLErrorUnknown userInfo:errorDetail];
}
- (void) receivedResults:(NSArray*)results total:(int)total
{
    if (self.isFirstLoad && [self.paginatorDelegate respondsToSelector:@selector(paginatorDidLoad:)]) {
        self.isFirstLoad = NO;
        [self.paginatorDelegate paginatorDidLoad:self];
    }
    [self.collection addObjectsFromArray:results];
    if (!self.shouldResetDefault || self.currentPage <= 0)
        self.currentPage += 1;
    self.totalCount = total;
    self.totalPage = (int)ceil((double)self.totalCount/(double)self.pageSize);
    self.paginatorStatus = MVPaginatorStatusDone;
    self.shouldResetDefault = NO;
    if ([self.paginatorDelegate respondsToSelector:@selector(paginator:didReceiveResults:)]) {
        [self.paginatorDelegate paginator:self didReceiveResults:self.collection];
    }
}
- (void) receivedFailedResults:(NSError*)error
{
    self.shouldResetDefault = NO;
    if (self.isFirstLoad && [self.paginatorDelegate respondsToSelector:@selector(paginatorDidLoad:)]) {
        self.isFirstLoad = NO;
        [self.paginatorDelegate paginatorDidLoad:self];
    }
    self.paginatorStatus = MVPaginatorStatusDone;
    if ([self.paginatorDelegate respondsToSelector:@selector(paginatorDidFail:error:)]) {
        [self.paginatorDelegate paginatorDidFail:self error:error];
    }
}
- (BOOL) connected
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
@end