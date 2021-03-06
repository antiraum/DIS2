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
	id delegate;
}
//@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) NSMutableArray *points;
@property (assign) IBOutlet id delegate;
//- (void)eraseText;
//- (void)displayText:(NSString*) text;
- (void)resetGestureDetection;
@end
