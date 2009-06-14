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
	IBOutlet UIProgressView *volumeBar;
	AQPlayer* player;
	//NSMutableArray *music;
	NSUInteger songCount;
	NSUInteger currentSong;
	Boolean stopped;
	Boolean paused;
	Float32 volume;
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
- (void)setVolume:(Float32)level;
- (void)increaseVolume;
- (void)decreaseVolume;
- (void)displayImage:(NSString*)imgFile;
- (void)eraseImage;

@end

