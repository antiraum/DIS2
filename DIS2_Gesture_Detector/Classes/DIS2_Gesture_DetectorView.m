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
        [self handleUnsupportedGesture:@"Too many taps!"];
		[self resetGestureDetection];
		return;
	}	
	
	// detect double tap
	if (numTaps == 2) {
		[self handleDoubleTapGesture];
		[self resetGestureDetection];
		return;
	}
	
	// detect single tap
	if (distanceBetweenPoints(firstTouch, endPoint) < kMinimumMovementDistanceVariance && [points count] <= kTapMaximumPoints) {
		[self handleSingleTapGesture];
		[self resetGestureDetection];
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
			[self handleRightSwipeGesture];
		} else {
			[self handleLeftSwipeGesture];
		}
        [self resetGestureDetection];
		return;
    }
    
    // didn't finish close enough to starting point for circle
    if (distanceBetweenPoints(firstTouch, endPoint) > kCircleClosureDistanceVariance) {
        [self handleUnsupportedGesture:@"End point too far away from start for a circle!"];
        [self resetGestureDetection];
        return;
    }
	
    // not enough points for circle
    if ([points count] < 6) {
        [self handleUnsupportedGesture:@"Too short for a circle!"];
        [self resetGestureDetection];
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
	label.text = @"Angles";
    for (NSString *onePointString in points) {
        CGPoint onePoint = CGPointFromString(onePointString);
        CGFloat distanceFromRadius = fabsf(distanceBetweenPoints(center, onePoint));
        if (distanceFromRadius < minRadius || distanceFromRadius > maxRadius) {
            [self handleUnsupportedGesture:@"Not round enough for a circle!"];
			[self resetGestureDetection];
			return;
        }
        
        CGFloat pointAngle = angleBetweenLines(firstTouch, center, onePoint, center);
		// label.text = [label.text stringByAppendingString:[NSString stringWithFormat:@ " %.0f", currentAngle]];
        
        if ((pointAngle > currentAngle && hasSwitched) && (index < [points count] - kOverlapTolerance)) {
			[self handleUnsupportedGesture:@"Sequence of angles is wrong for circle!"];
            [self resetGestureDetection];
            return;
        }
            
        if (pointAngle < currentAngle) {
            if (! hasSwitched) hasSwitched = YES;
        }
        
        currentAngle = pointAngle;
		index++;
    }
    
	CGFloat ccw = counterClockWise(firstTouch, CGPointFromString([points objectAtIndex:[points count]/3]), CGPointFromString([points objectAtIndex:[points count]*2/3]));
	if (ccw > 0) {
		[self handleClockwiseCircularGesture];
	} else if (ccw < 0) {
		[self handleCounterclockwiseCircularGesture];
	} else {
		[self handleUnsupportedGesture:@"LinearCircleException"];
	}
    [self resetGestureDetection];   
}

- (void)handleLeftSwipeGesture {
	[self displayText:@"Right swipe detected"];
}
- (void)handleRightSwipeGesture {
	[self displayText:@"Left swipe detected"];
}
- (void)handleSingleTapGesture {
	[self displayText:@"Single tap detected"];
}
- (void)handleDoubleTapGesture {
	[self displayText:@"Double tap detected"];
}
- (void)handleClockwiseCircularGesture {
	[self displayText:@"Clockwise circle detected!"];
}
- (void)handleCounterclockwiseCircularGesture {
	[self displayText:@"Counterclockwise circle detected!"];
}
- (void)handleUnsupportedGesture:(NSString*) message {
	[self displayText:message];
}
- (void)displayText:(NSString*) text {
	label.text = text;
	[self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
}
- (void)resetGestureDetection {
	[points removeAllObjects];
    firstTouch = CGPointZero;
}
@end
