//
//  NewsArticle.h
//  iWhirl
//
//  Created by mark wong on 17/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsArticle : UIViewController <UIWebViewDelegate> {
	UIWebView *newsArticleWebView;
	
	NewsArticle *newsArticle;
	
	NSURL *url;
	NSURLRequest *requestObj;
	
	NSString *urlAddress;
	NSString *str;
	NSString *newsIDURL;
	NSString *threadIDURL;
}

@property (nonatomic, assign) NSString *newsIDURL;


@end
