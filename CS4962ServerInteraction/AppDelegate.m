//
//  AppDelegate.m
//  CS4962ServerInteraction
//
//  Created by WENGzhang on 14/05/2017.
//  Copyright © 2017 WENGzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "InputURLViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UINavigationController *navController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen.mainScreen bounds]];
    [_window makeKeyAndVisible];
    _navController = [UINavigationController new];
    _window.rootViewController = _navController;
    [_navController pushViewController:[[InputURLViewController alloc] init] animated:YES];
    return YES;
}

@end
