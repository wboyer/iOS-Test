//
//  IOSTAnimations.m
//  iOS Test
//
//  Created by Bill Boyer on 9/22/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import "IOSTAnimations.h"

@implementation IOSTAnimations

- (id)init
{
    self.animations = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                valueOptions:NSMapTableStrongMemory
                                                    capacity:10];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionManager.deviceMotionUpdateInterval = 1.0/2.0;
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
 
    self.enabled = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(logMotion:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)enable
{
    self.enabled = YES;
}

- (void)disable
{
    [self.animations removeAllObjects];
    self.enabled = NO;
}

- (void)logMotion:(NSTimer *)timer
{
    if (!self.enabled)
        return;
    
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    
    CMAcceleration gravity = motion.gravity;
    NSLog(@"%5.2f %5.2f %5.2f", gravity.x, gravity.y, gravity.z);
}

- (void)addCell:(UITableViewCell *)cell
{
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dragCell:)];
    [cell.contentView addGestureRecognizer:gestureRecognizer];
}

- (void)dragCell:(UIPanGestureRecognizer *)recognizer
{
    if (!self.enabled)
        return;
    
    UIView *view = recognizer.view;
    UIView *superView = view.superview;

    CGRect frame = view.frame;

    CGPoint translation = [recognizer translationInView:superView];
    CGPoint velocity = [recognizer velocityInView:superView];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.animations removeObjectForKey:view];
            [recognizer setTranslation:CGPointMake(frame.origin.x, 0) inView:superView];
            break;

        case UIGestureRecognizerStateEnded:
            if ([UIDynamicAnimator class]) {
                UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:superView];
                animator.delegate = self;

                UIDynamicItemBehavior *movement = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
                [movement addLinearVelocity:CGPointMake(velocity.x, 0.0) forItem:view];

                [animator addBehavior:movement];

                [self.animations setObject:animator forKey:view];
            }
            break;
             
        default:
            [view setFrame:CGRectMake(translation.x, 0, frame.size.width, frame.size.height)];
            break;
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
                    withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
}

@end
