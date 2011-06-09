//
//  Whims.h
//  iWhirl
//
//  Created by mark wong on 16/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhimContent.h"
#import "Gradient.h"
#import "JSON.h"

@interface Whims : UITableViewController <UITableViewDelegate> {
	NSOperationQueue *operationQueue;
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
	
	NSMutableArray *whimMessageArray;
	NSMutableArray *whimIDArray;
	NSMutableArray *whimViewedArray;
	NSMutableArray *whimNameArray;
	NSMutableArray *whimFromArray;
	WhimContent *whimContent;
	NSUserDefaults *APIKey;
	NSString *Whirl_Key;
}

@end
