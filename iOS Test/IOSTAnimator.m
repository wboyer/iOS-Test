//
//  IOSTAnimator.m
//  iOS Test
//
//  Created by Bill Boyer on 9/23/14.
//  Copyright (c) 2014 Bill Boyer. All rights reserved.
//

#import "IOSTAnimator.h"

@implementation IOSTAnimator

+ (float)spaceOnRightForView:(UIView *)view andReferenceView:(UIView *)referenceView
{
    float rightEdge = referenceView.frame.size.width - 5;
    
    for (UIView *subview in view.subviews)
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            float textWidth = [[label text] sizeWithAttributes:@{NSFontAttributeName:[label font]}].width;
            rightEdge -= label.frame.origin.x + textWidth;
            if (rightEdge < 0)
                rightEdge = 0;
            break;
        }
    
    return rightEdge;
}

- (IOSTAnimator *)initWithView:(UIView *)view andReferenceView:(UIView *)referenceView
{
    self = [super initWithReferenceView:referenceView];
    self.view = view;

    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[view]];
    [self addBehavior:self.gravityBehavior];

    [self setGravityDirection:CGVectorMake(0.0, 0.0)];

    self.motionBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
    [self addBehavior:self.motionBehavior];

    UICollisionBehavior *boundary = [[UICollisionBehavior alloc] initWithItems:@[view]];
    [self addBehavior:boundary];
    self.leftBoundary = boundary;
    
    boundary = [[UICollisionBehavior alloc] initWithItems:@[view]];
    [self addBehavior:boundary];
    self.rightBoundary = boundary;
    
    return self;
}

- (void)setGravityDirection:(CGVector)gravityDirection
{
    self.gravityBehavior.gravityDirection = gravityDirection;
}

- (void)addVelocity:(CGPoint)velocity
{
    [self.motionBehavior addLinearVelocity:velocity forItem:self.view];
}

- (void)setBoundaries:(float)rightEdge
{
    [self.leftBoundary removeAllBoundaries];
    [self.leftBoundary addBoundaryWithIdentifier:@"left"
                                       fromPoint:CGPointMake(0, 0)
                                         toPoint:CGPointMake(0, self.referenceView.frame.size.height)];

    float rightBoundary = rightEdge + self.referenceView.frame.size.width;

    [self.rightBoundary removeAllBoundaries];
    [self.rightBoundary addBoundaryWithIdentifier:@"right"
                                        fromPoint:CGPointMake(rightBoundary, 0)
                                          toPoint:CGPointMake(rightBoundary, self.referenceView.frame.size.height)];

}

- (void)setBoundaries
{
    [self setBoundaries:[IOSTAnimator spaceOnRightForView:self.view andReferenceView:self.referenceView]];
}
@end
