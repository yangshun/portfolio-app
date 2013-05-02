//
//  TechnicalViewController.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 5/2/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "TechnicalViewController.h"
#import "TapGameViewController.h"
#import "ShakeCanViewController.h"

@interface TechnicalViewController ()

@end

@implementation TechnicalViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)launchDrinkPal:(id)sender {
  TapGameViewController *tapGame = [TapGameViewController new];
  [self presentModalViewController:tapGame animated:YES];
}


- (IBAction)launchHipSpot:(id)sender {
  ShakeCanViewController *shakeGame = [ShakeCanViewController new];
  [self presentModalViewController:shakeGame animated:YES];
}

- (IBAction)exit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
