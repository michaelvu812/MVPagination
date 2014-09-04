//
//  MultipeSectionViewController.h
//  Example
//
//  Created by Michael on 4/9/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import "MVPaginationController.h"

@interface MultipleSectionViewController : MVPaginationController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MVPaginationTable *tableView;
@end
