//
//  ViewController.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 4/26/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "ViewController.h"
#import "Vector2D.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageBlock.h"

@interface ViewController () {
  
  NSTimer *timer;
  double timeStep;
  NSMutableArray *viewRectArray;
  NSMutableArray *blockRectArray;
  NSArray *wallRectArray;
  PhysicsWorld *world;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self initializeObjects];
  
  timeStep = 1.0f/200.0f;
  
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  
  // initialize PhysicsWorld object with the arrays of PhysicRect as paramaters
  world = [[PhysicsWorld alloc] initWithObjects:blockRectArray
                                       andWalls:wallRectArray
                                     andGravity:[self selectGravity:orientation]
                                    andTimeStep:timeStep];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateViewObjectPositions:)
                                               name:@"MoveBodies"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updatePhysicsModel:)
                                               name:@"UpdatePhysicsModel"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(removeBlock:)
                                               name:@"ObjectOutOfBounds"
                                             object:nil];
  
  // add observer to update gravity direction when device orientation changes
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(rotateView:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  
  UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = timeStep;
  
  [self initializeTimer];
}

- (IBAction)resetState:(id)sender {
  for (UIView *view in viewRectArray) {
    [view removeFromSuperview];
  }
  [self initializeObjects];
  world = [[PhysicsWorld alloc] initWithObjects:blockRectArray
                                       andWalls:wallRectArray
                                     andGravity:[self selectGravity:[[UIDevice currentDevice] orientation]]
                                    andTimeStep:timeStep];
  [timer invalidate];
  [self initializeTimer];
}

