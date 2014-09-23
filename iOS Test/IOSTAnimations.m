//
//  IOSTAnimations.m
//  iOS Test
//
//  Created by Bill Boyer on 9/22/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import "IOSTAnimations.h"
#import "IOSTAnimator.h"

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
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(monitorMotion:) userInfo:nil repeats:YES];
    
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
    
    float leftEdge = 0;
    float rightEdge = [IOSTAnimator spaceOnRightForView:view andReferenceView:superView];

    CGPoint translation = [recognizer translationInView:superView];
    CGPoint velocity = [recognizer velocityInView:superView];

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.animations removeObjectForKey:view];
            [recognizer setTranslation:CGPointMake(frame.origin.x, 0) inView:superView];
            break;

        case UIGestureRecognizerStateEnded:
            if ([UIDynamicAnimator class]) {
                IOSTAnimator *animator = [[IOSTAnimator alloc] initWithView:view andReferenceView:superView];
                animator.delegate = self;
                
                [animator setBoundaries:rightEdge];

                UIDynamicItemBehavior *movement = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
                [movement addLinearVelocity:CGPointMake(velocity.x, 0.0) forItem:view];
                [animator addBehavior:movement];
                
                [self.animations setObject:animator forKey:view];
            }
            break;
             
        default:
            if ((translation.x >= leftEdge) && (translation.x < rightEdge))
                [view setFrame:CGRectMake(translation.x, 0, frame.size.width, frame.size.height)];
            break;
    }
}

- (void)monitorMotion:(NSTimer *)timer
{
    if (!self.enabled)
        return;
    
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    
    CMAcceleration gravity = motion.gravity;

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    float horizontalGravity = gravity.x;

    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            horizontalGravity *= -1;
            break
            ;
        case UIInterfaceOrientationLandscapeLeft:
            horizontalGravity = gravity.y;
            break
            ;
        case UIInterfaceOrientationLandscapeRight:
            horizontalGravity = -gravity.y;
            break
            ;
        default:
            break;
    }

    NSEnumerator *enumerator = [self.animations objectEnumerator];
    IOSTAnimator *animator;
    
    while ((animator = [enumerator nextObject])) {
        [animator setGravityDirection:CGVectorMake(horizontalGravity, 0.0)];
        if (orientation != self.lastOrientation)
            [animator setBoundaries];
    }
    
    self.lastOrientation = orientation;
}

@end
