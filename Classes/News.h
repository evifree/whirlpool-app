//
//  News.h
//  iWhirl
//
//  Created by mark wong on 16/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "NewsArticle.h"
#import <UIKit/UIKit.h>
#import "ISO8601DateFormatter.h"
#import "Gradient.h"
#import "ISO8601DateFormatter.h"
#import "JSON.h"

@interface News : UITableViewController {
	NSOperationQueue *operationQueue;
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel; 
	
	NSArray *newsList;

	NSString *blurb;
	NSString *titleOfNews;
	NSString *newsID;
	NSString *titleStr;
	NSString *subtitle;
	NSString *todaysDate;
	
	NSMutableArray *titleArray;
	NSMutableArray *blurbArray;
	NSMutableArray *newsIDArray;
	NSMutableArray *dateArray;
	
	NSSet *uniqueDates;
	
	NSUserDefaults *APIKey;
	NSString *Whirl_Key;
	//ISO8601DateFormatter *formatter;
	NewsArticle *newsArticle;
}

@end
