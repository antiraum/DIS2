#include "CGPointUtils.h"
#include <math.h>

#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
	CGFloat deltaX = second.x - first.x;
	CGFloat deltaY = second.y - first.y;
	return sqrt(deltaX*deltaX + deltaY*deltaY );
};
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat height = second.y - first.y;
	CGFloat width = first.x - second.x;
	CGFloat rads = atan(height/width);
	return radiansToDegrees(rads);
	//degs = degrees(atan((top - bottom)/(right - left)))
}
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
	
	CGFloat a = line1End.x - line1Start.x;
	CGFloat b = line1End.y - line1Start.y;
	CGFloat c = line2End.x - line2Start.x;
	CGFloat d = line2End.y - line2Start.y;
	
	CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));

	return rads;
//	return radiansToDegrees(rads);
}

/**
 # Three points are a counter-clockwise turn if ccw > 0, clockwise if
 # ccw < 0, and collinear if ccw = 0 because ccw is a determinant that
 # gives the signed area of the triangle formed by p1, p2, and p3.
 * @source http://en.wikipedia.org/wiki/Graham_scan
 **/
CGFloat counterClockWise(CGPoint p1, CGPoint p2, CGPoint p3) {
	return (p2.x - p1.x)*(p3.y - p1.y) - (p2.y - p1.y)*(p3.x - p1.x);
}
