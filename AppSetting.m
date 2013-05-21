//
//  AppSetting.m
//  SecretNote
//
//  Created by Shi Lin on 4/2/13.
//  Copyright (c) 2013 DFA. All rights reserved.
//

#import "AppSetting.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation AppSetting



+(NSString *) hashString:(NSString *) data withSalt:(NSString *)salt {
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
    
}

+ (BOOL)haveSetupPassword{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"create_pwd"];
}

+ (void)setupPassword{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"create_pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];  
}

+ (void)savePassword:(NSString*)pwd emailAddress:(NSString*)ea{
    
    [[NSUserDefaults standardUserDefaults] setValue:[AppSetting hashString:pwd withSalt:ea.length > 0 ? ea : @"default_salt"] forKey:@"pwd_hash"];
    [[NSUserDefaults standardUserDefaults] setValue:ea forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)whatisPassword{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"pwd_hash"];
}

+ (BOOL)isPasswordCorrect:(NSString*)pwd{
    NSString *ea = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    if (pwd && [[AppSetting hashString:pwd withSalt:ea.length > 0 ? ea : @"default_salt"] isEqualToString:[AppSetting whatisPassword] ]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)shouldShowPasswordView{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"need_show"];
}

+ (void)needShowPasswordViewNextTime{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"need_show"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
