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

//@synthesize music;


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
	NSMutableArray* music = [NSMutableArray arrayWithCapacity:[files count] - 5];
	
	for(int i = 0; i < [files count]; i++) {
		NSString* filename = [files objectAtIndex:i];
		if ([filename hasSuffix:@".mp3"]) {
			//printf("%s \n",[filename UTF8String]);
			[music addObject:[filename substringToIndex:[filename length] - 4]];
		}
	}
	songCount = [music count];
	volume = 1.0;
	paused = NO;
	stopped = YES;
	printf("Loaded %d songs\n",songCount);
	player = new AQPlayer();
	[self setSong:0];
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
		[self displayImage:@"play"];
		player->StartQueue(false);
		stopped = NO;
	} else if (paused == YES) {
		[self displayImage:@"play"];
		player->StartQueue(true);
		paused = NO;
	} else if (player->IsDone()) {
		[self displayImage:@"play"];
		player->StartQueue(false);
	} else {
		[self displayImage:@"pause"];
		player->StopQueue();
		paused = YES;
	}
}
- (void)nextSong {
	if (currentSong + 1 < songCount) {
		[self displayImage:@"next"];
		[self setSong:currentSong+1];
	}
}
- (void)previousSong {
	if (currentSong > 0) {
		[self displayImage:@"prev"];
		[self setSong:currentSong-1];
	}
}
- (void)stop {
	printf("Stopping...\n");
	
	[self displayImage:@"stop"];
	player->StopQueue();
	stopped = YES;
	[self setSong:0];
}
- (void)setSong:(NSUInteger)number {
	if (number >= songCount) {
		return;
	}

	NSArray* files = [[NSFileManager defaultManager] directoryContentsAtPath:[[NSBundle mainBundle] bundlePath]];
	NSMutableArray* music = [NSMutableArray arrayWithCapacity:[files count] - 5];
	
	for(int i = 0; i < [files count]; i++) {
		NSString* filename = [files objectAtIndex:i];
		if ([filename hasSuffix:@".mp3"]) {
			//printf("%s \n",[filename UTF8String]);
			[music addObject:[filename substringToIndex:[filename length] - 4]];
		}
	}
	songCount = [music count];
	
	
	printf("Getting song list\n");
	NSArray *songList = music;
	printf("Song list count: %d\n",[songList count]);
	
	printf("Setting song %d\n",number);

	currentSong = number;
	printf("Setting label\n");

	label.text = [songList objectAtIndex:number];
	printf("Checking player status\n");

	if(stopped == NO && paused == NO) {
		printf("Stopping queue...\n");
		player->StopQueue();
	}
	printf("Creating queue...\n");
	//delete player;
	//player = new AQPlayer();
	player->DisposeQueue(true);
	player->CreateQueueForFile((CFStringRef) [[NSBundle mainBundle] pathForResource:label.text ofType:@"mp3"]);
	player->SetVolume(volume);
	printf("Volume %f\n",player->GetVolume());
	if(stopped == NO && paused == NO) {
		printf("Back to playing...\n");

		player->StartQueue(false);
	} else {
		printf("Preparing for play...\n");
		stopped = YES;
		paused = NO;
	}
}

- (void)setVolume:(Float32)level {
	if (level < 0) {
		volume = 0;
	} else if (level > 1) {
		volume = 1;
	} else {
		volume = level;
	}
	player->SetVolume(volume);
	volumeBar.progress = volume;
}

- (void)increaseVolume {
	[self setVolume:volume + 0.1];
}

- (void)decreaseVolume {
	[self setVolume:volume - 0.1];	
}

- (void)displayImage:(NSString*)imgFile {
	image.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgFile ofType:@"png"]];
	[self performSelector:@selector(eraseImage) withObject:nil afterDelay:0.5];
}

- (void)eraseImage {
	image.image = nil;
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

- (void)handleClockwiseCircularGesture {
	[self increaseVolume];
}
- (void)handleCounterclockwiseCircularGesture {
	[self decreaseVolume];
}
- (void)handleUnsupportedGesture:(NSString*) message {}

@end
