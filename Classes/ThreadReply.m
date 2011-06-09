//
//  ThreadReply.m
//  whirlpool
//
//  Created by mark wong on 3/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThreadReply.h"

#define CONST_detailLabelFontSize   14
#define CONST_Cell_height 10.0f
#define CONST_Cell_width 300.0f

@implementation ThreadReply

@synthesize replyLink;
static UIFont *subFont;

/*- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	return YES;
}*/

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {		//threading
													//NSLog(@"testinit");
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
	}
    return self;
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	//NSString *responseString = [request responseString];
	//NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);

	//NSData *responseData = [request responseData];
}

- (void) requestStarted:(ASIHTTPRequest *) request {
	NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	NSError *error = [request error];
	NSLog(@"%@", error);
}


-(void)submitPostFunction:(id)sender {
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://forums.whirlpool.net.au%@", replyLink]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setRequestMethod:@"POST"];
	[request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
	[request setPostValue:[NSString stringWithFormat:@"%@", replyTextView.text]
 forKey:@"body"];
	[request setPostValue:@"submit" forKey:@"post"];
	[request setPostValue:@"3" forKey:@"version"];
	[request setPostValue:@"" forKey:@"post2"];
	[request setPostValue:@"too right" forKey:@"form"];
	//[request setPostValue:@"" forKey:@"tinkle"];
	[request setPostValue:@"false" forKey:@"poll_enalbled"];
	[request setPostValue:@"0" forKey:@"poll_choice_size"];
	//[request setPostValue:@"" forKey:@"timestart"];
	
	[request setDelegate:self];
	[request startAsynchronous];
	/*<input type="submit" name="post" id="post" tabindex="56" style="width:150px;font:16px Arial;" value="Post Reply" onclick="return clicksubmit();">*/
	
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	
}

- (void) viewDidLoad {
	[super viewDidLoad];

	self.title = @"test";
	//NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
	//[operationQueue setMaxConcurrentOperationCount:1];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.separatorColor = [UIColor clearColor];
	UIToolbar *threadContentNavigation = [[navToolBar alloc] initWithFrame:CGRectMake(0,0,80,44.1)];

	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
	
	UIBarButtonItem *leftPage = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitPostFunction:)];
	[buttons addObject:leftPage];
	
	[leftPage release];
	
	// stick the buttons in the toolbar
	[threadContentNavigation setItems:buttons animated:NO];
	
	[buttons release];
	
	// and put the toolbar in the nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:threadContentNavigation];
	[threadContentNavigation release];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self beginLoadingPost];
}

-(void)produceHTMLForPage{
    //init a mutable string, initial capacity is not a problem, it is flexible
	[self.tableView reloadData];
	
}

-(void) getPost {
	
	//NSLog(@"%@", replyLink);
	
	replyPostCode = [[[replyLink componentsSeparatedByCharactersInSet:
							[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] 
						   componentsJoinedByString:@""] copy];
	NSLog(@"%@", replyPostCode);
	separatedString = [[NSMutableArray alloc] initWithObjects:nil];
	
	NSString *postHTML = [NSString stringWithFormat:@"http://forums.whirlpool.net.au%@", replyLink];
	//NSLog(@"postHTML %@", postHTML); 
	NSURL *urlPost = [NSURL URLWithString:postHTML];//[NSURL URLWithString:@"http://forums.whirlpool.net.au/forum-replies.cfm?t=%@", threadIDURL];
	NSString *html = [NSString stringWithContentsOfURL:urlPost encoding:NSUTF8StringEncoding error:nil];
	DocumentRoot *document = [Element parseHTML:html];
	NSString *baseExp = @"td.bodytext div#reply_tr1";//tr1 - posts without showing quoted text	
	NSString *postString = [[document selectElement:baseExp] contentsText];
	NSArray *stringArray;
	stringArray = [postString componentsSeparatedByString:@"\n"];
	for (int i = 0; i < [stringArray count]; i++) {
		
		if (!([[stringArray objectAtIndex:i] isEqualToString:@""])) {
			[separatedString addObject:[stringArray objectAtIndex:i]];
		}
	}
	
	
	[self performSelectorOnMainThread:@selector(produceHTMLForPage) withObject:nil waitUntilDone:NO];
}


-(void) beginLoadingPost {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getPost) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

- (UIFont*) SubFont;
{
	if (!subFont) subFont = [UIFont systemFontOfSize:CONST_detailLabelFontSize];
	return subFont;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"%@", [replyList objectAtIndex:indexPath.row]);
	//BOOL firstQuote = TRUE;
	//NSLog(@"%@", [separatedString objectAtIndex:indexPath.row]);
	//NSLog(@"%@", replyPostCode);

	replyTextView.text = [NSString stringWithFormat:@"@%@ UserName writes... \n[\"%@\"]", replyPostCode,[separatedString objectAtIndex:indexPath.row]];
}

