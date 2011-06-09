//
//  Account.h
//  iWhirl
//
//  Created by mark wong on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "whirlpoolAppDelegate.h"
#import "ElementParser.h"
#import "URLParser.h"
#import "Element.h"
#import "DocumentRoot.h"

@interface Account : UIViewController <UITextFieldDelegate, UITabBarControllerDelegate> {
	UITextField *firstPartAPI;
	NSUserDefaults *APIKey;
	UITextField *secondPartAPI;
	UITextField *thirdPartAPI;
	UITextField *userTF;
	UITextField *passTF;
	UITextField *API;
	NSOperationQueue *operationQueue;
}

@end
