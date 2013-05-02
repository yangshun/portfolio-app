//
//  ShakeCanViewController.h
//  HipSpot
//
//  Created by Yang Shun Tay on 4/26/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeCanViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *timerLabel;
@property (nonatomic, weak) IBOutlet UIButton *shakeButton;
@property (nonatomic, weak) IBOutlet UILabel *shakeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sodaCanView;
@property (nonatomic, weak) IBOutlet UIScrollView *backgroundScrollView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int timerCount;
@property (nonatomic) int shakeCount;

- (IBAction)shake:(id)sender;

@end
