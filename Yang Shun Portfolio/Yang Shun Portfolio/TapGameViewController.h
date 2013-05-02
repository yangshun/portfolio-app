//
//  TapGameViewController.h
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerItemViewController.h"

@interface TapGameViewController : UIViewController <tapGame, UIAlertViewDelegate> {
  
  NSMutableArray *beerArray;
  int numberOfBeersTapped;
  IBOutlet UILabel *scoreLabel;
  IBOutlet UIImageView *background;
  IBOutlet UILabel *timeLabel;
  NSTimer *gametimer;
  int timeLeft;
}

@end
