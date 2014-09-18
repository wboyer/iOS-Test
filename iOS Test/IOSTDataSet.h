//
//  IOSTDataSet.h
//  iOS Test
//
//  Created by Bill Boyer on 9/17/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSTDataSet : NSObject <NSFetchedResultsControllerDelegate>

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context tableView:(UITableView *)tableView;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)addMore;
- (void)deleteAll;
- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
