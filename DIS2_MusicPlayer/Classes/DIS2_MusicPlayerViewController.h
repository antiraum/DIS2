//
//  DIS2_MusicPlayerViewController.h
//  DIS2_MusicPlayer
//
//  Created by Jonathan Simon on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQPlayer.h"

@interface DIS2_MusicPlayerViewController : UIViewController {
	IBOutlet UILabel *label;
	AQPlayer* player;
	NSMutableArray* music;
}

@end

