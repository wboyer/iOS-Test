//
//  IOSTAnimations.h
//  iOS Test
//
//  Created by Bill Boyer on 9/22/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreMotion;

@interface IOSTAnimations : NSObject <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

@property (strong, nonatomic) NSMapTable *animations;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property BOOL enabled;

- (id)init;

- (void)addCell:(UITableViewCell *)cell;

- (void)enable;
- (void)disable;

@end
