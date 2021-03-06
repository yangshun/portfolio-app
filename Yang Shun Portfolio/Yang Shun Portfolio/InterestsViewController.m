//
//  ViewController.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 4/26/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "InterestsViewController.h"
#import "Vector2D.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "InterestBlock.h"

@interface InterestsViewController () {
  
  NSTimer *timer;
  double timeStep;
  NSMutableArray *viewRectArray;
  NSMutableArray *blockRectArray;
  NSArray *wallRectArray;
  PhysicsWorld *world;
  IBOutlet UITextView *drawingBox;
  IBOutlet UITextView *programmingBox;
  IBOutlet UITextView *interfaceDesignBox;
  IBOutlet UITextView *graphicDesignBox;
  IBOutlet UITextView *entrepreneurshipBox;
  IBOutlet UITextView *calligraphyBox;
  IBOutlet UITextView *animationBox;
}

@end

@implementation InterestsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
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
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

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
  for (int i = 0; i < 7; i++) {
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
  UITextView *textView;
  InterestBlock *viewRect;
  PhysicsShape *blockRect;
  switch (index) {
    case 0:
      textView = drawingBox;
      break;
    case 1:
      textView = programmingBox;
      break;
    case 2:
      textView = interfaceDesignBox;
      break;
    case 3:
      textView = graphicDesignBox;
      break;
    case 4:
      textView = entrepreneurshipBox;
      break;
    case 5:
      textView = calligraphyBox;
      break;
    case 6:
      textView = animationBox;
      break;
    default:
      break;
  }
  blockRect.dt = timeStep;
  viewRect = [[InterestBlock alloc] initWithFrame:CGRectMake(textView.frame.origin.x+8,
                                                          textView.frame.origin.y+8,
                                                          textView.frame.size.width-16,
                                                          textView.frame.size.height-16)];

  viewRect.text = textView.text;
  viewRect.font = textView.font;
  viewRect.backgroundColor = textView.backgroundColor;
  viewRect.textColor = textView.textColor;
  viewRect.textAlignment = textView.textAlignment;
  viewRect.editable = textView.editable;
  viewRect.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
  
  [self.view addSubview:viewRect];
  
  blockRect = [[PhysicsRect alloc] initWithOrigin:CGPointMake(textView.frame.origin.x+8, textView.frame.origin.y+8)
                                           andWidth:textView.frame.size.width-16
                                          andHeight:textView.frame.size.height-16
                                            andMass:1
                                        andRotation:0
                                        andFriction:kBlockFriction
                                     andRestitution:kBlockRestitution
                                            andView:viewRect];
  
  [viewRectArray insertObject:viewRect atIndex:index];
  [blockRectArray insertObject:blockRect atIndex:index];
  
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
  InterestBlock *block = arr[0];
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


- (IBAction)back:(id)sender {
  [viewRectArray removeAllObjects];
  viewRectArray = nil;
  [blockRectArray removeAllObjects];
  blockRectArray = nil;
  wallRectArray = nil;
  world = nil;
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
