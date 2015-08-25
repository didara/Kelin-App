//
//  AppDelegate.m
//  K
//
//  Created by Didara Pernebayeva on 29.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <UIFont+OpenSans.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [Fabric with:@[CrashlyticsKit]];
    [Parse enableLocalDatastore];
    // Initialize Parse.
    [Parse setApplicationId:@"vNR38KAk0ptpNa2SFHViWfOVEU1q4Qmni117ylkS"
                  clientKey:@"sXfRD29PmYcv4SWPAp2eFISYTVQ1RPyPqMDb6Q3q"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([PFUser currentUser]) {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"]];
    } else {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"AuthorizationViewController"]];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont openSansFontOfSize:17] }];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont openSansFontOfSize:17] } forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1]] /*#d81e35*/;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
