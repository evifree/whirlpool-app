//
//  WhimContent.m
//  iWhirl
//
//  Created by mark wong on 18/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WhimContent.h"

@interface WhimContent (Internal)
- (UITableViewCell*)CreateMultilinesCell:(NSString *)cellIdentifier;
- (void)beginLoadingWhimContentData;
- (void)synchronousLoadWhimContentData;

- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
- (int) heightOfCellWithTitle :(NSString*)subtitleText;
@end

@implementation WhimContent

@synthesize indexPathRowNumber, whimID, whimIDURL;

#define CONST_Cell_height 400.0f
#define CONST_Cell_width 270.0f

#define CONST_textLabelFontSize     16
#define CONST_detailLabelFontSize   16



static UIFont *titleFont;
static UIFont *subFont;
#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		//NSString *whimBody;
		operationQueueWC = [[NSOperationQueue alloc] init];
		[operationQueueWC setMaxConcurrentOperationCount:1];
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self showLoadingIndicators];
	[self beginLoadingWhimContentData];
}

- (void)beginLoadingWhimContentData {
	//threading
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadWhimContentData) object:nil];
	[operationQueueWC addOperation:operation];
	[operation release];
}

- (void)synchronousLoadWhimContentData {
	//Whirlpool API request
	/*whims will get the user's whim inbox with the full body text of read and unread messages. To mark a message as being read, use the whim API call.
	 whim will return the content of a specific whim, and mark it as read. Parameter whimid specifies the ID.*/
	
	NSString *fullAPIKey;
	
	APIKey = [NSUserDefaults standardUserDefaults];
	fullAPIKey = [APIKey stringForKey:@"FULLAPI"];
	
	//NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=whims&output=json", WhirlpoolAPI];
	NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=whim&whimid=%@&output=json", fullAPIKey, whimIDURL];
	//NSLog(@"whimID %@", whimRead);
	NSURL *url = [NSURL URLWithString:urlString];
	//get contents of the URL as a string and parse the JSON into Foundation Objects.
	NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [jsonString JSONValue];
	[self performSelectorOnMainThread:@selector(didFinishLoadingWhimContentDataWithResults:) withObject:results waitUntilDone:NO];
}

- (void)didFinishLoadingWhimContentDataWithResults:(NSDictionary *)results {
	//NSLog(@"DEBUG: results %@", results);
	//extract data from "results"
	NSArray *whimList = [results valueForKeyPath:@"WHIM"];
	//NSLog(@"DEBUG: whim: %@", whimList);
	whimContentMessageArray = [[NSMutableArray alloc] init];
	
	[whimContentMessageArray addObject:[[whimList objectAtIndex:0] objectForKey:@"BODY"]];
	//NSLog(@"whimContentMessageArray %@", whimContentMessageArray);
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

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
	
    if (0)
    {
        return path;
    }
	
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//return MIN([titleArray count], [blurbArray count]);

    return 1;//MIN([whimContentMessageArray count]);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [self CreateMultilinesCell:CellIdentifier];
		//cell.detailTextLabel.text = whimBody;
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    

    // Configure the cell...
	cell.detailTextLabel.text = [whimContentMessageArray objectAtIndex:0];
	//NSLog(@"whimbody3 %@", [whimContentMessageArray objectAtIndex:0]);
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	subtitle = [whimContentMessageArray objectAtIndex:0];
	//NSLog(@"whimBody2 %@", subtitle);
	//subtitle = [blurbArray objectAtIndex:indexPath.row];
	
	int height = [self heightOfCellWithTitle:subtitle]; //andSubtitle:subtitle];
	return height;//(height < CONST_Cell_height ? CONST_Cell_height : height);
}

//font

- (UIFont*) TitleFont;
{
	if (!titleFont) titleFont = [UIFont systemFontOfSize:CONST_textLabelFontSize];
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
	cell.detailTextLabel.numberOfLines = 0;
	cell.detailTextLabel.font = [self SubFont];
	cell.detailTextLabel.textColor = [UIColor colorWithRed:10.0/255 green:10.0/255 blue:33.0/255 alpha:1.0];
	//[cell setBackgroundColor:[UIColor colorWithRed:.98 green:.98 blue:.99 alpha:1.0]];
	//[self.tableView setBackgroundColor:[UIColor colorWithRed:.80 green:.74 blue:.69 alpha:1.0]];
	
	//cell.detailTextLabel.numberOfLines = 0;
	//cell.detailTextLabel.font = [self SubFont];
	//cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
	return cell;
}

//height of cell

- (int) heightOfCellWithTitle :(NSString*)subtitleText 
{
	//CGSize titleSize = {0, 0};
	CGSize subtitleSize = {0, 0};
	//NSLog(@"heightOfCellWithTitle");
	/*if (titleText && ![titleText isEqualToString:@""]) //if it is empty
		subtitleSize = [titleText sizeWithFont:[self SubFont] 
						  constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
							  lineBreakMode:UILineBreakModeWordWrap];*/
	
	if (subtitleText && ![subtitleText isEqualToString:@""]) 
		subtitleSize = [subtitleText sizeWithFont:[self SubFont] 
								constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
									lineBreakMode:UILineBreakModeWordWrap];
	
	return subtitleSize.height;// + subtitleSize.height;
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
	[operationQueueWC release];
	[whimID release];
	[whimContentMessageArray release];
    [super dealloc];
}


@end

