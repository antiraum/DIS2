/*
 *  DIS2_Gesture_DetectorProtocol.h
 *  DIS2_MusicPlayer
 *
 *  Created by Jonathan Simon on 6/14/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

@protocol GestureHandler

- (void)handleLeftSwipeGesture;
- (void)handleRightSwipeGesture;
- (void)handleSingleTapGesture;
- (void)handleDoubleTapGesture;
- (void)handleClockwiseCircularGesture;
- (void)handleCounterclockwiseCircularGesture;
- (void)handleUnsupportedGesture:(NSString*) message;

@end