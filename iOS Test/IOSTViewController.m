//
//  IOSTViewController.m
//  iOS Test
//
//  Created by Bill Boyer on 9/13/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import "IOSTViewController.h"
#import "IOSTAppDelegate.h"

@interface IOSTViewController ()

@end

@implementation IOSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    IOSTAppDelegate *app = (IOSTAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dataSet = [[IOSTDataSet alloc] initWithManagedObjectContext:app.managedObjectContext tableView:self.tableView];

    self.animations = [[IOSTAnimations alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addMoreData:(id)sender;
{
    [self.dataSet addMore];
}

- (IBAction)toggleEditingMode:(id)sender;
{
    if (self.tableView.editing) {
        [self.animations enable];
        [self.tableView setEditing:NO animated:true];
    }
    else {
        [self.animations disable];
        [self.tableView setEditing:YES animated:true];
    }
}

- (IBAction)deleteAllData:(id)sender;
{
    [self.dataSet deleteAll];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dataSet.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if ([[self.dataSet.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSet.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.dataSet.fetchedResultsController objectAtIndexPath:indexPath];

    NSString *label = [NSString stringWithFormat:@"%@ %lu", [managedObject valueForKey:@"name"], (unsigned long)[indexPath row]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:label];
    cell.textLabel.text = label;
    
    NSData *imageData = [managedObject valueForKey:@"data"];
    
    if (imageData)
        cell.imageView.image = [UIImage imageWithData:imageData];

    [self.animations addCell:cell];

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.editing ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSet.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSet.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.dataSet.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.dataSet.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSet deleteObjectAtIndexPath:indexPath];
}

@end
