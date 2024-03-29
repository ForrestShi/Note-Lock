//
//  SettingViewController.m
//  MySecNote
//
//  Created by forrest on 13-5-24.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "SettingViewController.h"
#import "QBFlatButton.h"
#import "SchemeViewController.h"
#import "Appirater.h"
#import "Flurry.h"
#import "iTellAFriend.h"

@interface SettingViewController ()<MFMailComposeViewControllerDelegate>{
    QBFlatButton *recommendBtn;
    QBFlatButton *giftBtn;
    QBFlatButton *rateBtn;
    QBFlatButton *emailBtn;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (QBFlatButton*)newFlatButtonWithTitle:(NSString*)title andFrame:(CGRect)frame{
    QBFlatButton *btn2 = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = frame;
    btn2.faceColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0 alpha:1.0];
    btn2.sideColor = [UIColor colorWithRed:170.0/255.0 green:105.0/255.0 blue:0 alpha:1.0];
    btn2.radius = 2.0;
    btn2.margin = 4.0;
    btn2.depth = 6.0;
    btn2.alpha = 0.;
    
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:title forState:UIControlStateNormal];
    return btn2;
}

- (void)viewWillAppear:(BOOL)animated{
    DLog(@"1");
    [super viewWillAppear:animated];
    [UIView animateWithDuration:.5 animations:^{
        recommendBtn.alpha = 1.;
        emailBtn.alpha = 1.;
        rateBtn.alpha = 1.;
        giftBtn.alpha = 1.;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
        DLog(@"2");
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:.1 animations:^{
        recommendBtn.alpha = 0.;
        emailBtn.alpha = 0.;
        rateBtn.alpha = 0.;
        giftBtn.alpha = 0.;
    }];

}

- (void)viewDidLoad
{
        DLog(@"d");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
    [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    float offsetX = 60.;
    float gap = 18.;

    float bH = 60.;
    recommendBtn = [self newFlatButtonWithTitle:@"RECOMMEND" andFrame:CGRectMake(offsetX, h*.2, w - offsetX*2, bH)];
    giftBtn = [self newFlatButtonWithTitle:@"GIFT" andFrame:CGRectMake(offsetX, h*.2 + bH + gap, w - offsetX*2, bH)];
    rateBtn = [self newFlatButtonWithTitle:@"RATE" andFrame:CGRectMake(offsetX, h*.2 + (bH + gap)*2, w - offsetX*2, bH)];
    emailBtn = [self newFlatButtonWithTitle:@"FEEDBACK" andFrame:CGRectMake(offsetX, h*.2 + (bH +gap)*3, w - offsetX*2, bH)];
    
    //TODO: can not change tintcolor dynamically from the app right now 
    [self.view addSubview:recommendBtn];
    [self.view addSubview:rateBtn];
    [self.view addSubview:giftBtn];
    [self.view addSubview:emailBtn];
    
    [emailBtn addTarget:self action:@selector(emailToUs) forControlEvents:UIControlEventTouchUpInside];
    [giftBtn addTarget:self action:@selector(gift) forControlEvents:UIControlEventTouchUpInside];
    [rateBtn addTarget:self action:@selector(rateUs) forControlEvents:UIControlEventTouchUpInside];
    [recommendBtn addTarget:self action:@selector(recommend) forControlEvents:UIControlEventTouchUpInside];

    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, h - 44., w, 44.)];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.text = @"@2013 DESIGN4APPLE ";
    copyrightLabel.textAlignment = UITextAlignmentCenter;
    copyrightLabel.textColor = [UIColor whiteColor];
    copyrightLabel.font = [UIFont fontWithName:@"TeluguSangamMN" size:14];
    [self.view addSubview:copyrightLabel];
    
    UITapGestureRecognizer *tapSetting = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        //
        [self tapMe];
    }];
    [self.view addGestureRecognizer:tapSetting];

    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        //
        [self tapMe];
    }];
    swip.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight |UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swip2 = [[UISwipeGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        //
        [self tapMe];
    }];
    swip2.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:swip];
    [self.view addGestureRecognizer:swip2];
    
}


- (void)tapMe{
    
    [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self viewWillDisappear:YES];
        self.view.frame = CGRectMake(0, 0, 320., 44.);
        //self.view.alpha = 0.;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}

- (void)gift{
     [[iTellAFriend sharedInstance] giftThisAppWithAlertView:YES];    
}

- (void)recommend{
    if ([[iTellAFriend sharedInstance] canTellAFriend]) {
        UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
        [self presentModalViewController:tellAFriendController animated:YES];
    }
}

- (void)emailToUs{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mvc = [[MFMailComposeViewController alloc] init];
        //[mvc setSubject:[NSString stringWithFormat:@"@%@%",@"Passwords Pro",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey ]] ];
        CFStringRef ver = CFBundleGetValueForInfoDictionaryKey(
                                                               CFBundleGetMainBundle(),
                                                               kCFBundleVersionKey);
        NSString *appVersion = (__bridge NSString *)ver;

        [mvc setSubject:[NSString stringWithFormat:@"Passwords Pro %@", appVersion]];
        [mvc setToRecipients:@[@"design4app@gmail.com"]];
        [mvc setMessageBody:@" " isHTML:NO];
        mvc.mailComposeDelegate = self;
        [self presentViewController:mvc animated:YES completion:^{
            
        }];
    }
    [Flurry logEvent:@"click email button"];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rateUs{
    [[iTellAFriend sharedInstance] rateThisAppWithAlertView:YES];
    //[Appirater rateApp];
    [Flurry logEvent:@"click rate button"];
}

- (void)moreSchemes{
    SchemeViewController *svc = [[SchemeViewController alloc] init];
    svc.view.frame = self.view.frame;//CGRectInset(self.view.frame, 10., 16.);
    svc.view.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:svc.view];
    //[self presentModalViewController:svc animated:YES];
    [self presentViewController:svc animated:YES completion:^{
        //
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
