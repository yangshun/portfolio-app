//
//  ShakeCanViewController.m
//  HipSpot
//
//  Created by Yang Shun Tay on 4/26/13.
//  Copyright (c) 2013 Yang Shun Tay. All rights reserved.
//

#import "ShakeCanViewController.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define TIME_TO_SHAKE               80
#define FLY_RATE                    200     // Flying rate in pixels per second
#define STRENGTH_TO_OFFSET_RATIO    50      // 10 pixels per strength

@interface ShakeCanViewController () {
    IBOutlet UIImageView *gameText;
    IBOutlet UIButton *endGame;
}
@property (nonatomic) CGAffineTransform leftWobble;
@property (nonatomic) CGAffineTransform rightWobble;

@property (nonatomic) BOOL isWobbling;
@property (nonatomic) BOOL isShakable;

@property (nonatomic, strong) NSTimer *backgroundScrollTimer;
@end

@implementation ShakeCanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.timerCount = TIME_TO_SHAKE;
        self.shakeCount = 0;
        
        self.leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-10.0));
        self.rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(10.0));
        
        self.isWobbling = NO;
        self.isShakable = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startTimer];
    
    float max = 1200 - self.backgroundScrollView.frame.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall.jpg"]];
    [self.backgroundScrollView setBackgroundColor:[UIColor blackColor]];
    [self.backgroundScrollView setContentSize:CGSizeMake(320, max)];
    [self.backgroundScrollView addSubview:imageView];
    [self.backgroundScrollView setContentOffset:CGPointMake(0, max)];
        
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        gameText.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Timer codes

- (void) startTimer
{
    self.timerLabel.text = [NSString stringWithFormat:@"%d.%d", self.timerCount/10, self.timerCount%10];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tickTimer) userInfo:nil repeats:YES];
}

- (void) tickTimer
{
    self.timerCount--;
    self.timerLabel.text = [NSString stringWithFormat:@"%d.%d", self.timerCount/10, self.timerCount%10];
    
    if (self.timerCount == 0) {
        [self.timer invalidate];
        self.isShakable = NO;
        self.sodaCanView.transform = CGAffineTransformMakeRotation(RADIANS(180));
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animateSodaCan) userInfo:nil repeats:NO];
    }
}

- (IBAction)endGame:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)shake:(id)sender
{
    if (!self.isShakable) return;
    
    self.shakeCount++;
//    self.shakeLabel.text = [NSString stringWithFormat:@"%i", self.shakeCount];
    if (self.shakeCount < 14) {
        self.shakeLabel.frame = CGRectMake(self.shakeLabel.frame.origin.x, self.shakeLabel.frame.origin.y,
                                       self.shakeLabel.frame.size.width + 20, self.shakeLabel.frame.size.height);
    }
    
    if (!self.isWobbling) {
        self.isWobbling = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.sodaCanView.transform = self.leftWobble;
            self.sodaCanView.transform = self.rightWobble;
        } completion:^(BOOL finished) {
            self.sodaCanView.transform = CGAffineTransformIdentity;
            self.isWobbling = NO;
        }];
    }
}


- (void) animateSodaCan
{
    self.shakeLabel.hidden = YES;
    self.timerLabel.hidden = YES;
    self.shakeButton.hidden = YES;
    gameText.hidden = YES;
    if (self.shakeCount > 0) {
        [self scrollBackground];
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.sodaCanView.transform = CGAffineTransformMakeTranslation(0, -200);
                         } completion:^(BOOL finished) {
                         }];
    }
    else {
        [self gameEnded];
    }
    
}

- (void) scrollBackground {
    float offset = [self calculateOffsetFromStrength:self.shakeCount];
    float duration = [self calculateDurationFromStrength:self.shakeCount];
    
    [UIView animateWithDuration:duration delay:0 options:0 animations:^{
        [self.backgroundScrollView setContentOffset:CGPointMake(0, offset)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.sodaCanView.transform = CGAffineTransformMakeTranslation(0, 1000);
                             } completion:^(BOOL finished) {
                            }];
        [self gameEnded];
    }];
}

- (float) calculateOffsetFromStrength:(int) strength {
    float offset = strength * STRENGTH_TO_OFFSET_RATIO;
    
    float max = 1200 - self.backgroundScrollView.frame.size.height;
    if (offset >= max) {
        return 0;
    }
    
    return max-offset;
}

- (float) calculateDurationFromStrength:(int) strength {
    float offset = strength * STRENGTH_TO_OFFSET_RATIO;
    
    return offset / FLY_RATE;
}

#pragma mark - YangShun's Callback
- (void) gameEnded
{
    self.backgroundScrollView.alpha = 0.5f;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         endGame.center = CGPointMake(120, 240);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              
                                              endGame.center = CGPointMake(160, 240);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

@end