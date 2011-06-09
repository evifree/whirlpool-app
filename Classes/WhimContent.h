//
//  WhimContent.h
//  iWhirl
//
//  Created by mark wong on 18/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"


@interface WhimContent : UITableViewController <UITableViewDelegate>{

	NSMutableArray *whimID;
	NSMutableArray *whimContentMessageArray;
	NSOperationQueue *operationQueueWC;
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
	NSMutableArray *whimIDArray;
	
	NSString *whimBody;
	NSString *whimIDURL;
	NSString *titleStr;
	NSString *subtitle;
	NSUserDefaults *APIKey;
	//NSString *Whirl_Key;
}


@property (nonatomic, assign) NSIndexPath *indexPathRowNumber;
@property (nonatomic, assign) NSMutableArray *whimID;
@property (nonatomic, assign) NSString *whimIDURL;
@end