//
//  DIS2_MusicPlayerAppDelegate.h
//  DIS2_MusicPlayer
//
//  Created by Jonathan Simon on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DIS2_MusicPlayerViewController;

@interface DIS2_MusicPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DIS2_MusicPlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DIS2_MusicPlayerViewController *viewController;

@end

