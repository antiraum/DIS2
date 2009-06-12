#import <UIKit/UIKit.h>
#define kMinimumMovementDistanceVariance	5.0
#define kMaximumSwipeVerticalVariance		50.0
#define kCircleClosureDistanceVariance		100.0
#define kRadiusVariancePercent              25.0
#define kOverlapTolerance                   3
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
@end
