//
//  ForumIndexedView.m
//  iWhirl
//
//  Created by mark wong on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "ForumIndexedView.h"
#import "Threads.h"

@interface ForumIndexedView (Internal)
- (void)beginLoadingForumData;
- (void)synchronousLoadForumData;

- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
@end
@implementation ForumIndexedView


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.title = @"Forums";
		self.tabBarItem.image = [UIImage imageNamed:@"Forum.png"];
		
		forumName = [[NSMutableArray alloc] init];
		forumURL = [[NSMutableArray alloc] init];
		uniqueSections = [[NSArray alloc] init];

		//threading
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:2];
		
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self showLoadingIndicators];
	[self beginLoadingForumData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = 45;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0/255 green:80.0/255 blue:123.0/255 alpha:1.0];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	self.navigationController.navigationBar.translucent = YES;

}

- (void)beginLoadingForumData {
	//threading
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadForumData) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

- (void)synchronousLoadForumData {
	//Whirlpool API request
	/*THREADS FOR FEEDBACK*/

	NSString *Whirl_Key_One;
	NSString *Whirl_Key_Two;
	NSString *Whirl_Key_Three;
	NSString *FullApi;
	APIKey = [NSUserDefaults standardUserDefaults];

	FullApi = [APIKey stringForKey:@"FULLAPI"];
	
	NSLog(@"FullApi %@", FullApi);
	
	NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=forum&output=json", FullApi];
	NSURL *url = [NSURL URLWithString:urlString];
	NSError *error;
	//get contents of the URL as a string and parse the JSON
	NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
	/*if( url )
	{
		NSLog(@"Text=%@", url);
	}
	else 
	{
		NSLog(@"Error = %@", error);
	}*/
	NSDictionary *results = [jsonString JSONValue];
	[self performSelectorOnMainThread:@selector(didFinishLoadingForumDataWithResults:) withObject:results waitUntilDone:YES];
}

- (void)didFinishLoadingForumDataWithResults:(NSDictionary *)results {
	
	//doing is this way can grab the section/id/sort/title by changing the objectForKey
	//what am i trying to get? The Title of the subforums
	NSArray *Forum = [results valueForKeyPath:@"FORUM"];

	sectionTitles = [[NSMutableArray alloc] init];
	forumNames = [[NSMutableArray alloc] init];
	forumID = [[NSMutableArray alloc] init];
	for (int i = 0; i < [Forum count]; i++) {
		[sectionTitles addObject:[[Forum objectAtIndex:i] objectForKey:@"SECTION"]];
		[forumNames addObject:[[Forum objectAtIndex:i] objectForKey:@"TITLE"]];
		[forumID addObject:[[Forum objectAtIndex:i] objectForKey:@"ID"]];
	}
	
	NSSet *unique = [NSSet setWithArray:sectionTitles];

	uniqueSections = [[unique allObjects] mutableCopy];

	dataDict = [[NSMutableDictionary alloc] init];
	dataID = [[NSMutableDictionary alloc] init];
	
	for (int i = 0; i < [uniqueSections count]; i++) {

		NSMutableArray *addNames = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *addID = [[[NSMutableArray alloc] init] autorelease];
		for (int j = 0; j < [sectionTitles count]; j++) {
			if ([[uniqueSections objectAtIndex:i] isEqualToString: [sectionTitles objectAtIndex:j]]) {
				[addNames addObject:[forumNames objectAtIndex:j]];
				[addID addObject:[forumID objectAtIndex:j]];
			}
		}
		[dataDict setValue:addNames forKey:[uniqueSections objectAtIndex:i]];
		[dataID setValue:addID forKey:[uniqueSections objectAtIndex:i]];
		addNames = NULL;
		addID = NULL;
	}

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
    return [uniqueSections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [uniqueSections objectAtIndex:section];
}   


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *stateKey = [uniqueSections objectAtIndex:section];
	return [[dataDict objectForKey:stateKey] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[Gradient alloc] init] autorelease];
		cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    // Set up the cell...
	NSString *sectionForRow = [uniqueSections objectAtIndex:indexPath.section];
	NSArray *arrayForSection = [dataDict objectForKey:sectionForRow];
	NSString *titleRow = [arrayForSection objectAtIndex:indexPath.row];
	cell.textLabel.text = titleRow;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.textColor = [UIColor colorWithRed:.10 green:.10 blue:.46 alpha:1.0];
	
	return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
	[headerView setBackgroundColor:[UIColor colorWithRed:.60 green:.66 blue:.80 alpha:1.0]];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];

	label.textColor = [UIColor whiteColor];
	
	label.text = [uniqueSections objectAtIndex:section];
	label.backgroundColor = [UIColor clearColor];
	[headerView addSubview:label];
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	threads = [[Threads alloc] initWithStyle:UITableViewStylePlain];

	NSString *sectionForRow = [uniqueSections objectAtIndex:indexPath.section];
	NSArray *arrayForSectionID = [dataID objectForKey:sectionForRow];
	NSArray *arrayForSectionTitle = [dataDict objectForKey:sectionForRow];
	NSString *titleRowID = [arrayForSectionID objectAtIndex:indexPath.row];

	threads.forumID = titleRowID;

	[threads setTitle:[arrayForSectionTitle objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:threads animated:YES];

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
	[forumURL release];
	[forumName release];
	[operationQueue release];
	[uniqueSections release];
	//[subForums release];
    [super dealloc];
	[threads release];
	
}


@end
