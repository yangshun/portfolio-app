//
//  ProfessionalViewCell.h
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 5/2/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionalViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextView *organization;
@property (nonatomic, strong) IBOutlet UITextView *position;
@property (nonatomic, strong) IBOutlet UITextView *duration;
@property (nonatomic, strong) IBOutlet UITextView *desc;
@property (nonatomic, strong) IBOutlet UIImageView *logo;

@end
