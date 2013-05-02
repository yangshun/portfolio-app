//
//  BeerItemViewController.m
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "BeerItemViewController.h"

@interface BeerItemViewController ()

@end

@implementation BeerItemViewController

- (id)init
{
    self = [super init];
    if (self) {
      UIImage *beerImage = [UIImage imageNamed:@"beer-small.png"];
      beerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
      beerImageView.image = beerImage;
      self.view = beerImageView;
      tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
      tapGesture.delegate = self;
      tapGesture.numberOfTapsRequired = 1;
      [self.view addGestureRecognizer:tapGesture];
      self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)tap {
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
                   }
                   completion:^(BOOL finished){
//                     [self.view removeFromSuperview];
                     [self.delegate increaseCount:self];
                   }];
}

- (void)viewDidAppear:(BOOL)animated {
//  NSLog(@"view did appear");
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
                   }
                   completion:^(BOOL finished){
                   }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
