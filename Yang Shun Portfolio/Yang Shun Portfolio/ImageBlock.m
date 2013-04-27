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
  
  if (newCenter.x < 185 && newCenter.x > 135 && newCenter.y > 45 && newCenter.y < 95) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GlowIconHoverTest"
                                                        object:[NSNumber numberWithBool:YES]];
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GlowIconHoverTest"
                                                        object:[NSNumber numberWithBool:NO]];
  }
  
  if (gesture.state == UIGestureRecognizerStateEnded) {
    NSLog(NSStringFromCGPoint([gesture locationInView:[self superview]]));
    beingDragged = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GlowIconHoverTest"
                                                        object:[NSNumber numberWithBool:NO]];
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
