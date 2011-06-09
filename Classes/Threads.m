//
//  Threads.m
//  iWhirl
//
//  Created by mark wong on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 10.0f

#import "Threads.h"

@interface Threads (Internal)
- (void)beginLoadingThreadData;
- (void)synchronousLoadThreadData;

- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
@end
@implementation Threads

@synthesize forumID, indexPathRowNumber;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		//threading
		threadName = [[NSMutableArray alloc] init];
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
		}
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self beginLoadingThreadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
							   target:self
							   action:@selector(refresh:)];
	self.navigationItem.rightBarButtonItem = button;
	[button release];
}

- (void)refresh:(id)sender{
	/*Reload the page here*/
	[self beginLoadingThreadData];
}

- (void)beginLoadingThreadData {
	//threading
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadThreadData) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

- (void)synchronousLoadThreadData {
	//Whirlpool API request

	APIKey = [NSUserDefaults standardUserDefaults];
	
	APIKey = [NSUserDefaults standardUserDefaults];

	NSString *FullApi = [APIKey stringForKey:@"FULLAPI"];
	//NSLog(@"whirl_key %@", Whirl_Key_One);
	
	NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=threads&forumids=%@&output=json", FullApi, forumID];	
	//need to get thread ID
	
	//this is an example link http://forums.whirlpool.net.au/forum-replies.cfm?t=1220737&p=-1#bottom
	//get the thread ID.
	//save it to variable
	//put it in link below

	NSURL *url = [NSURL URLWithString:urlString];
	//get contents of the URL as a string and parse the JSON into Foundation Objects.
	NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [jsonString JSONValue];
	//NSLog(@"thread results: %@", results);
	[self performSelectorOnMainThread:@selector(didFinishLoadingThreadDataWithResults:) withObject:results waitUntilDone:NO];
}

- (void)didFinishLoadingThreadDataWithResults:(NSDictionary *)results {
	
	NSArray *threadList = [results valueForKeyPath:@"THREADS"];
	NSString *targetThreadTitle;
	NSString *targetThreadId;
	NSString *targetThreadReplies;
	threadTitle = [[NSMutableArray alloc] init];
	threadID = [[NSMutableArray alloc] init];
	threadReplies = [[NSMutableArray alloc] init];
	
	int i = 0;
	
	//getting the title of each thread
	for (i = 0; i < [threadList count]; i++) {
		targetThreadTitle = [[threadList objectAtIndex:i] objectForKey:@"TITLE"];//objectForKey is needed because of the JSON format
		targetThreadId = [[threadList objectAtIndex:i] objectForKey:@"ID"];
		targetThreadReplies = [[threadList objectAtIndex:i] objectForKey:@"REPLIES"];
		[threadID addObject:targetThreadId];
		[threadTitle addObject:targetThreadTitle];
		[threadReplies addObject:targetThreadReplies];
	}
	[self.tableView reloadData];
	[self.tableView flashScrollIndicators];
}

- (void)showLoadingIndicators {
	if(!spinner) {
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[spinner startAnimating];
		
		static CGFloat bufferWidth = 8.0;
		
		CGFloat totalWidth = spinner.frame.size.width + bufferWidth + loadingLabel.frame.size.width;
		
		CGRect spinnerFrame = spinner.frame;
		spinnerFrame.origin.x = (self.tableView.bounds.size.width - totalWidth) / 2.0;
		spinnerFrame.origin.y = (self.tableView.bounds.size.width - spinnerFrame.size.height) / 2.0;
		spinner.frame = spinnerFrame;
		[self.tableView addSubview:spinner];
	}
}

- (void)hideLoadingIndicators {
	if(spinner) {
		[spinner stopAnimating];
		[spinner removeFromSuperview];
		[spinner release];
		spinner = nil;
		
		[loadingLabel removeFromSuperview];
		[loadingLabel release];
		loadingLabel = nil;
	}
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"count %i", [threadTitle count]);
    return [threadTitle count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[Gradient alloc] init] autorelease];
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.textLabel.numberOfLines = 2;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		cell.textLabel.textColor = [UIColor colorWithRed:.10 green:.10 blue:.46 alpha:1.0];

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Set up the cell...

	cell.textLabel.text = [threadTitle objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Replies: %@ ", [threadReplies objectAtIndex:indexPath.row]];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	threadContent = [[ThreadContent alloc] init];

	threadContent.threadIDURL = [threadID objectAtIndex:indexPath.row];
	threadContent.threadTitleString = [threadTitle objectAtIndex:indexPath.row];
	NSLog(@"%@", threadContent.threadTitleString);
	threadContent.firstLoad = TRUE;
	[self.navigationController pushViewController:threadContent animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *text = [threadTitle objectAtIndex:indexPath.row];
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat height = MAX(size.height, 44.0f);
	
	return height + (CELL_CONTENT_MARGIN * 2);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	//[threadName release];
	[threadReplies release];
	[operationQueue release];
	[threadTitle release];
	[threadID release];
	[threadName release];
    [super dealloc];
}


@end