- (void)initializeObjects {
  PhysicsRect *wallRectLeft = [[PhysicsRect alloc] initWithOrigin:CGPointMake(-kWallWidth, 0)
                                                         andWidth:kWallWidth
                                                        andHeight:kIphoneHeight
                                                          andMass:INFINITY
                                                      andRotation:0
                                                      andFriction:kWallFriction
                                                   andRestitution:kWallRestitution
                                                          andView:nil];
  
  PhysicsRect *wallRectTop = [[PhysicsRect alloc] initWithOrigin:CGPointMake(0, -kWallWidth)
                                                        andWidth:kIphoneWidth
                                                       andHeight:kWallWidth
                                                         andMass:INFINITY
                                                     andRotation:0
                                                     andFriction:kWallFriction
                                                  andRestitution:kWallRestitution
                                                         andView:nil];
  
  PhysicsRect *wallRectRight = [[PhysicsRect alloc] initWithOrigin:CGPointMake(kIphoneWidth, 0)
                                                          andWidth:100
                                                         andHeight:kIphoneHeight
                                                           andMass:INFINITY
                                                       andRotation:0
                                                       andFriction:kWallFriction
                                                    andRestitution:kWallRestitution
                                                           andView:nil];
  
  PhysicsRect *wallRectBottom = [[PhysicsRect alloc] initWithOrigin:
                                 CGPointMake(0, kIphoneHeight - kStatusBarThickness)
                                                           andWidth:kIphoneWidth
                                                          andHeight:100
                                                            andMass:INFINITY
                                                        andRotation:0
                                                        andFriction:kWallFriction
                                                     andRestitution:kWallRestitution
                                                            andView:nil];
  
  wallRectArray = [[NSArray alloc] initWithObjects: wallRectLeft,
                   wallRectTop, wallRectRight, wallRectBottom, nil];
  
  // initialize the blocks (PhysicRect objects) in the view and in the PhysicsWorld
  // initialize red block
  ImageBlock *viewRect1 = [[ImageBlock alloc] initWithFrame:CGRectMake(100, 300, 50, 30)];
  viewRect1.backgroundColor = [UIColor redColor];
  [self.view addSubview:viewRect1];
  PhysicsRect *blockRect1 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(100, 300)
                                                       andWidth:50
                                                      andHeight:30
                                                        andMass:1
                                                    andRotation:0
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                        andView:viewRect1];
  
  // initialize maroon block
  ImageBlock *viewRect2 = [[ImageBlock alloc] initWithFrame:CGRectMake(50, 50, 25, 75)];
  viewRect2.backgroundColor = [UIColor colorWithRed:134.0 / 225.0
                                              green:13.0 / 225.0
                                               blue:64.0 / 225.0
                                              alpha:1.0];
  viewRect2.transform = CGAffineTransformRotate(viewRect2.transform, 0.755);
  [self.view addSubview:viewRect2];
  PhysicsRect *blockRect2 = [[PhysicsRect alloc] initWithOrigin:CGPointMake(50, 50)
                                                       andWidth:25
                                                      andHeight:75
                                                        andMass:1
                                                    andRotation:0.755
                                                    andFriction:kBlockFriction
                                                 andRestitution:kBlockRestitution
                                                        andView:viewRect2];
  
  // initialize brown block
  ImageBlock *viewRect3 = [[ImageBlock alloc] initWithFrame:CGRectMake(200, 100, 80, 80)];
  viewRect3.backgroundColor = [UIColor brownColor];
  viewRect3.transform = CGAffineTransformRotate(viewRect3.transform, 1.91);
  [viewRect3.layer setCornerRadius:40.0f];
  [self.view addSubview:viewRect3];
  PhysicsCircle *blockRect3 = [[PhysicsCircle alloc] initWithOrigin:CGPointMake(200, 100)
                                                           andWidth:80
                                                          andHeight:80
                                                            andMass:1
                                                        andRotation:1.91
                                                        andFriction:kBlockFriction
                                                     andRestitution:kBlockRestitution
                                                            andView:viewRect3];
  
  // initialize yellow block
  ImageBlock *viewRect4 = [[ImageBlock alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
  viewRect4.backgroundColor = [UIColor yellowColor];
  viewRect4.transform = CGAffineTransformRotate(viewRect4.transform, 2.71);
  [viewRect4.layer setCornerRadius:40.0f];
  [self.view addSubview:viewRect4];
  PhysicsCircle *blockRect4 = [[PhysicsCircle alloc] initWithOrigin:CGPointMake(0, 0)
                                                           andWidth:80
                                                          andHeight:80
                                                            andMass:1
                                                        andRotation:2.71
                                                        andFriction:kBlockFriction
                                                     andRestitution:kBlockRestitution
                                                            andView:viewRect4];
  
  // initialize the array of block views, PhysicRect blocks and PhysicRect walls
  viewRectArray = [[NSMutableArray alloc] initWithObjects:viewRect1, viewRect2, viewRect3, viewRect4, nil];
  blockRectArray = [[NSMutableArray alloc] initWithObjects:blockRect1, blockRect2, blockRect3, blockRect4, nil];
}


- (void)initializeTimer {
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld
  timer = [NSTimer scheduledTimerWithTimeInterval:timeStep
                                           target:self
                                         selector:@selector(updateWorldTime)
                                         userInfo:nil
                                          repeats:YES];
}

- (void)updateWorldTime {
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld
  [world updateBlocksState];
}

- (void)updateViewObjectPositions:(NSNotification*)notification {
  // MODIFIES: position of view objects
  // REQUIRES: the PhysicsWorld to be initialized
  // EFFECTS: changes the position of the object views according to its
  //          position in the physics world
  NSArray *physicsWorldBlocks = [notification object];
  for (int i = 0; i < [physicsWorldBlocks count]; i++) {
    PhysicsShape *thisBlock = [physicsWorldBlocks objectAtIndex:i];
    UIView *thisObject = [viewRectArray objectAtIndex:i];
    thisObject.center = CGPointMake(thisBlock.center.x, thisBlock.center.y);
    thisObject.transform = CGAffineTransformMakeRotation(thisBlock.rotation);
  }
}

- (void)updatePhysicsModel:(NSNotification*)notification {
  NSArray *arr = [notification object];
  ImageBlock *block = arr[0];
  NSNumber *num = arr[1];
  BOOL dragged = [num boolValue];
  NSValue *value = arr[2];
  CGPoint velocity = [value CGPointValue];
  for (int i = 0; i < [viewRectArray count]; i++) {
    if (block == viewRectArray[i]) {
      PhysicsShape *shape = world.blockArray[i];
      shape.center = [Vector2D vectorWith:block.center.x y:block.center.y];
      shape.beingDragged = dragged;
      shape.v = [Vector2D vectorWith:velocity.x y:velocity.y];
    }
  }
}

- (void)removeBlock:(NSNotification*)notification {
  NSArray *indices = [notification object];
  
  NSMutableArray *removingView = [NSMutableArray array];
  NSMutableArray *removingPhy = [NSMutableArray array];
  for (NSNumber *num in indices) {
    ImageBlock *block = viewRectArray[[num intValue]];
    [removingView addObject:block];
    [block removeFromSuperview];
    PhysicsShape *phyObj = world.blockArray[[num intValue]];
    [removingPhy addObject:phyObj];
  }
  
  [viewRectArray removeObjectsInArray:removingView];
  [world.blockArray removeObjectsInArray:removingPhy];
  
}

- (void)rotateView:(NSNotification*)notification {
  // MODIFIES: gravity vector of PhysicsWorld object
  // REQUIRES: device orientation to be changed
  // EFFECTS: changes the gravity vector according to the orientation of the device
  //    if (world.accelerometerActivated) {
  //        return;
  //    }
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  world.gravity = [self selectGravity:orientation];
}

- (Vector2D*)selectGravity:(UIDeviceOrientation)orientation {
  // EFFECTS: returns a new gravity vector according to the orientation of the device
  Vector2D *gravity;
  
  if (orientation == UIDeviceOrientationPortraitUpsideDown) {
    gravity = [Vector2D vectorWith:0 y:-kGravityMagnitude];
  } else if (orientation == UIDeviceOrientationLandscapeLeft) {
    gravity = [Vector2D vectorWith:-kGravityMagnitude y:0];
  } else if (orientation == UIDeviceOrientationLandscapeRight) {
    gravity = [Vector2D vectorWith:kGravityMagnitude y:0];
  } else {
    gravity = [Vector2D vectorWith:0 y:kGravityMagnitude];
  }
  NSLog(@"x: %f, y: %f", gravity.x, gravity.y);
  return gravity;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration {
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity according to accelerometer's direction and magnitude
  //    if (world.accelerometerActivated) {
  //        world.gravity = [Vector2D vectorWith:acceleration.x * kGravityMultiplier
  //                                           y:-acceleration.y * kGravityMultiplier];
  //    }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
