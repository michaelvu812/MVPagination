//
//  MultipleViewController.h
//  Example
//
//  Created by Michael on 4/9/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MVPaginationController.h"
#import "MVPagination.h"

@interface MultipleViewController : MVPaginationController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MVPaginationTable *tableViewOne;
@property (nonatomic, strong) MVPaginationTable *tableViewTwo;
@property (nonatomic, strong) MVPaginationTable *tableViewThree;
@property (nonatomic, strong) MVPaginationTable *tableViewFour;
@end
