//
//  Whims.m
//  iWhirl
//
//  Created by mark wong on 16/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Whims.h"
@interface Whims (Internal)
- (void)beginLoadingWhimData;
- (void)synchronousLoadWhimData;
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
@end
@implementation Whims


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.title = @"Whims";
		self.tabBarItem.image = [UIImage imageNamed:@"Whims.png"];

		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0/255 green:80.0/255 blue:123.0/255 alpha:1.0];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
							   target:self
							   action:@selector(refresh:)];
	self.navigationItem.rightBarButtonItem = button;
	[button release];
	//self.navigationItem.rightBarButtonItem = segmentBarItem;//segmentBarItem;
	//[segmentBarItem release];
}

- (void)refresh:(id)sender{
	//[self.tableView reloadData];
	[self beginLoadingWhimData];

	//NSLog(@"REFRESH ACTION");
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self showLoadingIndicators];
	[self beginLoadingWhimData];
}

- (void)beginLoadingWhimData {
	//threading
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadWhimData) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

- (void)synchronousLoadWhimData {
	//Whirlpool API request
	/*whims will get the user's whim inbox with the full body text of read and unread messages. To mark a message as being read, use the whim API call.
	whim will return the content of a specific whim, and mark it as read. Parameter whimid specifies the ID.*/
	
	/*THREADS FOR FEEDBACK
	 NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=threads&forumids=35&output=json", WhirlpoolAPI];
	 */
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://whirlpool.net.au/api/?key=%@&get=forum&output=json"]];
	NSString *Whirl_Key_One;
	NSString *Whirl_Key_Two;
	NSString *Whirl_Key_Three;
	NSString *fullAPIKey;
	APIKey = [NSUserDefaults standardUserDefaults];
	Whirl_Key_One = [APIKey stringForKey:@"APIONE"];
	Whirl_Key_Two = [APIKey stringForKey:@"APITWO"];
	Whirl_Key_Three = [APIKey stringForKey:@"APITHREE"];
	fullAPIKey = [APIKey stringForKey:@"FULLAPI"];
	
	NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=whims&output=json", fullAPIKey];
	NSURL *url = [NSURL URLWithString:urlString];
	//get contents of the URL as a string and parse the JSON into Foundation Objects.
	NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [jsonString JSONValue];
	[self performSelectorOnMainThread:@selector(didFinishLoadingWhimDataWithResults:) withObject:results waitUntilDone:NO];
}

- (void)didFinishLoadingWhimDataWithResults:(NSDictionary *)results {
	//NSLog(@"DEBUG: results %@", results);
	//extract data from "results"
	NSArray *whimList = [results valueForKeyPath:@"WHIMS"];
	//NSLog(@"DEBUG: whim: %@", whimList);
	whimIDArray = [[NSMutableArray alloc] init];
	whimViewedArray = [[NSMutableArray alloc] init];
	whimMessageArray = [[NSMutableArray alloc] init];
	whimNameArray = [[NSMutableArray alloc] init];
	whimFromArray = [[NSMutableArray alloc] init];

	//loop and grab keys for each type
	for (int i = 0; i < [whimList count]; i++) {
		[whimMessageArray addObject:[[whimList objectAtIndex:i] objectForKey:@"MESSAGE"]];
		[whimIDArray addObject:[[whimList objectAtIndex:i] objectForKey:@"ID"]];
		[whimViewedArray addObject:[[whimList objectAtIndex:i] objectForKey:@"VIEWED"]];
		[whimFromArray addObject:[[whimList objectAtIndex:i] objectForKey:@"FROM"]];
		[whimNameArray addObject:[[whimFromArray objectAtIndex:i] objectForKey:@"NAME"]];
	}
	//NSLog(@"whimViewedArray %@", whimViewedArray);
	[self hideLoadingIndicators];
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [whimIDArray count];
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
    }
	NSNumber *truth = [whimViewedArray objectAtIndex:indexPath.row];
	//NSLog(@"%@", truth);
	if ([truth intValue] == 0) {
		//NSLog(@"DEBUG: THIS IS A NEW MESSAGE");
		[cell setBackgroundColor:[UIColor colorWithRed:.95 green:.60 blue:.25 alpha:1.0]];
		cell.textLabel.text = [NSString stringWithFormat:@"FROM: %@",[whimNameArray objectAtIndex:indexPath.row]];
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		cell.detailTextLabel.text = [whimMessageArray objectAtIndex:indexPath.row];
		cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		//cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	}
	else if([whimViewedArray objectAtIndex:indexPath.row]) {
		//NSLog(@"DEBUG: THIS IS A READ MESSAGE");
		[cell setBackgroundColor:[UIColor colorWithRed:.96 green:.96 blue:.97 alpha:1.0]];
		cell.textLabel.text = [NSString stringWithFormat:@"FROM: %@",[whimNameArray objectAtIndex:indexPath.row]];
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		cell.detailTextLabel.text = [whimMessageArray objectAtIndex:indexPath.row];
		//	cell.detailTextLabel.text = [NSString stringWithFormat:@"Replies: %@ ", [threadReplies objectAtIndex:indexPath.row]];
		
		cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		//cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	}
    // Configure the cell...
	//NSLog(@"whimViewedArray %@", [whimViewedArray objectAtIndex:indexPath.row]);

	cell.textLabel.textColor = [UIColor colorWithRed:50.0/255 green:30.0/255 blue:100.0/255 alpha:1.0];
	//[tableView setBackgroundColor:[UIColor colorWithRed:.80 green:.74 blue:.69 alpha:1.0]];

	
	return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	whimContent = [[WhimContent alloc] init];//WithStyle:UITableViewStyleGrouped];
	//whimContent.indexPathRowNumber = indexPath.row;
	whimContent.whimIDURL = [whimIDArray objectAtIndex:indexPath.row];
		//threadContent.threadIDURL
	whimContent.whimID = whimIDArray;
	[whimContent setTitle:[whimNameArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:whimContent animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[operationQueue release];
	
	[whimContent release];
	[whimIDArray release];
	[whimFromArray release];
	[whimMessageArray release];
	[whimNameArray release];
	[whimViewedArray release];	
    [super dealloc];
}


@end

