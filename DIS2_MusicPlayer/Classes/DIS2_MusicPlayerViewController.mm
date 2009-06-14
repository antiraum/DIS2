//
//  DIS2_MusicPlayerViewController.m
//  DIS2_MusicPlayer
//
//  Created by Jonathan Simon on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "DIS2_MusicPlayerViewController.h"
#import <AudioToolbox/AudioFile.h>

@implementation DIS2_MusicPlayerViewController




// The designated initializer. Override to perform setup that is required before the view is loaded.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//		// custom initialization
//	}
//    return self;
//}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray* files = [[NSFileManager defaultManager] directoryContentsAtPath:[[NSBundle mainBundle] bundlePath]];
	music = [NSMutableArray arrayWithCapacity:[files count] - 5];
	
	for(int i = 0; i < [files count]; i++) {
		NSString* filename = [files objectAtIndex:i];
		if ([filename hasSuffix:@".mp3"]) {
			printf("%s \n",[filename UTF8String]);
			[music addObject:[filename substringToIndex:[filename length] - 4]];
		}
	}
	
	for (int i = 0; i < [music count]; i++) {
		printf("%s\n", [[music objectAtIndex:i] UTF8String]);
	}
	
	[label setText:@"Finally found out something"];

	//[label setText:[files objectAtIndex:0]];
	player = new AQPlayer();
	player->CreateQueueForFile((CFStringRef) [[NSBundle mainBundle] pathForResource:@"01 Boulderdash" ofType:@"mp3"]);
	player->StartQueue(false);
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
