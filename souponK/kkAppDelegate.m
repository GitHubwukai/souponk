//
//  kkAppDelegate.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "kkAppDelegate.h"
#import "kkFirstViewController.h"
#import "kkSecondViewController.h"
#import "kkThirdViewController.h"
#import "kkFourthViewController.h"

#define NavBarColor [UIColor colorWithRed:200.00f/255.0f green:0 blue:0 alpha:1]

@implementation kkAppDelegate
@synthesize navController;
@synthesize tabBarController;

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	
	UIViewController *viewController1 = [[[kkFirstViewController alloc] initWithNibName:@"kkFirstViewController" bundle:nil]autorelease];
	UIViewController *viewController2 = [[[kkSecondViewController alloc] initWithNibName:@"kkSecondViewController" bundle:nil]autorelease];
	UIViewController *viewController3 = [[[kkThirdViewController alloc] initWithNibName:@"kkThirdViewController" bundle:nil]autorelease];
	UIViewController *viewController4 = [[[kkFourthViewController alloc] initWithNibName:@"kkFourthViewController" bundle:nil]autorelease];
	
	//tabBar
	self.tabBarController = [[[UITabBarController alloc] init] autorelease];
	self.tabBarController.tabBar.selectedImageTintColor = [UIColor whiteColor];
	UIImage *dImage = [UIImage imageNamed:@"tbg.png"];
	self.tabBarController.tabBar.selectionIndicatorImage = dImage;
	self.tabBarController.viewControllers = [NSArray arrayWithObjects:
											 viewController1,
											 viewController2,
											 viewController3,
											 viewController4, nil];
	//navigationController
	self.navController = [[UINavigationController alloc]
						  initWithRootViewController:self.tabBarController];
	self.navController.navigationBar.tintColor = NavBarColor;
	
	UIImageView *i = [[[UIImageView alloc] initWithImage:
					   [UIImage imageNamed:@"hotbarbg.png"]]autorelease];
	i.frame = CGRectMake(0, 0, 320, 44);
	//设置竖屏时navigationBar的背景图片
	[self.navController.navigationBar setBackgroundImage:i.image forBarMetrics:UIBarMetricsDefault];
	
	self.window.rootViewController = self.navController;
	
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
