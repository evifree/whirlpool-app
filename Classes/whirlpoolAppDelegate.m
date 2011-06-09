//
//  whirlpoolAppDelegate.m
//  whirlpool
//
//  Created by mark wong on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "whirlpoolAppDelegate.h"
//#import "Tab1ViewController.h"
//#import "News.h"


@implementation whirlpoolAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Override point for customization after app launch    
	tabBarController = [[UITabBarController alloc] init];

	Account *accountViewController = [[Account alloc] init];
	News *newsViewController = [[News alloc] init];//WithStyle:UITableViewStyleGrouped];
	Whims *whimsViewController = [[Whims alloc] init];//initWithStyle:UITableViewStyleGrouped];
	About *aboutViewController = [[About alloc] init];
	ForumIndexedView *ForumIndexedViewController = [[ForumIndexedView alloc] init];
	

	accountNavController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
	newsNavController = [[UINavigationController alloc] initWithRootViewController:newsViewController];
	whimsNavController = [[UINavigationController alloc] initWithRootViewController:whimsViewController];
	aboutNavController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
	forumIndexedViewNavController = [[UINavigationController alloc] initWithRootViewController:ForumIndexedViewController];
	
	
	[accountViewController release];
	[newsViewController release];
	[whimsViewController release];
	[aboutViewController release];
	[ForumIndexedViewController release];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects: accountNavController, forumIndexedViewNavController,  newsNavController, whimsNavController, nil];

	
	//[window addSubview:customTabBar.tabBar1];
	[window addSubview:tabBarController.view];
	
	[window makeKeyAndVisible];
	//whimsNavController.badgeValue = @"2";
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void)dealloc {    
	[tabBarController release];
	[whimsNavController release];
	[aboutNavController release];
	[accountNavController release];
	[newsNavController release];
    [window release];
    [super dealloc];
}


@end