- (UITableViewCell*) CreateMultilinesCell :(NSString*)cellIdentifier
{
	//NSLog(@"Entering CreateMultilinesCell");
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
													reuseIdentifier:cellIdentifier] autorelease];
	
	cell.detailTextLabel.numberOfLines = 0;
	cell.detailTextLabel.font = [self SubFont];
	cell.detailTextLabel.textColor = [UIColor colorWithRed:10.0/255 green:10.0/255 blue:33.0/255 alpha:1.0];
	[cell setBackgroundColor:[UIColor clearColor]];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
															 //NSLog(@"Exiting CreateMultilinesCell");
	return cell;
}

- (int) heightOfCellWithTitle :(NSString*)subtitleText 
{
	//NSLog(@"Entering heightOfCellWithTitle");

	CGSize subtitleSize = {0, 0};
	
	if (subtitleText && ![subtitleText isEqualToString:@""]) 
		subtitleSize = [subtitleText sizeWithFont:[self SubFont] constrainedToSize:CGSizeMake(CONST_Cell_width, 10) lineBreakMode:UILineBreakModeCharacterWrap];//UILineBreakModeTailTruncation];//UILineBreakModeWordWrap];
	//NSLog(@"Exiting heightOfCellWithTitle");
	return subtitleSize.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"count %d", [separatedString count]);
	switch (section) {
		case 0:
			return [separatedString count];//should be the number of paragraphs
		default:
			return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 0)
		return @"Title";
	else {
		return @"Reply";
	}
}
//modified cocoawithlove code
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] == 0) {
		NSString *text = [separatedString objectAtIndex:indexPath.row];
		UIFont *cellFont = [UIFont systemFontOfSize:CONST_detailLabelFontSize];//fontWithName:@"Helvetica" size:17.0];
		CGSize constraintSize = CGSizeMake(280.0f, 500.0f);
		CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		int height = 10 + labelSize.height; 
		//can shift the wall of text of the post here
											//NSLog(@"Exiting heightForRowAtIndexPath");
		return (height < CONST_Cell_height ? CONST_Cell_height : height);
	}
	else {
		return 200;
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	static NSString *replyCellIdentifier = @"replyCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		if ([indexPath section] == 0) {
			cell = [[[UITableViewCell alloc]
					 initWithStyle:UITableViewCellStyleSubtitle
					 reuseIdentifier:CellIdentifier] autorelease];
			cell.detailTextLabel.numberOfLines = 0;
			cell.detailTextLabel.font = [self SubFont];
			cell.detailTextLabel.textColor = [UIColor colorWithRed:10.0/255 green:10.0/255 blue:33.0/255 alpha:1.0];
			[cell setBackgroundColor:[UIColor clearColor]];
			[self.tableView setBackgroundColor:[UIColor clearColor]];
			
			//[self CreateMultilinesCell:CellIdentifier];		
		}
		else if ([indexPath section] == 1) {
			//NSLog(@"TextField");
			cell = [self CreateMultilinesCell:replyCellIdentifier];	
			if ([indexPath row] == 0) {
				replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
				//replyTextView.adjustsFontSizeToFitWidth = YES;
				replyTextView.textColor = [UIColor blackColor];
				replyTextView.keyboardType = UIKeyboardTypeASCIICapable;
				replyTextView.returnKeyType = UIReturnKeyDefault;
				replyTextView.backgroundColor = [UIColor whiteColor];
				replyTextView.autocorrectionType = UITextAutocorrectionTypeNo; 
				replyTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
				replyTextView.textAlignment = UITextAlignmentLeft;
				replyTextView.tag = 0;
				
				replyTextView.editable = YES;
				replyTextView.delegate = self;
				replyTextView.scrollEnabled = YES;
				
				[cell.contentView addSubview:replyTextView];
				
				[replyTextView release];
				//cell.detailTextLabel.text = @"";
			}			
		}
	}
	if ([indexPath section] == 0) {
		cell.detailTextLabel.text = [separatedString objectAtIndex:indexPath.row];
	}
	else {
		replyTextView.text = [NSString stringWithFormat:@"%@", replyTextView.text];
	}

	return cell;
}

- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	// [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) dealloc {
    [super dealloc];
}

@end
