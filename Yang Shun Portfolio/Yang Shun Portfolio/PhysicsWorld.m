//
//  PhysicsWorld.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 9/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsWorld.h"
#import "Constants.h"

@implementation PhysicsWorld
@synthesize gravity;
@synthesize timeStep;

- (id)initWithObjects:(NSMutableArray*)newObjects
             andWalls:(NSArray*)walls
           andGravity:(Vector2D*)g 
          andTimeStep:(double)dt {
  // MODIFIES: PhysicsWorld object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: an array of PhysicsRect objects (blocks and walls) are stored
  self = [super init];
  
  if (self != nil) {
    self.blockArray = newObjects;
    gravity = g;
    timeStep = dt;

    wallArray = walls;
    for (PhysicsShape *block in self.blockArray) {
      // give a timestep to all blocks in the area
      block.dt = timeStep;
    }
  }
  return self;
}

- (void)updateBlocksState {
  // MODIFIES: position of the blocks based on inter-block collisions
  // REQUIRES: timer to be started, timestep > 0
  // EFFECTS: the position of each PhysicsShape object is updated
  for (int i = 0; i < [self.blockArray count]; i++) {
    // iterate through each block and initialize its velocities (linear and angular)
    // based on external forces and torques acting on it
    // in this context, the only external force acting is gravity
    PhysicsShape *shapeA = [self.blockArray objectAtIndex:i];
    if (shapeA)
    if (!shapeA.beingDragged) {
      [shapeA updateVelocity:gravity withForce:[Vector2D vectorWith:0 y:0]];
      [shapeA updateAngularVelocity:0];
    }
    
    for (int j = i + 1; j < [self.blockArray count]; j++) {
      // test current shape for overlap with other shapes
      PhysicsShape *shapeB = [self.blockArray objectAtIndex:j];
      if ([shapeB isKindOfClass:[PhysicsCircle class]]) {
        if ([shapeB testOverlap:shapeA]) {
          // circle-rectangle interaction
          [self notifyViewForObjectCollisionsBetween:i andObject:j];
          for (int k = 0; k < 5; k++) {
            [shapeB applyImpulses];
          }
        }
      } else if ([shapeA testOverlap:shapeB]){
        // rectangle-rectangle interaction
        [self notifyViewForObjectCollisionsBetween:i andObject:j];
        for (int k = 0; k < 5; k++) {
          if (!shapeA.beingDragged) {
            [shapeA applyImpulses];
          }
        }
      }
    }
    
    for (int m = 0; m < [wallArray count]; m++) {
      // test current shape for overlap with walls
      PhysicsRect *wallRect = [wallArray objectAtIndex:m];
      if ([shapeA testOverlap:wallRect]) {
        // if overlapping, apply impulses to shape
        if (!shapeA.beingDragged) {
          [shapeA applyImpulses];
        }
        [self notifyViewForObjectCollisionsWithWall:i];
      }
      if (!shapeA.beingDragged) {
        [shapeA moveBodies];
      }
    }
  }
  [self checkRep];
  // notify the view to update the state of the rectangles in the view
  [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveBodies" object:self.blockArray];
}

- (void)notifyViewForObjectCollisionsBetween:(int)index1 andObject:(int)index2 {
  // REQUIRES: two objects to be overlapping with each other
  // EFFECTS: the view controller is notified of the collision of these two objects
  NSNumber *indexOne = [[NSNumber alloc] initWithInt:index1];
  NSNumber *indexTwo = [[NSNumber alloc] initWithInt:index2];
  
  NSArray *collisionIndices = [[NSArray alloc] initWithObjects:indexOne, indexTwo, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ObjectObjectCollision" object:collisionIndices];
}

- (void)notifyViewForObjectCollisionsWithWall:(int)index1 {
  // REQUIRES: an object to be overlapping with a wall
  // EFFECTS: the view controller is notified of the collision of the wall and the object
  NSNumber *index = [[NSNumber alloc] initWithInt:index1];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ObjectWallCollision" object:index];
}

- (BOOL)blockIsOutOfBounds:(int)index {
  PhysicsShape *shape = self.blockArray[index];
  if (shape.center.x < -50 ||
      shape.center.x > kIphoneWidth + 50 ||
      shape.center.y < -50 ||
      shape.center.y > kIphoneHeight + 50) {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ObjectOutOfBounds"
//                                                        object:[NSNumber numberWithInt:index]];
    return YES;
  } else {
    return NO;
  }
}

- (void)checkRep {
  NSMutableArray *violatedIndices = [NSMutableArray array];
  for (int i = 0; i < [self.blockArray count]; i++) {
    PhysicsShape *shapeA = self.blockArray[i];
    if (shapeA.center.x < -50 ||
        shapeA.center.x > kIphoneWidth + 50 ||
        shapeA.center.y < -50 ||
        shapeA.center.y > kIphoneHeight + 50 ||
        isnan(shapeA.w) ||
        isnan(shapeA.rotation) ||
        isnan(shapeA.prevRotation)) {
      NSNumber *index = [NSNumber numberWithInt:i];
      [violatedIndices addObject:index];
    }
  }
  if ([violatedIndices count] > 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ObjectOutOfBounds"
                                                        object:violatedIndices];
  }
}

@end
