//
//  ThreadContent.m
//  iWhirl
//
//  Created by mark wong on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define FONT_SIZE 12.0f
#define CONST_detailLabelFontSize   14
#define CONST_Cell_height 150.0f
#define CONST_Cell_width 300.0f
#define LABEL_TAG 1
#define DATE_LABEL_TAG 2
#define QUIP_LABEL_TAG 3
#define POST_LABEL_TAG 4
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN_X 10.0f
#define CELL_CONTENT_MARGIN_Y 45.0f

#import "ThreadContent.h"


@interface ThreadContent (Internal)
- (UITableViewCell*)CreateMultilinesCell:(NSString *)cellIdentifier;
- (void)beginLoadingThreadContent;
- (void)synchronousLoadThreadContent;
- (void)didFinishLoadingThreadContentWithResults;
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
@end

@implementation ThreadContent

@synthesize firstLoad;
@synthesize threadIDURL;
@synthesize threadTitleString;
static UIFont *subFont;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {		//threading
	
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
	}
    return self;
}

-(void)leftPageFunction:(id)sender {

	int pageNumber = [pageNumberString intValue];
	[pageNumberString release];
	pageNumber--;
	newPage = [[NSString stringWithFormat:@"%d", pageNumber] retain];
	firstLoad = FALSE;
	[self beginLoadingThreadContent];
}

-(void)rightPageFunction:(id)sender {
	
	int pageNumber = [pageNumberString intValue];
	pageNumber++;
	newPage = [[NSString stringWithFormat:@"%d", pageNumber] retain];
	firstLoad = FALSE;
	[self beginLoadingThreadContent];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	UIToolbar *threadContentNavigation = [[navToolBar alloc] initWithFrame:CGRectMake(0,0,80,44.1)];
	
	//UIToolbar *threadContentNavigation = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,80,44.1)];
	threadContentNavigation.backgroundColor = [UIColor clearColor];
	threadContentNavigation.tintColor = [UIColor colorWithRed:65.0/255 green:80.0/255 blue:123.0/255 alpha:1.0];
	threadContentNavigation.translucent = YES;
	threadContentNavigation.alpha = 1.0;
	threadContentNavigation.opaque = NO;
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
	
	UIBarButtonItem *leftPage = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleBordered target:self action:@selector(leftPageFunction:)];
	[buttons addObject:leftPage];
	[leftPage release];
	
	UIBarButtonItem *rightPage = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(rightPageFunction:)];
	[buttons addObject:rightPage];
	[rightPage release];
	
	// stick the buttons in the toolbar
	[threadContentNavigation setItems:buttons animated:NO];
	
	[buttons release];
	
	// and put the toolbar in the nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:threadContentNavigation];
	[threadContentNavigation release];
}

- (void)beginLoadingThreadContent {
	//threading
	//move the url stuff up here
	//and thread the parsing of the webpage in synchronousLoadThreadContent.
	NSLog(@"beginLoadingtest");
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadThreadContent) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//[self showLoadingIndicators];
	[self beginLoadingThreadContent];
}

