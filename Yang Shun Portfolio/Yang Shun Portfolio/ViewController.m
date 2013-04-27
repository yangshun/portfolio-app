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
  IBOutlet UIImageView *nameLogo;
  IBOutlet UIImageView *viewIcon;
  IBOutlet UITextView *instructions;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  nameLogo.center = CGPointMake(kIphoneWidth/2,
                                ([[UIScreen mainScreen] bounds].size.height-kStatusBarThickness)/2);
  instructions.center = CGPointMake(instructions.center.x,
                                    nameLogo.center.y + nameLogo.frame.size.height/2 + instructions.frame.size.height/2 - 10);
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
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(glowIcon:)
                                               name:@"GlowIconHoverTest"
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
  
  [self resetState:nil];
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
  [self performSelector:@selector(initializeTimer) withObject:nil afterDelay:0.0f];
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
                                 CGPointMake(0, [[UIScreen mainScreen] bounds].size.height-kStatusBarThickness)
                                                           andWidth:kIphoneWidth
                                                          andHeight:100
                                                            andMass:INFINITY
                                                        andRotation:0
                                                        andFriction:kWallFriction
                                                     andRestitution:kWallRestitution
                                                            andView:nil];
  
  wallRectArray = [[NSArray alloc] initWithObjects: wallRectLeft,
                   wallRectTop, wallRectRight, wallRectBottom, nil];
  viewRectArray = [[NSMutableArray alloc] init];
  blockRectArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < 4; i++) {
    [self createBlock:i];
  }
  // initialize the array of block views, PhysicRect blocks and PhysicRect walls
  for (int i = 0; i < [viewRectArray count]; i++) {
    UIView *view = viewRectArray[i];
    view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.5f
                     animations:^{
                       view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                     } completion:^(BOOL finished) {}];
  }
}

