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

@synthesize music;


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
	NSMutableArray* musicFiles = [NSMutableArray arrayWithCapacity:[files count] - 5];
	
	for(int i = 0; i < [files count]; i++) {
		NSString* filename = [files objectAtIndex:i];
		if ([filename hasSuffix:@".mp3"]) {
			//printf("%s \n",[filename UTF8String]);
			[musicFiles addObject:[filename substringToIndex:[filename length] - 4]];
		}
	}
	music = [NSArray arrayWithArray:musicFiles];
	paused = NO;
	stopped = YES;
	songCount = [music count];
	printf("Loaded %d songs\n",songCount);
	player = new AQPlayer();
	[self setSong:1];
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

- (void)playPause {
	if (stopped == YES) {
		player->StartQueue(false);
		stopped = NO;
	} else if (paused == YES) {
		player->StartQueue(true);
		paused = NO;
	} else {
		player->StopQueue();
		paused = YES;
	}
}
- (void)nextSong {
	if (currentSong + 1 < songCount) {
		[self setSong:currentSong+1];
	}
}
- (void)previousSong {
	if (currentSong > 0) {
		[self setSong:currentSong-1];
	}
}
- (void)stop {
	printf("Stopping...\n");
	player->StopQueue();
	stopped = YES;
	[self setSong:0];
}
- (void)setSong:(NSUInteger)number {
	if (number >= songCount) {
		return;
	}
	printf("Setting song %d\n",number);

	currentSong = number;
	label.text = [[self music] objectAtIndex:number];
	if(stopped == NO && paused == NO) {
		printf("Stopping queue...\n");
		player->StopQueue();
	}
	printf("Creating queue...\n");

	player->CreateQueueForFile((CFStringRef) [[NSBundle mainBundle] pathForResource:[[self music] objectAtIndex:number] ofType:@"mp3"]);
	if(stopped == NO && paused == NO) {
		printf("Back to playing...\n");

		player->StartQueue(false);
	} else {
		printf("Preparing for play...\n");
		stopped = YES;
		paused = NO;
	}
}

- (void)handleLeftSwipeGesture {
	[self previousSong];
}
- (void)handleRightSwipeGesture {
	[self nextSong];
}

- (void)handleSingleTapGesture {
	[self playPause];
}
- (void)handleDoubleTapGesture {
	[self stop];
}
- (void)handleClockwiseCircularGesture {}
- (void)handleCounterclockwiseCircularGesture {}
- (void)handleUnsupportedGesture:(NSString*) message {}

@end
