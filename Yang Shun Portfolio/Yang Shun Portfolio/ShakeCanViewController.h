//
//  ShakeCanViewController.h
//  HipSpot
//
//  Created by soedar on 5/1/13.
//  Copyright (c) 2013 noc. All rights reserved.
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
