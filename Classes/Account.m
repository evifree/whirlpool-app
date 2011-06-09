//
//  Account.m
//  iWhirl
//
//  Created by mark wong on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
//#import "iWhirlAppDelegate.h"
@implementation Account
//http://whirlpool.net.au/profile/index.cfm?action=login

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Account";
		self.tabBarItem.image = [UIImage imageNamed:@"Account.png"];
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];

    }
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//UILabel *dashOne;
	//UILabel *dashTwo;
	UILabel *EnterAPI;
	UILabel *user;
	UILabel *pass;
	
	APIKey = [NSUserDefaults standardUserDefaults];

	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0/255 green:80.0/255 blue:123.0/255 alpha:1.0];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	self.navigationController.navigationBar.translucent = YES;
	EnterAPI = [[UILabel alloc] initWithFrame:CGRectMake(145, 60, 90.0, 25.0)];
	//dashOne = [[UILabel alloc] initWithFrame:CGRectMake(115, 100, 90.0, 25.0)];
	//dashTwo = [[UILabel alloc] initWithFrame:CGRectMake(215, 100, 90.0, 25.0)];
	user = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 90.0, 25.0)];
	pass = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 90.0, 25.0)];
	
	API = [[UITextField alloc] initWithFrame:CGRectMake(45, 100, 230, 25)];
	//firstPartAPI = [[UITextField alloc] initWithFrame:CGRectMake(40, 100, 65, 25)];
	//secondPartAPI = [[UITextField alloc] initWithFrame:CGRectMake(130, 100, 75, 25)];
	//thirdPartAPI = [[UITextField alloc] initWithFrame:CGRectMake(230, 100, 50, 25)];
	userTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 150, 150, 25)];
	passTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 190, 150, 25)];
	
	EnterAPI.textColor = [UIColor blackColor];
	EnterAPI.backgroundColor = [UIColor whiteColor];
	EnterAPI.text = @"API";
	/*
	dashOne.textColor = [UIColor blackColor];
	dashOne.backgroundColor = [UIColor whiteColor];
	dashOne.text = @"-";
	
	dashTwo.textColor = [UIColor blackColor];
	dashTwo.backgroundColor = [UIColor whiteColor];
	dashTwo.text = @"-";
	*/
	user.textColor = [UIColor blackColor];
	user.backgroundColor = [UIColor whiteColor];
	user.text = @"user";
	
	pass.textColor = [UIColor blackColor];
	pass.backgroundColor = [UIColor whiteColor];
	pass.text = @"pass";
	
	[self.view addSubview:user];
	[self.view addSubview:EnterAPI];
	//[self.view addSubview:dashOne];
	//[self.view addSubview:dashTwo];
	[self.view addSubview:pass];
	
	passTF.borderStyle = UITextBorderStyleRoundedRect;
	passTF.textColor = [UIColor blackColor]; //text color
	passTF.font = [UIFont systemFontOfSize:17.0];  //font size
	passTF.backgroundColor = [UIColor whiteColor]; //background color
	passTF.autocorrectionType = UITextAutocorrectionTypeNo;
	passTF.secureTextEntry = YES;
	passTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	userTF.borderStyle = UITextBorderStyleRoundedRect;
	userTF.textColor = [UIColor blackColor]; //text color
	userTF.font = [UIFont systemFontOfSize:17.0];  //font size
	userTF.backgroundColor = [UIColor whiteColor]; //background color
	userTF.autocorrectionType = UITextAutocorrectionTypeNo;
	userTF.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
	userTF.returnKeyType = UIReturnKeyDone;  // type of the return key
	userTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	/*
	if ([APIKey stringForKey:@"APIONE"] == NULL || [APIKey stringForKey:@"APITWO"] == NULL || [APIKey stringForKey:@"APITHREE"] == NULL) {
		firstPartAPI.placeholder = @"00000";  //place holder
		secondPartAPI.placeholder = @"000000";  //place holder
		thirdPartAPI.placeholder = @"000";  //place holder
	}
	else {
		firstPartAPI.placeholder = [APIKey stringForKey:@"APIONE"];  //place holder
		secondPartAPI.placeholder = [APIKey stringForKey:@"APITWO"];  //place holder
		thirdPartAPI.placeholder = [APIKey stringForKey:@"APITHREE"];  //place holder
	}*/
