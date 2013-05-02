//
//  BeerItemViewController.h
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapGame <NSObject>

- (void)increaseCount:(id)sender;

@end

@interface BeerItemViewController : UIViewController <UIGestureRecognizerDelegate> {
  
  UIImageView *beerImageView;
  UITapGestureRecognizer *tapGesture;

}

@property (nonatomic, retain) id<tapGame> delegate;

@end
