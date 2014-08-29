//
//  MVPaginationTable.h
//  MVPagination
//
//  Created by Michael on 29/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPaginator.h"

@interface MVPaginationTable : UITableView
@property (nonatomic, strong) NSMutableDictionary *sections;
@property (nonatomic, strong) MVPaginator *paginator;
@property(nonatomic, getter = isSectionEnabled) BOOL sectionEnabled;
@property (nonatomic, retain) id headerSort;
- (void) clearSections;
@end
