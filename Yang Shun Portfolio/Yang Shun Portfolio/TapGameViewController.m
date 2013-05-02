//
//  TapGameViewController.m
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "TapGameViewController.h"

@interface TapGameViewController ()

@end

@implementation TapGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  numberOfBeersTapped = 0;
  beerArray = [[NSMutableArray alloc] init];
  
  self.view.userInteractionEnabled = YES;
  background.userInteractionEnabled = YES;

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self displayBeer];
  
  timeLeft = 21;
  UIAlertView *instructions = [[UIAlertView alloc] initWithTitle:@"DrinkPal!"
                                                         message:@"Drink as many jugs of beer as possible by tapping them!"
                                                        delegate:self
                                               cancelButtonTitle:@"Got it!"
                                               otherButtonTitles:nil];
  [instructions show];
}

- (void)updateTime {
  timeLeft--;
  timeLabel.text = [NSString stringWithFormat:@"%d", timeLeft];
  if (timeLeft == 0) {
    NSString *msg = [NSString stringWithFormat:@"You gulped %d jugs of beer!", numberOfBeersTapped];
    UIAlertView *scoreAlert = [[UIAlertView alloc] initWithTitle:@"You got wasted!"
                                                         message:msg
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
    [scoreAlert show];
    [gametimer invalidate];
  }
}

- (void)displayBeer {
  for (int i = 0; i < 5; i++) {
    BeerItemViewController *beervc = [[BeerItemViewController alloc] init];
    beervc.delegate = self;
    [beerArray addObject:beervc];
    beervc.view.center = CGPointMake(144 + arc4random() % 280, 325);
    [background addSubview:beervc.view];
  }
}

- (void)increaseCount:(id)sender {
  numberOfBeersTapped++;
  [((UIViewController*)sender).view removeFromSuperview];
  scoreLabel.text = [NSString stringWithFormat:@"%d", numberOfBeersTapped];
  [beerArray removeObject:(BeerItemViewController*)sender];
  if (numberOfBeersTapped % 5 == 0) {
    [self displayBeer];
  }
}

- (IBAction)exit:(id)sender {
  [gametimer invalidate];
  [self dismissModalViewControllerAnimated:YES];
}

- (void)clearBeers {
  for (int i = 0; i < [beerArray count]; i++) {
    [((UIViewController*)[beerArray objectAtIndex:i]).view removeFromSuperview];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ([alertView.title isEqualToString:@"DrinkPal!"]) {
    
    gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateTime)
                                               userInfo:nil
                                                repeats:YES];
      [gametimer fire];
  } else {
    [self exit:nil];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
