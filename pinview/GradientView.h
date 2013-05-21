//
//  GradientView.h
//  MySecNote
//
//  Created by forrest on 13-5-20.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

@property(nonatomic,strong) UIColor *startColor;
@property(nonatomic,strong) UIColor *endColor;

- (void)update;

@end
