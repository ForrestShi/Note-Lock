//
//  SchemeViewController.m
//  MySecNote
//
//  Created by forrest on 13-5-25.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "SchemeViewController.h"
#import "QBFlatButton.h"

@interface SchemeViewController (){
    NSArray *schemeBtnArray;
    NSArray *schemeColorArray;
}

@end

@implementation SchemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (QBFlatButton*)newFlatButtonWithFrame:(CGRect)frame{
    QBFlatButton *btn2 = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = frame;
    btn2.faceColor = [UIColor grapeColor];
    btn2.sideColor = [UIColor lightCreamColor];
    btn2.radius = .0;
    btn2.margin = 2.0;
    btn2.depth = 3.0;
    btn2.alpha = 0.;
    
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"Test" forState:UIControlStateNormal];
    return btn2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    schemeColorArray = @[[UIColor grassColor],[UIColor blueberryColor],[UIColor grassColor],[UIColor grassColor],[UIColor grassColor],[UIColor grassColor],[UIColor grassColor],[UIColor grassColor]];
    
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    
    for (int i = 0; i  < 8 ; i++) {
        
        QBFlatButton *btn = [self newFlatButtonWithFrame:CGRectMake(i%2 * w/2, i/2 * h/4, w/2, h/4)];
        btn.tag = i;
        btn.backgroundColor = [schemeColorArray objectAtIndex:i];
        
        DLog(@"btn frame %@", NSStringFromCGRect(btn.frame));
        [self.view addSubview:btn];
        //self.view.backgroundColor = [UIColor grapefruitColor];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
