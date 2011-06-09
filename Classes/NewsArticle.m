//
//  ThreadContent.m
//  iWhirl
//
//  Created by mark wong on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewsArticle.h"


@implementation NewsArticle

@synthesize newsIDURL;
/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];	
	newsArticleWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, 320, 420)];
	newsArticleWebView.delegate = self;
	newsArticleWebView.scalesPageToFit = YES;
	//http://whirlpool.net.au/news/go.cfm?article=51353 webview link 51353 = id

    urlAddress = [NSString stringWithFormat:@"http://whirlpool.net.au/news/go.cfm?article=%@", newsIDURL];
    //Create a URL object.
    url = [NSURL URLWithString:urlAddress];
	
    //URL Requst Object
    requestObj = [NSURLRequest requestWithURL:url];
	
    //Load the request in the UIWebView.
    [newsArticleWebView loadRequest:requestObj];
	[self.view addSubview:newsArticleWebView];
	
	//str = [newsArticleWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
	//[newsArticleWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.9;"];
	int scroll = 50; //Pixels to scroll
	NSString* s=[[NSString alloc] initWithFormat:@"window.scrollTo(0, %i)",scroll];
	[newsArticleWebView stringByEvaluatingJavaScriptFromString:s];
    //[self removeFromSuperview];
	[s release];
	
	//str = [threadContentWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	//[self performSelectorOnMainThread:@selector(didFinishLoadingThread:) withObject:self.view waitUntilDone:NO];
	
    //NSLog(@"str %@", str);
}

/*
 - (void)webViewDidStartLoad:(UIWebView *)webView
 {
 // starting the load, show the activity indicator in the status bar
 [UIApplication sharedApplication].isNetworkActivityIndicatorVisible = YES;
 }
 
 - (void)webViewDidFinishLoad:(UIWebView *)webView
 {
 // finished loading, hide the activity indicator in the status bar
 [UIApplication sharedApplication].isNetworkActivityIndicatorVisible = NO;
 }
 
 - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
 {
 // load error, hide the activity indicator in the status bar
 [UIApplication sharedApplication].isNetworkActivityIndicatorVisible = NO;
 
 // report the error inside the webview
 NSString* errorString = [NSString stringWithFormat:
 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
 error.localizedDescription];
 [myWebView loadHTMLString:errorString baseURL:nil];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[newsArticleWebView release];

    [super dealloc];
}


@end
