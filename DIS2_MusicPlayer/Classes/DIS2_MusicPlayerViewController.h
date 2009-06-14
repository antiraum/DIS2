//
//  DIS2_MusicPlayerViewController.h
//  DIS2_MusicPlayer
//
//  Created by Jonathan Simon on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQPlayer.h"
#import "DIS2_Gesture_DetectorProtocol.h"

@interface DIS2_MusicPlayerViewController : UIViewController <GestureHandler> {
	IBOutlet UILabel *label;
	AQPlayer* player;
	NSArray* music;
	NSUInteger songCount;
	NSUInteger currentSong;
	Boolean stopped;
	Boolean paused;
}

@property (assign) NSArray* music;

- (void)handleLeftSwipeGesture;
- (void)handleRightSwipeGesture;
- (void)handleSingleTapGesture;
- (void)handleDoubleTapGesture;
- (void)handleClockwiseCircularGesture;
- (void)handleCounterclockwiseCircularGesture;
- (void)handleUnsupportedGesture:(NSString*) message;
- (void)playPause;
- (void)nextSong;
- (void)previousSong;
- (void)stop;
- (void)setSong:(NSUInteger)number; 

@end

