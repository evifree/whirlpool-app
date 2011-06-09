//
//  ForumIndexedView.h
//  iWhirl
//
//  Created by mark wong on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Threads.h"
#import "Gradient.h"

@interface ForumIndexedView : UITableViewController <UITableViewDelegate> {
	NSMutableArray *forumName;
	NSMutableArray *forumURL;
	NSMutableArray *forumNames;
	NSMutableArray *sectionTitles;
	NSMutableArray *forumID;
	NSOperationQueue *operationQueue;
	NSMutableArray *uniqueSections;
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
	NSMutableDictionary *dataDict;
	NSMutableDictionary *dataID;
	Threads *threads;
	NSUserDefaults *APIKey;
}

@end
