//
//  Drawing.h
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum {
    LinePositionTop = 0,
    LinePositionBottom,
} LinePosition;

/** 
 This class contains a set of methods to perform common drawing tasks.
 */

@interface Drawing : NSObject

/** 
 Draws a gradient with the given colors into the given rect.
 */
+ (void) drawGradient:(CGRect)rect fromColor:(UIColor *)from toColor:(UIColor *)to;

/** 
 Draws a gradient with the given gradient reference into the given rect.
 */
+ (void) drawGradient:(CGGradientRef)gradient rect:(CGRect)rect;

/** 
 Draws a line in the given position, with the given color into the given rect.
 
 position can be:
 
 - `LinePositionTop`: the rect's min height.
 - `LinePositionBottom`: the rect's max height.

 */
+ (void) drawLineAtPosition:(LinePosition)position rect:(CGRect)rect color:(UIColor *)color;

/** 
 Draws a line at the given rect's height, with the given color into the given rect.
 */
+ (void) drawLineAtHeight:(float)height rect:(CGRect)rect color:(UIColor *)color width:(float)width;

@end


/** This category adds a set of methods to UIView class. */
@interface UIView (Kit)


/** Drops a shadow with the given opacity.
 
 @warning This method uses the UILayer shadow properties.
 */
- (void) dropShadowWithOpacity:(float)opacity;

@end


/** This category adds a set of methods to UIColor class. */
@interface UIColor (Kit)

/** Returns an autoreleased UIColor instance with the hexadecimal color.
 
 @param hex A color in hexadecimal notation: `0xCCCCCC`, `0xF7F7F7`, etc.
 
 @return A new autoreleased UIColor instance. */
+ (UIColor *) colorWithHex:(int)hex;

@end