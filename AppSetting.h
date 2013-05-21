//
//  AppSetting.h
//  SecretNote
//
//  Created by Shi Lin on 4/2/13.
//  Copyright (c) 2013 DFA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSetting : NSObject

+ (BOOL)haveSetupPassword;
+ (void)setupPassword;

+ (void)savePassword:(NSString*)pwd emailAddress:(NSString*)ea;
+ (NSString*)whatisPassword;

+ (BOOL)isPasswordCorrect:(NSString*)pwd;

+ (BOOL)shouldShowPasswordView;
+ (void)needShowPasswordViewNextTime;

@end