- (void)createBlock:(int)index {
  ImageBlock *viewRect;
  PhysicsShape *blockRect;
  switch (index) {
    case 0: {
      viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(200, 100, kBlockDiameter, kBlockDiameter)];
      viewRect.backgroundColor = kPinkColor;
      viewRect.image = [UIImage imageNamed:@"job-icon"];
      viewRect.transform = CGAffineTransformRotate(viewRect.transform, 1.91);
      [viewRect.layer setCornerRadius:kBlockRadius];
      [self.view addSubview:viewRect];
      blockRect = [[PhysicsCircle alloc] initWithOrigin:CGPointMake(200, 100)
                                               andWidth:kBlockDiameter
                                              andHeight:kBlockDiameter
                                                andMass:1
                                            andRotation:1.91
                                            andFriction:kBlockFriction
                                         andRestitution:kBlockRestitution
                                                andView:viewRect];
      
    }
      break;
    case 1: {
      viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(0, 0, kBlockDiameter, kBlockDiameter)];
      viewRect.backgroundColor = kYellowColor;
      viewRect.transform = CGAffineTransformRotate(viewRect.transform, 2.71);
      viewRect.image = [UIImage imageNamed:@"education-icon"];
      [viewRect.layer setCornerRadius:kBlockRadius];
      [self.view addSubview:viewRect];
      blockRect = [[PhysicsCircle alloc] initWithOrigin:CGPointMake(0, 0)
                                                               andWidth:kBlockDiameter
                                                              andHeight:kBlockDiameter
                                                                andMass:1
                                                            andRotation:2.71
                                                            andFriction:kBlockFriction
                                                         andRestitution:kBlockRestitution
                                                                andView:viewRect];
      }
      break;
    case 2: {
      viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(240, 0, kBlockDiameter, kBlockDiameter)];
      viewRect.backgroundColor = kTurqoiseColor;
      viewRect.transform = CGAffineTransformRotate(viewRect.transform, 2.71);
      viewRect.image = [UIImage imageNamed:@"interests-icon"];
      [viewRect.layer setCornerRadius:kBlockRadius];
      [self.view addSubview:viewRect];
      blockRect = [[PhysicsCircle alloc] initWithOrigin:CGPointMake(240, 0)
                                               andWidth:kBlockDiameter
                                              andHeight:kBlockDiameter
                                                andMass:1
                                            andRotation:2.71
                                            andFriction:kBlockFriction
                                         andRestitution:kBlockRestitution
                                                andView:viewRect];
    }
      break;
    case 3: {
      viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(160, 70, kBlockDiameter, kBlockDiameter)];
      viewRect.transform = CGAffineTransformRotate(viewRect.transform, 2.71);
      viewRect.image = [UIImage imageNamed:@"coding-icon"];
      [viewRect.layer setCornerRadius:kBlockRadius];
      [self.view addSubview:viewRect];
      blockRect = [[PhysicsCircle alloc] initWithOrigin:CGPointMake(160, 70)
                                               andWidth:kBlockDiameter
                                              andHeight:kBlockDiameter
                                                andMass:1
                                            andRotation:2.71
                                            andFriction:kBlockFriction
                                         andRestitution:kBlockRestitution
                                                andView:viewRect];
    }
      break;
    default:
      break;
  }
  blockRect.dt = timeStep;
 
  [viewRectArray insertObject:viewRect atIndex:index];
  [blockRectArray insertObject:blockRect atIndex:index];
  
}
//case 0: {
//  viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(100, 300, kBlockWidth, kBlockHeight)];
//  viewRect.backgroundColor = kPinkColor;
//  viewRect.image = [UIImage imageNamed:@"job-label"];
//  [self.view addSubview:viewRect];
//  blockRect = [[PhysicsRect alloc] initWithOrigin:CGPointMake(100, 300)
//                                         andWidth:kBlockWidth
//                                        andHeight:kBlockHeight
//                                          andMass:1
//                                      andRotation:0
//                                      andFriction:kBlockFriction
//                                   andRestitution:kBlockRestitution
//                                          andView:viewRect];
//  
//}
//break;
//
//case 2: {
//  viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(80, 50, kBlockWidth, kBlockHeight)];
//  viewRect.backgroundColor = kYellowColor;
//  viewRect.transform = CGAffineTransformRotate(viewRect.transform, 0.755);
//  viewRect.image = [UIImage imageNamed:@"education-label"];
//  [self.view addSubview:viewRect];
//  blockRect = [[PhysicsRect alloc] initWithOrigin:CGPointMake(50, 50)
//                                         andWidth:kBlockWidth
//                                        andHeight:kBlockHeight
//                                          andMass:1
//                                      andRotation:0.755
//                                      andFriction:kBlockFriction
//                                   andRestitution:kBlockRestitution
//                                          andView:viewRect];
//}
//break;
//
//case 4: {
//  viewRect = [[ImageBlock alloc] initWithFrame:CGRectMake(200, 50, kBlockWidth, kBlockHeight)];
//  viewRect.backgroundColor = kTurqoiseColor;
//  viewRect.transform = CGAffineTransformRotate(viewRect.transform, 0.755);
//  [self.view addSubview:viewRect];
//  blockRect = [[PhysicsRect alloc] initWithOrigin:CGPointMake(200, 50)
//                                         andWidth:kBlockWidth
//                                        andHeight:kBlockHeight
//                                          andMass:1
//                                      andRotation:0.755
//                                      andFriction:kBlockFriction
//                                   andRestitution:kBlockRestitution
//                                          andView:viewRect];
//}
//break;

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

  [timer invalidate];
  for (int i = 0; i < [viewRectArray count]; i++) {
    UIView *view = viewRectArray[i];
    [UIView animateWithDuration:0.5f
                     animations:^{
                       view.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                       if (finished) {
                         [view removeFromSuperview];
                         if (i == [viewRectArray count]-1) {
                           [self resetState:nil];
                         }
                       }
                     }];
  }
}

- (void)glowIcon:(NSNotification*)notification {
  NSNumber *value = [notification object];
  NSLog(@"glow: %d", [value boolValue]);
  viewIcon.highlighted = [value boolValue];
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
  return gravity;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration {
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity according to accelerometer's direction and magnitude
  world.gravity = [Vector2D vectorWith:acceleration.x * kGravityMultiplier
                                     y:-acceleration.y * kGravityMultiplier];
//  NSLog(@"x: %f, y: %f, z:%f", acceleration.x, acceleration.y, acceleration.z);  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
