//
//  IOSTViewController.h
//  iOS Test
//
//  Created by Bill Boyer on 9/13/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IOSTDataSet.h"
#import "IOSTAnimations.h"

@interface IOSTViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IOSTDataSet *dataSet;

@property (strong, nonatomic) IOSTAnimations *animations;

- (IBAction)addMoreData:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;
- (IBAction)deleteAllData:(id)sender;

@end
