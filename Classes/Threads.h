//
//  Threads.h
//  iWhirl
//
//  Created by mark wong on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Gradient.h"
#import "JSON.h"
#import "ThreadContent.h"

@interface Threads : UITableViewController {
	NSMutableArray *threadName;
	NSMutableArray *threadTitle;
	//NSMutableArray *forumID;
	NSString *forumID;
	NSMutableArray *threadID;
	NSMutableArray *threadReplies;
	
	UIActivityIndicatorView *spinner;
	NSOperationQueue *operationQueue;
	UILabel *loadingLabel;
	
	NSInteger *indexPathRowNumber;
	
	NSUserDefaults *APIKey;
	//NSString *Whirl_Key;
	ThreadContent *threadContent;
}

//@property (nonatomic, assign) NSMutableArray *forumID;
@property (nonatomic, assign) NSString *forumID;
@property (nonatomic, assign) NSInteger *indexPathRowNumber;

@end
