#import <UIKit/UIKit.h>
#define kMinimumMovementDistanceVariance	5.0
#define kMaximumSwipeVerticalVariance		20.0
#define kCircleClosureDistanceVariance		100.0
#define kRadiusVariancePercent              25.0
#define kOverlapTolerance                   3
#define kTapMaximumPoints					5
@interface DIS2_Gesture_DetectorView : UIView {
    UILabel *label;
    NSMutableArray *points;
    CGPoint firstTouch;
    NSTimeInterval firstTouchTime;
	NSUInteger numTaps;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) NSMutableArray *points;
- (void)eraseText;
- (void)handleLeftSwipeGesture;
- (void)handleRightSwipeGesture;
- (void)handleSingleTapGesture;
- (void)handleDoubleTapGesture;
- (void)handleClockwiseCircularGesture;
- (void)handleCounterclockwiseCircularGesture;
- (void)handleUnsupportedGesture:(NSString*) message;
- (void)displayText:(NSString*) text;
- (void)resetGestureDetection;
@end
