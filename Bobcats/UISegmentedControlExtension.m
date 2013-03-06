//
//  UISegmentedControlExtension.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/21/13.
//
//

#import "UISegmentedControlExtension.h"

@implementation UISegmentedControl (CustomTintExtension)

- (void) setTag :(NSInteger)tag forSegmentAtIndex :(NSUInteger)segment forSegmentTag :(NSInteger)segTag {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[self viewWithTag:segTag];
    [[segmentedControl.subviews objectAtIndex:segment] setTag:tag];
} /* setTag */


- (void) setTintColor :(UIColor *)color forTag :(NSInteger)aTag forSegmentTag :(NSInteger)segTag {
    // must operate by tags.  Subview index is unreliable
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[self viewWithTag:segTag];
    UIView *segment = [segmentedControl viewWithTag:aTag];
    SEL tint = @selector(setTintColor:);

    // UISegment is an undocumented class, so tread carefully
    // if the segment exists and if it responds to the setTintColor message
    if (segment && ([segment respondsToSelector:tint])) {
        [segment performSelector:tint withObject:color];
    }
} /* setTintColor */


- (void) setTextColor :(UIColor *)color forTag :(NSInteger)aTag {
    UIView *segment = [self viewWithTag:aTag];
    for (UIView *view in segment.subviews) {
        SEL text = @selector(setTextColor:);

        // if the sub view exists and if it responds to the setTextColor message
        if (view && ([view respondsToSelector:text])) {
            [view performSelector:text withObject:color];
        }
    }
} /* setTextColor */


- (void) setShadowColor :(UIColor *)color forTag :(NSInteger)aTag {

    // you probably know the drill by now
    // you could also combine setShadowColor and setTextColor
    UIView *segment = [self viewWithTag:aTag];
    for (UIView *view in segment.subviews) {
        SEL shadowColor = @selector(setShadowColor:);
        if (view && ([view respondsToSelector:shadowColor])) {
            [view performSelector:shadowColor withObject:color];
        }
    }
} /* setShadowColor */


@end
