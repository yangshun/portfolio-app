//
//  ProfessionalViewController.m
//  Yang Shun Portfolio
//
//  Created by Yang Shun Tay on 5/2/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "ProfessionalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfessionalViewController () {
  NSArray *jobs;
}

@end

@implementation ProfessionalViewController

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
  
  NSMutableDictionary *job1 = [[NSMutableDictionary alloc] init];
  [job1 setObject:@"EasilyDo Inc" forKey:@"organization"];
  [job1 setObject:@"Software Engineering Intern" forKey:@"position"];
  [job1 setObject:@"Aug 2012 - May 2013" forKey:@"duration"];
  [job1 setObject:@"Front-end developer in the core team for the iOS mobile app. In-charge of making the user interface functional and pretty. Also developed the corporate website and in-house web tools to aid the product and engineering team in their daily workflow." forKey:@"desc"];
  [job1 setObject:@"easilydo-icon" forKey:@"imagePath"];
  
  NSMutableDictionary *job2 = [[NSMutableDictionary alloc] init];
  [job2 setObject:@"Computing for Voluntary Welfare Organizations" forKey:@"organization"];
  [job2 setObject:@"Software Developer" forKey:@"position"];
  [job2 setObject:@"May 2012 - Jul 2012" forKey:@"duration"];
  [job2 setObject:@"Worked in a team of 5 to build a web-based content management system in Drupal 7 for Feiyue Family Services Centre.\n\nDeveloped a staff permissions system for the administrators to assign roles and permissions to the various users involved in the system." forKey:@"desc"];
  [job2 setObject:@"feiyue-logo" forKey:@"imagePath"];
  
  NSMutableDictionary *job3 = [[NSMutableDictionary alloc] init];
  [job3 setObject:@"National University of Singapore" forKey:@"organization"];
  [job3 setObject:@"Teaching Assistant" forKey:@"position"];
  [job3 setObject:@"Aug 2011 - Nov 2011" forKey:@"duration"];
  [job3 setObject:@"Teaching assistant for CS1020E Data Structures and Algorithm I.Conducted weekly lab classes for a class of 40. Maintained a teaching resource website." forKey:@"desc"];
  [job3 setObject:@"nus-logo-sq" forKey:@"imagePath"];
  
  jobs = [[NSArray alloc] initWithObjects:job1, job2, job3, nil];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return jobs.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *text = jobs[indexPath.row][@"desc"];
  [[NSBundle mainBundle] loadNibNamed:@"ProfessionalViewCell" owner:self options:nil];
  CGSize textViewSize = [text sizeWithFont:self.profViewCell.desc.font
                         constrainedToSize:CGSizeMake(280, FLT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
  return 156.0f + textViewSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ProfessionalViewCell *cell = nil;
  static NSString *CellIdentifier = @"ProfCell";
  cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"ProfessionalViewCell" owner:self options:nil];
    cell = self.profViewCell;
//    cell.frame = CGRectMake(0, 0, 280, 224);
  }
  
  NSDictionary *job = jobs[indexPath.row];
  
  cell.organization.text = job[@"organization"];
  cell.position.text = job[@"position"];
  cell.duration.text = job[@"duration"];
  cell.desc.text = job[@"desc"];
  cell.logo.image = [UIImage imageNamed:job[@"imagePath"]];
  cell.logo.layer.cornerRadius = 5.0f;
  
  CGSize textViewSize = [cell.desc.text sizeWithFont:cell.desc.font
                         constrainedToSize:CGSizeMake(280, FLT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
  cell.desc.frame = CGRectMake(cell.desc.frame.origin.x,
                               cell.desc.frame.origin.y,
                               textViewSize.width,
                               textViewSize.height + 30);
  
  return cell;
}

- (IBAction)exit:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
