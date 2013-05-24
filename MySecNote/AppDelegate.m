//
//  AppDelegate.m
//  MySecNote
//
//  Created by forrest on 13-4-21.
//  Copyright (c) 2013年 DFA. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "GCPINViewController.h"
#import "AppSetting.h"
#import "Flurry.h"
#import "UIBarButtonItem+FlatUI.h"
//#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+Colours.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)showLoginViewWithPassword{
    NSString *xibName = (IS_IPHONE_5?@"GCPINViewController568":@"GCPINViewController480");
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:xibName
                                bundle:nil
                                mode:GCPINViewControllerModeVerify];
    
    PIN.messageText = @"Enter your password";;
//    PIN.messageLabel.text =
    PIN.messageLabel.textColor = [UIColor whiteColor];
    
    PIN.verifyBlock = ^(NSString *code) {
        //DLog(@"checking code: %@", code);
        
        BOOL pass = [AppSetting isPasswordCorrect:code];
        if (pass) {
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            PIN.messageLabel.text = @"Congratulations!";
            PIN.messageLabel.textColor = [UIColor whiteColor];
            PIN.backgroundView.startColor = [UIColor successColor];
            PIN.backgroundView.endColor = [UIColor blueNoteColor];
            [PIN.backgroundView update];
            
        }else{
            PIN.messageLabel.text = @"Wrong password";
            PIN.messageLabel.textColor = [UIColor whiteColor];
            
            PIN.backgroundView.startColor = [UIColor brickRedColor];
            PIN.backgroundView.endColor = [UIColor blueNoteColor];
            [PIN.backgroundView update];

        }
        return pass;
    };

    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self.window.rootViewController presentModalViewController:PIN animated:YES];
    //[PIN presentFromViewController:self.window.rootViewController animated:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Flurry startSession:@"37539QN6ZFGBM7N8XNB3"];
    application.statusBarHidden = YES;
    application.applicationSupportsShakeToEdit = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewWithPassword) name:kShowLoginView object:nil];
        
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSString *xibName = (IS_IPHONE_5?@"MasterViewController_iPhone568":@"MasterViewController_iPhone");
        MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:xibName bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
        masterViewController.managedObjectContext = self.managedObjectContext;
        
    } 
    [self.window makeKeyAndVisible];

    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:40/255. green:120/255. blue:160/255. alpha:1.]];
    [[UINavigationBar appearance] setTintColor:[UIColor blueNoteColor]];
    //[[UINavigationBar appearance] setFrame:CGRectMake(0., self.window.frame.size.height - 44., self.window.frame.size.width, 44.)];
    [[UISearchBar appearance] setTintColor:[UIColor blueNoteColor]];
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor blueNoteColor]
                                  highlightedColor:[UIColor blueNoteColor]
                                      cornerRadius:3];
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor blueNoteColor]];
    
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProximityChangeNotification:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

    
    return YES;
}

-(void)detectOrientation;{
    
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
        {
            DLog(@"portrait");
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        {
            DLog(@"portraitUpSideDown");
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            DLog(@"landscapeLeft");
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            DLog(@"landscapeRight");
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
        }
            break;
        case UIDeviceOrientationFaceDown:
        {
            DLog(@"facedown!!");
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
        }
            break;
            
        default:
            break;
    }
}


//-(void)handleProximityChangeNotification:(NSNotification*)nft{
//    if([[UIDevice currentDevice]proximityState]){
//        DLog(@"... %@" ,nft);
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MySecNote" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MySecNote.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
