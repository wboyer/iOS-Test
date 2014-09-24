//
//  IOSTAnimator.h
//  iOS Test
//
//  Created by Bill Boyer on 9/23/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSTAnimator : UIDynamicAnimator

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *motionBehavior;

@property (strong, nonatomic) UICollisionBehavior *leftBoundary;
@property (strong, nonatomic) UICollisionBehavior *rightBoundary;

+ (float)spaceOnRightForView:(UIView *)view andReferenceView:(UIView *)referenceView;

- (IOSTAnimator *)initWithView:(UIView *)view andReferenceView:(UIView *)referenceView;

- (void)setGravityDirection:(CGVector)gravityDirection;
- (void)addVelocity:(CGPoint)velocity;

- (void)setBoundaries:(float)rightEdge;
- (void)setBoundaries;

@end
