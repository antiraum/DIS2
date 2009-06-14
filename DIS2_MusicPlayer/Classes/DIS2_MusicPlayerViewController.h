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
	IBOutlet UIImageView *image;
	AQPlayer* player;
	//NSMutableArray *music;
	NSUInteger songCount;
	NSUInteger currentSong;
	Boolean stopped;
	Boolean paused;
}

//@property (nonatomic, retain) NSMutableArray *music;

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
- (void)displayImage:(NSString*)imgFile;
- (void)eraseImage;

@end

