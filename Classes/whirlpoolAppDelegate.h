//
//  whirlpoolAppDelegate.h
//  whirlpool
//
//  Created by mark wong on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//#import "Tab1ViewController.h"
#import "Account.h"
#import "News.h"
#import "Whims.h"
#import "About.h"
#import "ForumIndexedView.h"
#import <UIKit/UIKit.h>

@interface whirlpoolAppDelegate : NSObject <UIApplicationDelegate> {
	
    UIWindow *window;
	UITabBarController *tabBarController;
	UINavigationController *newsNavController;
	UINavigationController *accountNavController;
	UINavigationController *whimsNavController;
	UINavigationController *aboutNavController;
	UINavigationController *forumIndexedViewNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)applicationDocumentsDirectory;

@end