- (void)synchronousLoadThreadContent {

	NSURL *urlThread;
	HTMLParser *parser;
	NSError *error = nil;

	if (firstLoad == TRUE) {

		urlThread = [NSURL URLWithString:[NSString stringWithFormat:@"http://forums.whirlpool.net.au/forum-replies.cfm?t=%@&p=-1#bottom", threadIDURL]];
	}
	else {

		urlThread = [NSURL URLWithString:[NSString stringWithFormat:@"http://forums.whirlpool.net.au/forum-replies.cfm?t=%@&p=%@", threadIDURL, newPage]];
		//[newPage release];
	}
	
	parser = [[HTMLParser alloc] initWithContentsOfURL:urlThread error:&error];
	if (error) {
		NSLog(@"Error:%@", error);
		return;
	}
	
	postList = [[NSMutableArray alloc] initWithObjects:nil];
	userNameList = [[NSMutableArray alloc] initWithObjects:nil];
	dateList = [[NSMutableArray alloc] initWithObjects:nil];
	quipList = [[NSMutableArray alloc] initWithObjects:nil];
	replyList = [[NSMutableArray alloc] initWithObjects:nil];

	NSString *getTimeExp = @"div.date";
	NSString *getQuipExp = @"td.bodyuser div a";
	NSString *getPageExp = @"li.current";
	NSString *postExp = @" td.bodytext";
	NSString *userExp = @" span.bu_name";
	
	DocumentRoot *postHTML;
	//NSLog(@"pageNumberString %@", pageNumberString);//don't print this otherwise it will crash

	HTMLNode *bodyNode = [parser body];
	NSArray *pageNumberHTML = [bodyNode findChildTags:@"div"];
	for (HTMLNode *pageNumber in pageNumberHTML) {
		if ([[pageNumber getAttributeNamed:@"class"] isEqualToString:@"topbar"]) {
			//NSLog(@"%@", [pageNumber rawContents]);
			postHTML = [Element parseHTML:[pageNumber rawContents]];
			pageNumberString = [[postHTML selectElement:getPageExp] contentsText];
			[pageNumberString retain];
		}
		
	}
	NSString *rString;
	NSString *noRString;
	NSArray *replyCodeHTML = [bodyNode findChildTags:@"tr"];
	for (HTMLNode *reply in replyCodeHTML) {
		rString = [reply getAttributeNamed:@"id"];
		noRString = [rString stringByReplacingOccurrencesOfString:[NSString stringWithString:@"r"] withString:@""];
		[replyList addObject:[NSString stringWithFormat:@"/forum/index.cfm?action=reply&r=%@", noRString]];
		//NSLog(@"%@", [reply getAttributeNamed:@"id"]);
	}
	
	NSArray *bodyText = [bodyNode findChildTags:@"td"];
	NSString *postString;
	NSString *quotedString;
	NSString *quotedExp = @"span";
	NSArray *quotedArray;
	int ii = 0;
	//int jj = 0;
	//postsWithQuotes = [[NSMutableArray alloc] initWithCapacity:20];
	//quotes = [[NSMutableArray alloc] init];
	/*for (int i = 0; i < 20; i++) {
		[postsWithQuotes addObject:[NSNull NULL]];
	}*/
	for (HTMLNode *inputBody in bodyText) {
		//NSLog(@"InputBody ******** %@", [inputBody rawContents]);
		if ([[inputBody getAttributeNamed:@"class"] isEqualToString:@"bodytext"]) {	
			quotedArray = [inputBody findChildTags:@"span"];
			//NSLog(@"Q %@", quotedArray);
			//NSLog(@"input body %@", [inputBody rawContents]);
			//NSLog(@"i %d", ii++);
			//for (HTMLNode *nestedQuotes in quotedArray) {
				//NSLog(@"j %d", jj++);
				[postsWithQuotes insertObject:[NSString stringWithFormat:@"%d",ii] atIndex:ii];
				//NSLog(@"nestedQuotes %@", [nestedQuotes rawContents]);
				//postHTML = [Element parseHTML:[nestedQuotes rawContents]];
				//quotedString = [[postHTML selectElement:quotedExp] contentsText];
				//NSLog(@"%@", [NSString stringWithFormat:@"[\"%@\"]", quotedString]);
				//[quotes addObject:quotedString];
				//NSLog(@"quoted %@", quotedString);
				//}

			
			postHTML = [Element parseHTML:[inputBody rawContents]];
			//NSLog(@"%@", postHTML);
			postString = [[postHTML selectElement:postExp] contentsText];
			//NSLog(@"%@", postString);
			[postList addObject:postString];
		}
	}
	NSLog(@"%@", postsWithQuotes);
	for (int h = 0; h < 20; h++) {
		if ([postsWithQuotes objectAtIndex:h] == NULL) {
			NSLog(@"");
		}
	}
	NSLog(@"%d", [postsWithQuotes count]);
	//NSSet *unique = [NSSet setWithArray:postsWithQuotes];
	//uniqueQuotes = [[unique allObjects] mutableCopy];
	NSLog(@"u %d", [uniqueQuotes count]);
	NSArray *nameTextHTML = [bodyNode findChildTags:@"span"];
	NSString *nameString;
	for (HTMLNode *getName in nameTextHTML) {
		if ([[getName getAttributeNamed:@"class"] isEqualToString:@"bu_name"]) {
			//NSLog(@"%@", [getName rawContents]);
			postHTML = [Element parseHTML:[getName rawContents]];
			nameString = [[postHTML selectElement:userExp] contentsText];
			//NSLog(@"%@", nameString);
			[userNameList addObject:nameString];
		}
	}
	
	//NSLog(@"%d", [userNameList count]);
	NSArray *quipHTML = [bodyNode findChildTags:@"td"];
	NSString *quipString;
	NSString *quip;
	int count = 0;
	for (HTMLNode *getQuip in quipHTML) {
		
		if ([[getQuip getAttributeNamed:@"class"] isEqualToString:@"bodyuser"]) {
			postHTML = [Element parseHTML:[getQuip rawContents]];
			quipString = [[postHTML selectElement:getQuipExp] contentsText];
			//NSLog(@"%@", quipString);
			quip = [quipString stringByReplacingOccurrencesOfString:[NSString stringWithString:[userNameList objectAtIndex:count]] withString:@""];
			//NSLog(@"%@", quip);
			[quipList addObject:quip];
		}
		if (count < [userNameList count] - 1) {
			count++;
		}
	}
	
	NSArray *timeHTML = [bodyNode findChildTags:@"div"];
	NSString *timeString;
	for (HTMLNode *getTime in timeHTML) {
		if ([[getTime getAttributeNamed:@"class"] isEqualToString:@"date"]) {
			postHTML = [Element parseHTML:[getTime rawContents]];
			timeString = [[[postHTML selectElement:getTimeExp] contentsText] stringByReplacingOccurrencesOfString:@"posted" withString:@""];
			//NSLog(@"%@", timeString);
			[dateList addObject:timeString];
			
		}
	}	
	
	//NSLog(@"number %@", pageNumberString);
	if (pageNumberString == NULL) {
		self.title = @"1";
	}
	else {
		self.title = [NSString stringWithString:pageNumberString];
	}
	//NSLog(@"last for loop");
	
	[self performSelectorOnMainThread:@selector(didFinishLoadingThreadContentWithResults) withObject:nil waitUntilDone:NO];
}

