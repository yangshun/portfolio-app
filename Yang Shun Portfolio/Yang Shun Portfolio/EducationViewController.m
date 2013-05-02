//
//  EducationViewController.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 4/27/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "EducationViewController.h"
#import "Constants.h"

@interface EducationViewController () {
  IBOutlet UIButton *nusLogo;
  IBOutlet UIButton *stanfordLogo;
  IBOutlet UITextView *schoolName;
  IBOutlet UITextView *nusDesc;
  IBOutlet UITextView *stanfordDesc;
  IBOutlet UIView *nusBox;
  IBOutlet UIView *stanfordBox;
  BOOL stanfordActive;
}

@end

@implementation EducationViewController

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
  stanfordActive = NO;
  stanfordLogo.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
  stanfordDesc.text = @"CS109: Introduction to Probability for Computer Scientists\nMS&E178: Spirit of Entrepreneurship\nMS&E271: Global Entrepreneurial Marketing\nMS&E472: Entrepreneurial Thought Leaders Seminar\n";
  stanfordBox.center = CGPointMake(kIphoneWidth*1.5, stanfordBox.center.y);
  
  nusDesc.text = @"Engineering Faculty Dean's List Award\n\nAwarded \"Letter of Commendation\" for excellent performance in CS3217 Software Engineering on Modern Application Platforms.";  
}

- (IBAction)toggleSchool:(id)sender {
  
  UIButton *activeButton;
  UIButton *otherButton;
  NSString *schoolNameString;
  if (stanfordActive) {
    activeButton = stanfordLogo;
    otherButton = nusLogo;
    schoolNameString = @"National University of Singapore";
  } else {
    activeButton = nusLogo;
    otherButton = stanfordLogo;
    schoolNameString = @"Stanford University";
  }
  
  [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    activeButton.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    otherButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    if (stanfordActive) {
      nusBox.center = CGPointMake(kIphoneWidth/2, nusBox.center.y);
      stanfordBox.center = CGPointMake(kIphoneWidth*1.5, stanfordBox.center.y);
    } else {
      nusBox.center = CGPointMake(-kIphoneWidth/2, nusBox.center.y);
      stanfordBox.center = CGPointMake(kIphoneWidth/2, stanfordBox.center.y);
    }
  } completion:^(BOOL finished) {
  }];
  
  stanfordActive = !stanfordActive;
  
  
}

- (IBAction)close:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


@end
