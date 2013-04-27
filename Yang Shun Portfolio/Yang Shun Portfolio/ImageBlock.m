//
//  ImageBlock.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 4/26/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "ImageBlock.h"
#import "Constants.h"

@implementation ImageBlock {
  BOOL beingDragged;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(blockDragged:)];
    [self addGestureRecognizer:panGesture];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(tapped:)];
//    [self addGestureRecognizer:tapGesture];
    
    beingDragged = NO;
  }
  return self;
}

- (void)blockDragged:(id)sender {
  UIPanGestureRecognizer *gesture = sender;
  if (gesture.state == UIGestureRecognizerStateBegan) {
    beingDragged = YES;
  }
  
  CGPoint newCenter = [gesture locationInView:[self superview]];
  
  if (gesture.state == UIGestureRecognizerStateEnded) {
    beingDragged = NO;
  }

  self.center = CGPointMake(newCenter.x,
                            newCenter.y);
  NSNumber *num = [NSNumber numberWithBool:beingDragged];
  CGPoint gestureVelocity = [gesture velocityInView:[self superview]];
  
  NSValue *velocity = [NSValue valueWithCGPoint:CGPointMake(gestureVelocity.x * kDampingFactor,
                                                            gestureVelocity.y * kDampingFactor)];

  NSArray *arr = [NSArray arrayWithObjects:self, num, velocity, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePhysicsModel" object:arr];
}


@end
