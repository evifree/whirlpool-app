//
//  ThreadReply.h
//  whirlpool
//
//  Created by mark wong on 3/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "ElementParser.h"
#import "URLParser.h"
#import "Element.h"
#import "DocumentRoot.h"
#import "navToolBar.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface ThreadReply : UITableViewController <UITextViewDelegate, ASIHTTPRequestDelegate> {
	NSString *replyLink;
	UIWebView *threadReplyWV;
	NSOperationQueue *operationQueue;
	NSMutableArray *separatedString;
	UITextView *replyTextView;
	NSString *replyPostCode;
}

@property (nonatomic, assign) NSString *replyLink;
-(void)produceHTMLForPage;
-(void)getPost;
-(void)beginLoadingPost;
@end
