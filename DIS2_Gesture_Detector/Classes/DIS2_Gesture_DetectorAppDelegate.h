#import <UIKit/UIKit.h>

@class DIS2_Gesture_DetectorViewController;

@interface DIS2_Gesture_DetectorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DIS2_Gesture_DetectorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DIS2_Gesture_DetectorViewController *viewController;

@end