/*
	firstPartAPI.borderStyle = UITextBorderStyleRoundedRect;
	firstPartAPI.textColor = [UIColor blackColor]; //text color
	firstPartAPI.font = [UIFont systemFontOfSize:17.0];  //font size
	firstPartAPI.backgroundColor = [UIColor whiteColor]; //background color
	firstPartAPI.autocorrectionType = UITextAutocorrectionTypeNo;
	firstPartAPI.keyboardType = UIKeyboardTypeNumberPad;  // type of the keyboard
	firstPartAPI.returnKeyType = UIReturnKeyDone;  // type of the return key
													   //firstPartAPI.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	secondPartAPI.borderStyle = UITextBorderStyleRoundedRect;
	secondPartAPI.textColor = [UIColor blackColor]; //text color
	secondPartAPI.font = [UIFont systemFontOfSize:17.0];  //font size
	secondPartAPI.backgroundColor = [UIColor whiteColor]; //background color
	secondPartAPI.autocorrectionType = UITextAutocorrectionTypeNo;
	secondPartAPI.keyboardType = UIKeyboardTypeNumberPad;  // type of the keyboard
	secondPartAPI.returnKeyType = UIReturnKeyDone; 
	
	thirdPartAPI.borderStyle = UITextBorderStyleRoundedRect;
	thirdPartAPI.textColor = [UIColor blackColor]; //text color
	thirdPartAPI.font = [UIFont systemFontOfSize:17.0];  //font size
	thirdPartAPI.backgroundColor = [UIColor whiteColor]; //background color
	thirdPartAPI.autocorrectionType = UITextAutocorrectionTypeNo;
	thirdPartAPI.keyboardType = UIKeyboardTypeNumberPad;  // type of the keyboard
	thirdPartAPI.returnKeyType = UIReturnKeyDone; 	
	
	firstPartAPI.delegate = self;
	secondPartAPI.delegate = self;
	thirdPartAPI.delegate = self;*/	
	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	passTF.delegate = self;
	//userTF.delegate = self;
	
	API.borderStyle = UITextBorderStyleRoundedRect;
	API.textColor = [UIColor blackColor]; //text color
	API.font = [UIFont systemFontOfSize:17.0];  //font size
	API.backgroundColor = [UIColor whiteColor]; //background color
	API.textAlignment = UITextAlignmentCenter;
	[API setEnabled:NO];
	
	[self.view addSubview:passTF];
	[self.view addSubview:userTF];
	//[self.view addSubview:firstPartAPI];
	//[self.view addSubview:secondPartAPI];
	//[self.view addSubview:thirdPartAPI];
	[self.view addSubview:API];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];		
	} else {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	}
	
	//username and password
	/*NSString * postString = [NSString stringWithFormat: @"user_id=%@&password=%@",theUserName,thePassword];
	 NSData *myRequestData = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
	 NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString: @"http://www.theaddress.com"]]; 
	 [request setHTTPMethod:@"POST"];
	 [request setHTTPBody:myRequestData];
	 NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	 [request release];*/
	
	
	//[dashOne release];
	//[dashTwo release];
	[EnterAPI release];
}

- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
	}
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	//[userTF resignFirstResponder];
	[passTF resignFirstResponder];
	return YES;
}

- (void) checkMaintenance {
	//NSLog(@"test1");
	NSString *offlineurl = [NSString stringWithFormat:@"http://whirlpool.net.au"];
	NSURL *offline = [NSURL URLWithString:offlineurl];	
	NSString *offlinehtml = [NSString stringWithContentsOfURL:offline encoding:NSUTF8StringEncoding error:nil];
	//NSLog(@"test2");
	DocumentRoot *offlinedocument = [Element parseHTML:offlinehtml];
	//NSLog(@"%@", offlinedocument);
	NSString *maintenance = [[offlinedocument selectElement:@"head title"] contentsText];
	//NSLog(@"test %@");
	if ([maintenance isEqualToString:@"Whirlpool is offline"]) {
		NSLog(@"WP is offline");
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Maintenance" message: @"Could not retreive API" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
	}
	else {
		NSLog(@"maintenance %@", maintenance);
		
	}
}

-(void)textFieldDidEndEditing:(UITextField *)textField {	

	NSString * postString = [NSString stringWithFormat: @"user=%@&pass=%@", userTF.text, passTF.text];
	NSData *myRequestData = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString: @"http://whirlpool.net.au/profile/index.cfm?action=login"]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:myRequestData];
	[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	[request release];
	
	NSString *urlThreadID = [NSString stringWithFormat:@"http://whirlpool.net.au/profile/"];
	NSURL *urlThread = [NSURL URLWithString:urlThreadID];	
	NSString *html = [NSString stringWithContentsOfURL:urlThread encoding:NSUTF8StringEncoding error:nil];
	
	//NSLog(@"html %@", html);
	DocumentRoot *document = [Element parseHTML:html];
	NSString *APIExp = @"div#root div#profile td.fauxvalue span#serialno";
	NSString * fullAPIKey = [[document selectElement:APIExp] contentsText];
	NSLog(@"api: %@", fullAPIKey);
	if (fullAPIKey == NULL) {
		//NSLog(@"Incorrect Login");
			UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Login Error" message: @"Could not retreive API" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			[someError show];
			[someError release];
	}
	else {
		
		[APIKey setObject:fullAPIKey forKey:@"FULLAPI"];
		[APIKey synchronize];
		//NSLog(@"response %@", response);
		API.placeholder = fullAPIKey;
		NSString *urlString = [NSString stringWithFormat:@"http://whirlpool.net.au/api/?key=%@&get=whims&output=json", fullAPIKey];
		NSURL *url = [NSURL URLWithString:urlString];
		NSError *error = nil;
		//get contents of the URL as a string and parse the JSON into Foundation Objects.
		NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
		
		if( [jsonString isEqualToString:@"Bad API Key"] && [thirdPartAPI.text length] > 0 && [firstPartAPI.text length] > 0 && [secondPartAPI.text length] > 0)
		{
			UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"API-Key error" message: @"Bad API Key" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			[someError show];
			[someError release];
		}
		else 
		{
			UIAlertView *welcome = [[UIAlertView alloc] initWithTitle: @"Welcome to Whirlpool" message: @"API Key is Valid" delegate:self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			[welcome show];
			[welcome release];
		}
	}
	//NSLog(@"profile: %@", fullAPIKey);
	

}

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


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[firstPartAPI release];
	[thirdPartAPI release];
	[secondPartAPI release];

    [super dealloc];
}


@end
