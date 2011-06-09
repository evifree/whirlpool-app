//
//  News.m
//  iWhirl
//
//  Created by mark wong on 16/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "News.h"


#define CONST_Cell_height 44.0f
#define CONST_Cell_width 270.0f

#define CONST_textLabelFontSize     18
#define CONST_detailLabelFontSize   16

@interface News (Internal)
- (UITableViewCell*)CreateMultilinesCell:(NSString *)cellIdentifier;
- (void)beginLoadingForumData;
- (void)synchronousLoadForumData;

- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
- (int) heightOfCellWithTitle :(NSString*)titleText 
				   andSubtitle:(NSString*)subtitleText;
@end

@implementation News
//@synthesize uniqueDates;

static UIFont *subFont;
static UIFont *titleFont;



#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.title = @"News";
		self.tabBarItem.image = [UIImage imageNamed:@"News.png"];

		//ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
		//uniqueDates = [[NSSet alloc] init];
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self showLoadingIndicators];
	[self beginLoadingForumData];
}

#pragma mark -
#pragma mark View lifecycle

- (void)beginLoadingForumData {
	//threading
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadForumData) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

- (void)synchronousLoadForumData {

	NSString *fullAPIKey;
	
	APIKey = [NSUserDefaults standardUserDefaults];
	fullAPIKey = [APIKey stringForKey:@"FULLAPI"];
	
	NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=news&output=json", fullAPIKey];
	NSURL *url = [NSURL URLWithString:urlString];
	NSError *error;
	//get contents of the URL as a string and parse the JSON
	NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];	
	NSDictionary *results = [jsonString JSONValue];
	//NSLog(@"SYNCTEST");
	[self performSelectorOnMainThread:@selector(didFinishLoadingForumDataWithResults:) withObject:results waitUntilDone:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tableView.rowHeight = 60;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0/255 green:80.0/255 blue:123.0/255 alpha:1.0];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	self.navigationController.navigationBar.translucent = YES;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didFinishLoadingForumDataWithResults:(NSDictionary *)results {
	newsList = [results valueForKeyPath:@"NEWS"];
	//NSLog(@"news %@", newsList);
	
	NSMutableArray *dateArray2 = [[NSMutableArray alloc] init];
	blurbArray = [[NSMutableArray alloc] init];
	titleArray = [[NSMutableArray alloc] init];
	newsIDArray = [[NSMutableArray alloc] init];
	//For the Dates
	ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
	uniqueDates = [[NSSet alloc] init];
	NSString *dateFromList;
	NSDate *theDate;
	NSDateFormatter *shorterDate = [[NSDateFormatter alloc] init];
	NSString *dateString;
	//NSArray *arrayDate = [[NSArray alloc] init];
	
	for(int i = 0; i < [newsList count]; i++) {
		//get date from the list
		dateFromList = [[newsList objectAtIndex:i] objectForKey:@"DATE"];
		//format for the date to ISO8601
		theDate = [formatter dateFromString:dateFromList];
		//change date to shorter form
		[shorterDate setDateStyle:NSDateFormatterMediumStyle];
		dateString = [shorterDate stringFromDate:theDate];

		//put the date into an array
		[dateArray2 addObject:dateString];
	}
	[shorterDate release];
	//get today's date
	uniqueDates = [NSSet setWithArray:dateArray2];

	//get today's news articles
	for (int i = 0; i < [newsList count]; i++) {

		titleOfNews = [[newsList objectAtIndex:i] objectForKey:@"TITLE"];
		[titleArray addObject:titleOfNews];
		blurb = [[newsList objectAtIndex:i] objectForKey:@"BLURB"];
		//[blurbArray2 addObject:blurb];
		[blurbArray addObject:blurb];
		newsID = [[newsList objectAtIndex:i] objectForKey:@"ID"];
		[newsIDArray addObject:newsID];

	}
	
	//newsIDArray = newsIDArray2;
	//NSLog(@"newsIDArray %@", newsIDArray);
	//blurbArray = blurbArray2;
	//titleArray = titleArray2;
	//NSLog(@"DEBUG: Arraytest %@", titleArray);
	
	//[self grabDate];
	[self hideLoadingIndicators];
	[self.tableView reloadData];
	[self.tableView flashScrollIndicators];
	[dateArray2 release];
	[formatter release];
	//[shorterDate release];
	//[arrayDate release];
	//[blurbArray2 release];
	//[titleArray2 release];
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
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;

	if(section == 0) {
		sectionHeader = todaysDate;
	}
	return sectionHeader;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return MIN([titleArray count], [blurbArray count]);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    //NSLog(@"DEBUG: CELLtest");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [self CreateMultilinesCell:CellIdentifier];
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [blurbArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	titleStr = [titleArray objectAtIndex:indexPath.row];
	subtitle = [blurbArray objectAtIndex:indexPath.row];
	
	int height = 10 + [self heightOfCellWithTitle:titleStr andSubtitle:subtitle];
	return (height < CONST_Cell_height ? CONST_Cell_height : height);
}

//font

- (UIFont*) TitleFont;
{
	if (!titleFont) titleFont = [UIFont boldSystemFontOfSize:CONST_textLabelFontSize];
	return titleFont;
}

- (UIFont*) SubFont;
{
	if (!subFont) subFont = [UIFont systemFontOfSize:CONST_detailLabelFontSize];
	return subFont;
}

- (UITableViewCell*) CreateMultilinesCell :(NSString*)cellIdentifier
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
													reuseIdentifier:cellIdentifier] autorelease];
	cell.backgroundView = [[[Gradient alloc] init] autorelease];
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [self TitleFont];
	cell.textLabel.textColor = [UIColor colorWithRed:65.0/255 green:80.0/255 blue:123.0/255 alpha:1.0];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	//[cell setBackgroundColor:[UIColor colorWithRed:.98 green:.98 blue:.99 alpha:1.0]];
	//[self.tableView setBackgroundColor:[UIColor colorWithRed:.80 green:.74 blue:.69 alpha:1.0]];

	cell.detailTextLabel.numberOfLines = 0;
	cell.detailTextLabel.font = [self SubFont];
	cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	return cell;
}

//height of cell

- (int) heightOfCellWithTitle :(NSString*)titleText 
				   andSubtitle:(NSString*)subtitleText
{
	CGSize titleSize = {0, 0};
	CGSize subtitleSize = {0, 0};
	//NSLog(@"heightOfCellWithTitle");
	if (titleText && ![titleText isEqualToString:@""]) //if it is empty
		titleSize = [titleText sizeWithFont:[self TitleFont] 
						  constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
							  lineBreakMode:UILineBreakModeWordWrap];
	
	if (subtitleText && ![subtitleText isEqualToString:@""]) 
		subtitleSize = [subtitleText sizeWithFont:[self SubFont] 
								constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
									lineBreakMode:UILineBreakModeWordWrap];
	
	return titleSize.height + subtitleSize.height;
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
	//NSLog(@"TEST");
	newsArticle = [[NewsArticle alloc] init];

	newsArticle.newsIDURL = [newsIDArray objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:newsArticle animated:YES];
	
	//http://whirlpool.net.au/news/go.cfm?article=51353 webview link 51353 = id
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
	[newsArticle release];
	[blurb release];
	[titleOfNews release];
	[newsID release];
	[subtitle release];
	[todaysDate release];

	[newsList release];
	[titleArray release];
	[blurbArray release];
	[newsIDArray release];
	[dateArray release];
	[operationQueue release];
    [super dealloc];
}


@end

