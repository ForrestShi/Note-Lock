//
//  GradientView.m
//  MySecNote
//
//  Created by forrest on 13-5-20.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView
@synthesize startColor,endColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    if (!startColor) {
        startColor = [UIColor blueNoteColor];
    }
    if (!endColor) {
        endColor = [UIColor blueNoteColor];
    }
    const CGFloat *c1 = CGColorGetComponents(startColor.CGColor);
    const CGFloat *c2 = CGColorGetComponents(endColor.CGColor);
    
    CGFloat components[8] = {c1[0],c1[1],c1[2],c1[3],c2[0],c2[1],c2[2],c2[3],nil }; // Start color
//        (id)endColor.CGColor }; // End color
 //   CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGPoint bottom  = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetHeight(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, bottom, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)update{
    [self setNeedsDisplay];
}

@end
