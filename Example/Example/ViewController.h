//
//  ViewController.h
//  Example
//
//  Created by Michael on 30/8/14.
//  Copyright (c) 2014 Michael Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleViewController.h"
#import "MultipleViewController.h"
#import "MultipleSectionViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
