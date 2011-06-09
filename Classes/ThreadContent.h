//
//  ThreadContent.h
//  iWhirl
//
//  Created by mark wong on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementParser.h"
#import "URLParser.h"
#import "Element.h"
#import "DocumentRoot.h"
#import "Gradient.h"
#import "navToolBar.h"
#import <QuartzCore/QuartzCore.h>
#import "ThreadReply.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "TTTAttributedLabel.h"
@interface ThreadContent : UITableViewController {
	ThreadContent *threadContent;

	NSURLRequest *requestObj;
	NSString *threadTitleString;
	
	int pageNo;
	NSString *pageNumberString;
	NSData *htmlData;
	NSString *urlAddress;
	NSString *urlThreadID;
	NSString *str;
	NSString *threadIDURL;
	NSUserDefaults *APIKey;
	NSString *Whirl_Key;
	//NSIndexPath *selectedCellIndexPath; 
	NSMutableArray *postsWithQuotes;
	NSMutableArray *uniqueQuotes;
	NSMutableArray *postList;
	NSMutableArray *userNameList;
	NSMutableArray *dateList;
	NSMutableArray *quipList;
	NSMutableArray *replyList;
	NSMutableArray *quotes;
	NSOperationQueue *operationQueue;
	BOOL firstLoad;
	NSString *newPage;

}

@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, assign) NSString *threadIDURL;
@property (nonatomic ,assign) NSString *threadTitleString;
@end
