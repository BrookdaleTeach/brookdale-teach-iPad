//
//  Drawing.m
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//
#import "Drawing.h"
#import <QuartzCore/QuartzCore.h>

@implementation Drawing

+ (void) drawGradient:(CGRect)rect fromColor:(UIColor *)from toColor:(UIColor *)to {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    CGColorRef startColor = from.CGColor;
    CGColorRef endColor = to.CGColor;    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (CFArrayRef) CFBridgingRetain(colors), locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(ctx);
}

+ (void) drawLineAtPosition:(LinePosition)position rect:(CGRect)rect color:(UIColor *)color {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    float y = 0;
    switch (position) {
        case LinePositionTop:
            y = CGRectGetMinY(rect) + 0.5;
            break;
        case LinePositionBottom:
            y = CGRectGetMaxY(rect) - 0.5;
        default:
            break;
    }
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), y);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), y);
    
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

+ (void) drawLineAtHeight:(float)height rect:(CGRect)rect color:(UIColor *)color width:(float)width {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    float y = height;
    
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), y);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), y);
    
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, width);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

+ (void) drawGradient:(CGGradientRef)gradient rect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(ctx);
}


@end


@implementation UIView (Kit)

- (void) dropShadowWithOpacity:(float)opacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end


@implementation UIColor (Kit)

// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0 
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}


@end