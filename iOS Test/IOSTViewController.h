//
//  IOSTViewController.h
//  iOS Test
//
//  Created by Bill Boyer on 9/13/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IOSTViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet NSFetchedResultsController *fetchedResultsController;

- (IBAction)addMore:(id)sender;
- (IBAction)toggleEditing:(id)sender;
- (IBAction)deleteAll:(id)sender;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