- (void)didFinishLoadingThreadContentWithResults {//(NSDictionary *)results {
	NSLog(@"reload");
	[self.tableView reloadData];
	[self.tableView flashScrollIndicators];
}

- (UIFont*) SubFont;
{
	if (!subFont) subFont = [UIFont systemFontOfSize:CONST_detailLabelFontSize];
	return subFont;
}

- (UITableViewCell*) CreateMultilinesCell :(NSString*)cellIdentifier
{
	//NSLog(@"Entering CreateMultilinesCell");
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
													reuseIdentifier:cellIdentifier] autorelease];
	
	cell.detailTextLabel.numberOfLines = 0;
	cell.detailTextLabel.font = [self SubFont];
	cell.detailTextLabel.textColor = [UIColor colorWithRed:10.0/255 green:10.0/255 blue:33.0/255 alpha:1.0];
	[cell setBackgroundColor:[UIColor clearColor]];//]colorWithRed:.98 green:.98 blue:.99 alpha:1.0]];
	[self.tableView setBackgroundColor:[UIColor clearColor]];//colorWithRed:.94 green:.96 blue:.99 alpha:1.0]];
															 //NSLog(@"Exiting CreateMultilinesCell");
	return cell;
}

- (int) heightOfCellWithTitle :(NSString*)subtitleText 
{
	//NSLog(@"Entering heightOfCellWithTitle");
	//CGSize titleSize = {0, 0};
	CGSize subtitleSize = {0, 0};

	if (subtitleText && ![subtitleText isEqualToString:@""]) 
		subtitleSize = [subtitleText sizeWithFont:[self SubFont] constrainedToSize:CGSizeMake(CONST_Cell_width, 10000) lineBreakMode:UILineBreakModeCharacterWrap];//UILineBreakModeTailTruncation];//UILineBreakModeWordWrap];
	//NSLog(@"Exiting heightOfCellWithTitle");

	return subtitleSize.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [postList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"%@", [replyList objectAtIndex:indexPath.row]);
	ThreadReply *threadReply = [[ThreadReply alloc] initWithStyle:UITableViewStyleGrouped];
	threadReply.replyLink = [replyList objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:threadReply animated:YES];
	// Forces the table view to call heightForRowAtIndexPath
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"Entering heightForRowAtIndexPath");
	NSString *text = [postList objectAtIndex:indexPath.row];
	UIFont *cellFont = [UIFont systemFontOfSize:CONST_detailLabelFontSize];//fontWithName:@"Helvetica" size:17.0];
	CGSize constraintSize = CGSizeMake(280.0f, 5000.0f);
    CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	int height = 90 + labelSize.height; 
	//int height = 90 + labelSize.height; 

	//[self heightOfCellWithTitle:text]; //andSubtitle:subtitle];//can shift the wall of text of the post here
	return (height < CONST_Cell_height ? CONST_Cell_height : height);//height;//
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return threadTitleString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	const CGFloat LABEL_HEIGHT = 20;

	UILabel *userLabel = [[UILabel alloc] autorelease];
	UILabel *dateLabel = [[UILabel alloc] autorelease];
	UILabel *quipLabel = [[UILabel alloc] autorelease];
	//TTTAttributedLabel *postLabel = [[TTTAttributedLabel alloc] autorelease];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		cell = [self CreateMultilinesCell:CellIdentifier];		
		cell.backgroundView = [[[Gradient alloc] init] autorelease];
		/*
		postLabel = [[[TTTAttributedLabel alloc] initWithFrame:CGRectZero] autorelease];
		postLabel.font = [UIFont systemFontOfSize:14];
		postLabel.lineBreakMode = UILineBreakModeWordWrap;
		postLabel.textColor = [UIColor blackColor];
		postLabel.backgroundColor = [UIColor clearColor];
		postLabel.numberOfLines = 0;
		postLabel.tag = POST_LABEL_TAG;
		//[cell.contentView addSubview:postLabel];
		*/
		userLabel =	[[[UILabel alloc] initWithFrame: CGRectMake(cell.indentationWidth, (tableView.rowHeight - 2 * LABEL_HEIGHT), tableView.bounds.size.width - 4.0 * cell.indentationWidth, LABEL_HEIGHT)] autorelease]; //"4 *" to see multilines
		[cell.contentView addSubview:userLabel];
		userLabel.tag = LABEL_TAG;
		userLabel.font = [UIFont boldSystemFontOfSize:16];
		userLabel.textColor = [UIColor colorWithRed:.10 green:.10 blue:.46 alpha:1.0];
		userLabel.backgroundColor = [UIColor clearColor];
		
		quipLabel =	[[[UILabel alloc] initWithFrame: CGRectMake(cell.indentationWidth - 6, (tableView.rowHeight - 22), tableView.bounds.size.width - 4.0 * cell.indentationWidth, LABEL_HEIGHT)] autorelease];
		[cell.contentView addSubview:quipLabel];
		quipLabel.tag = QUIP_LABEL_TAG;
		quipLabel.font = [UIFont systemFontOfSize:12];
		quipLabel.backgroundColor = [UIColor clearColor];
		quipLabel.textColor = [UIColor colorWithRed:.10 green:.10 blue:.46 alpha:1.0];

		dateLabel =	[[[UILabel alloc] initWithFrame: CGRectMake(18 * cell.indentationWidth, (tableView.rowHeight - 2 * LABEL_HEIGHT), tableView.bounds.size.width - 4.0 * cell.indentationWidth, LABEL_HEIGHT)] autorelease];
		[cell.contentView addSubview:dateLabel];
		dateLabel.tag = DATE_LABEL_TAG;
		dateLabel.font = [UIFont systemFontOfSize:13];
		dateLabel.backgroundColor = [UIColor clearColor];
    }
	else {
		//postLabel = (TTTAttributedLabel *)[cell viewWithTag:POST_LABEL_TAG];
		userLabel = (UILabel *)[cell viewWithTag:LABEL_TAG];
		quipLabel = (UILabel *)[cell viewWithTag:QUIP_LABEL_TAG];
		dateLabel = (UILabel *)[cell viewWithTag:DATE_LABEL_TAG];
	}
	NSString *postText = [postList objectAtIndex:[indexPath row]];
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN_X * 2), 20000.0f);
	
	CGSize size = [postText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	
	//[postLabel setText:postText];
	//NSLog(@"%d", [postsWithQuotes count]);
	/*NSLog(@"%d", [uniqueQuotes count]);
	for (int i = 0; i < [uniqueQuotes count]; i++) {
		if (indexPath.row == [[uniqueQuotes objectAtIndex:i] intValue]) {
			NSLog(@"test");
			[postLabel setText:postText afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSAttributedString *(NSMutableAttributedString *mutableAttributedString) {
				for (int k = 0; k < [quotes count]; k++) {

					NSRange boldRange = [[mutableAttributedString string] rangeOfString:[quotes objectAtIndex:k] options:NSCaseInsensitiveSearch];
					
					// Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
					UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14]; 
					CTFontRef font = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
					if (font) {
						[mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:boldRange];
						CFRelease(font);
					}
				}
				return mutableAttributedString;
			}];
		}
		else {
			[postLabel setText:postText afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSAttributedString *(NSMutableAttributedString *mutableAttributedString) {
				NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"this post was edited" options:NSCaseInsensitiveSearch];
				
				// Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
				UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14]; 
				CTFontRef font = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
				if (font) {
					[mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:boldRange];
					CFRelease(font);
				}
				
				return mutableAttributedString;
			}];
		}
	}*/

	//[postLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN_X, CELL_CONTENT_MARGIN_Y, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN_X * 2), MAX(size.height, 44.0f))];
	
	
	//update with threaded methods for each
	userLabel.text = [userNameList objectAtIndex:indexPath.row];
	dateLabel.text = [dateList objectAtIndex:indexPath.row];
	quipLabel.text = [quipList objectAtIndex:indexPath.row];
	
	//[postLabel setText:[postList objectAtIndex:indexPath.row]];
	//postLabel.text = [postList objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [postList objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	threadIDURL = nil;
	threadTitleString = nil;
	[postList release];
	[dateList release];
	[userNameList release];
	[quipList release];
	
	[replyList release];
}


- (void)dealloc {
	//[parser release];
	[dateList release];
	[quipList release];
	[userNameList release];
	[postList release];
	[operationQueue release];
	[super dealloc];

}


@end
