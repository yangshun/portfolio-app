//
//  ProfessionalViewController.h
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 5/2/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfessionalViewCell.h"

@interface ProfessionalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet ProfessionalViewCell *profViewCell;


@end
