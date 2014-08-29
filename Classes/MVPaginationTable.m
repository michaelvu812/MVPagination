//
//  MVPaginationTable.m
//  MVPagination
//
//  Created by Michael on 29/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MVPaginationTable.h"

#define kMVPaginationHeaderFooterIdentifier @"HeaderFooterCellIdentifier"

@interface MVPaginationTable ()
@property (nonatomic, strong) NSArray *sortDescriptors;
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
    self.userInteractionEnabled = YES;
    self.scrollEnabled = YES;
    self.pagingEnabled = NO;
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.autoresizesSubviews = NO;
    self.scrollsToTop = NO;
    self.delaysContentTouches = YES;
    self.canCancelContentTouches = NO;
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kMVPaginationHeaderFooterIdentifier];
}
- (void) clearSections
{
    self.sections = [[NSMutableDictionary alloc] init];
}
- (NSArray*) headers
{
    if (self.isSectionEnabled && self.sections && [[self.sections allKeys] count] > 0) {
        return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return nil;
}
- (void)setHeaderSort:(id)headerSort
{
    _headerSort = headerSort;
}
@end
