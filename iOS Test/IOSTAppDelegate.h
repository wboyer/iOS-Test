//
//  IOSTAppDelegate.h
//  iOS Test
//
//  Created by Bill Boyer on 9/13/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IOSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
