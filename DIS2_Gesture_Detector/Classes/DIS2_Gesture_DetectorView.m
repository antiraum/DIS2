#import "DIS2_Gesture_DetectorView.h"
#import "CGPointUtils.h"

@implementation DIS2_Gesture_DetectorView
@synthesize label;
@synthesize points;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    if (firstTouch.x != 0.0 && firstTouch.y != 0.0) {
        CGRect dotRect = CGRectMake(firstTouch.x - 3, firstTouch.y - 3.0, 5.0, 5.0);
        CGContextAddEllipseInRect(context, dotRect);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextMoveToPoint(context, firstTouch.x, firstTouch.y);
        for (NSString *onePointString in points) {
            CGPoint nextPoint = CGPointFromString(onePointString);
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
            
        }
        CGContextStrokePath(context);
    } else {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextAddRect(context, self.bounds);
        CGContextFillPath(context);
    }
}

- (void)dealloc {
    [label release];
    [points release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (points == nil)
        self.points = [NSMutableArray array];
    else
        [points removeAllObjects];
    
	UITouch* touch = [touches anyObject];
    firstTouch = [touch locationInView:self];
    firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
	numTaps = [touch tapCount];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint startPoint = [[touches anyObject] locationInView:self];
    [points addObject:NSStringFromCGPoint(startPoint)];    
    
    // TODO: We should calculate the redraw rect here
    [self setNeedsDisplay];
}

- (void)eraseText {
    label.text = @"";
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    [points addObject:NSStringFromCGPoint(endPoint)];
	
	// too many taps
	if (numTaps > 2) {
        label.text = @"Too many taps!";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
		[points removeAllObjects];
		firstTouch = CGPointZero;
		return;
	}	
	
	// detect double tap
	if (numTaps == 2) {
        label.text = @"Double tap detected";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
		[points removeAllObjects];
		firstTouch = CGPointZero;
		return;
	}
	
	// detect single tap
	if (distanceBetweenPoints(firstTouch, endPoint) < kMinimumMovementDistanceVariance) {
        label.text = @"Single tap detected";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
		[points removeAllObjects];
		firstTouch = CGPointZero;
		return;
	}
	
	// detect swipe
	BOOL isSwipe = YES;
    for (NSString *onePointString in points) {
        CGPoint onePoint = CGPointFromString(onePointString);
		if (fabsf(firstTouch.y - onePoint.y) <= kMaximumSwipeVerticalVariance) continue;
		isSwipe = NO;
		break;
	}
	if (isSwipe) {
		if (firstTouch.x < endPoint.x) {
			label.text = @"Right swipe detected";
		} else {
			label.text = @"Left swipe detected";
		}
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
		[points removeAllObjects];
		firstTouch = CGPointZero;
		return;
    }
    
    // didn't finish close enough to starting point for circle
    if (distanceBetweenPoints(firstTouch, endPoint) > kCircleClosureDistanceVariance) {
        label.text = @"End point too far away from start for a circle!";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
		[points removeAllObjects];
		firstTouch = CGPointZero;
        return;
    }
	
    // not enough points for circle
    if ([points count] < 6) {
        label.text = @"Too short for a circle!";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
		[points removeAllObjects];
		firstTouch = CGPointZero;
        return;
    }
    
    CGPoint leftMost = firstTouch;
    NSUInteger leftMostIndex = NSUIntegerMax;
    CGPoint topMost = firstTouch;
    NSUInteger topMostIndex = NSUIntegerMax;
    CGPoint rightMost = firstTouch;
    NSUInteger  rightMostIndex = NSUIntegerMax;
    CGPoint bottomMost = firstTouch;
    NSUInteger bottomMostIndex = NSUIntegerMax;
    
    // Loop through touches and find out if outer limits of the circle
    int index = 0;
    for (NSString *onePointString in points) {
        CGPoint onePoint = CGPointFromString(onePointString);
        if (onePoint.x > rightMost.x) {
            rightMost = onePoint;
            rightMostIndex = index;
        }
        if (onePoint.x < leftMost.x) {
            leftMost = onePoint;
            leftMostIndex = index;
        }
        if (onePoint.y > topMost.y) {
            topMost = onePoint;
            topMostIndex = index;
        }
        if (onePoint.y < bottomMost.y) {
            onePoint = bottomMost;
            bottomMostIndex = index;
        }
        index++;
    }
    
    // If startPoint is one of the extreme points, take set it
    if (rightMostIndex == NSUIntegerMax)
        rightMost = firstTouch;
    if (leftMostIndex == NSUIntegerMax)
        leftMost = firstTouch;
    if (topMostIndex == NSUIntegerMax)
        topMost = firstTouch;
    if (bottomMostIndex == NSUIntegerMax)
        bottomMost = firstTouch;
    
    // Figure out the approx middle of the circle
    CGPoint center = CGPointMake(leftMost.x + (rightMost.x - leftMost.x) / 2.0, bottomMost.y + (topMost.y - bottomMost.y) / 2.0);
    
    // Calculate the radius by looking at the first point and the center
    CGFloat radius = fabsf(distanceBetweenPoints(center, firstTouch));
    
    CGFloat currentAngle = 0.0; 
    BOOL    hasSwitched = NO;
    
    // Start Circle Check
    // Make sure all points on circle are within a certain percentage of the radius from the center
    // Make sure that the angle switches direction only once. As we go around the circle,
    // the angle between the line from the start point to the end point and the line from the
    // current point and the end point should go from 0 up to about 180, and then come 
    // back down to 0 (the function returns the smaller of the angles formed by the lines, so
    // 180 is the highest it will return, 0 the lowest. If it switches direction more than once, 
    // then it's not a circle
    CGFloat minRadius = radius - (radius * kRadiusVariancePercent);
    CGFloat maxRadius = radius + (radius * kRadiusVariancePercent);
    index = 0;
    for (NSString *onePointString in points) {
        CGPoint onePoint = CGPointFromString(onePointString);
        CGFloat distanceFromRadius = fabsf(distanceBetweenPoints(center, onePoint));
        if (distanceFromRadius < minRadius || distanceFromRadius > maxRadius) {
            label.text = [NSString stringWithFormat:@"Not round enough for a circle!", fabs(currentAngle)];
            [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
			[points removeAllObjects];
			firstTouch = CGPointZero;
            return;
        }
        
        CGFloat pointAngle = angleBetweenLines(firstTouch, center, onePoint, center);
        
        if ((pointAngle > currentAngle && hasSwitched) && (index < [points count] - kOverlapTolerance)) {
            label.text = [NSString stringWithFormat:@"Sequence of angles is wrong for circle!", fabs(currentAngle)];
            [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
			[points removeAllObjects];
			firstTouch = CGPointZero;
            return;
        }
            
        if (pointAngle < currentAngle) {
            if (! hasSwitched) hasSwitched = YES;
        }
        
        currentAngle = pointAngle;
		index++;
    }
    
    label.text = @"Circle detected!";
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
    [points removeAllObjects];
    firstTouch = CGPointZero;    
}

@end