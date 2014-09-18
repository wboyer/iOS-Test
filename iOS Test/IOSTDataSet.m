//
//  IOSTDataSet.m
//  iOS Test
//
//  Created by Bill Boyer on 9/17/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import "IOSTDataSet.h"

@implementation IOSTDataSet

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                         tableView:(UITableView *)tableView
{
    self = [super init];

    if (self)
    {
        self.tableView = tableView;
        self.managedObjectContext = managedObjectContext;
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:fetchRequest
                                         managedObjectContext:self.managedObjectContext
                                         sectionNameKeyPath:nil
                                         cacheName:nil];
        
        self.fetchedResultsController.delegate = self;
        
        NSError *error;
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }

    return self;
}

- (void)addMore;
{
    for (int i = 0; i < 5; i++) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%s", "emojipedia.org/wp-content/uploads/2014/04/80x80x1f60d-google-android.png.pagespeed.ic.yLwbJ0broV.png"]]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSManagedObject *newImage = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Image"
                                          inManagedObjectContext:self.managedObjectContext];
             
             [newImage setValue:data forKey:@"data"];
             
             [newImage setValue:@"x" forKey:@"name"];
             [newImage setValue:@"y" forKey:@"url"];
             
             if (![self.managedObjectContext save:&error]) {
                 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                 abort();
             }
         }];
    }
}

- (void)deleteAll;
{
    for (id object in [self.fetchedResultsController fetchedObjects]) {
        [self.managedObjectContext deleteObject:object];
    }
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
{
    [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            not supported yet
            //            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
            //                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
