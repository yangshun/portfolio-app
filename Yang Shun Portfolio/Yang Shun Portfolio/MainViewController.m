//
//  MainViewController.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 4/27/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "MainViewController.h"
#import "InterestsViewController.h"

@interface MainViewController () {
  IBOutlet UIButton *job;
  IBOutlet UIButton *education;
  IBOutlet UIButton *interests;
  IBOutlet UIButton *technical;
  NSArray *buttonsArray;
}

@end

@implementation MainViewController

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
  buttonsArray = [[NSArray alloc] initWithObjects:job, education, interests, technical, nil];
    // Do any additional setup after loading the view from its nib.
  float delay = 0.1f;
  
  for (int i = 0; i < [buttonsArray count]; i++) {
    UIButton *button = buttonsArray[i];
    button.center = CGPointMake(button.center.x,
                                button.center.y + 200);
    [UIView animateWithDuration:0.5f
                          delay:delay*i
                        options:nil
                     animations:^{
                       button.center = CGPointMake(button.center.x,
                                                   button.center.y - 250);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.25f
                       animations:^{
        button.center = CGPointMake(button.center.x,
                                    button.center.y + 75);
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f
                         animations:^{
                           button.center = CGPointMake(button.center.x,
                                                       button.center.y - 25);
                         } completion:^(BOOL finished) {
                           
                         }];
      }];
    }];
  }
}

- (IBAction)showInterestsPage:(id)sender {
  InterestsViewController *interestsViewController = [InterestsViewController new];
  [self presentModalViewController:interestsViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
