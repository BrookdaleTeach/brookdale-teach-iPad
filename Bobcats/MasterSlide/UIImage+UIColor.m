//
//  UIImage+UIColor.m
//  Bobcats
//
//  Created by Burchfield, Neil on 3/11/13.
//
//

#import "UIImage+UIColor.h"

@implementation UIImage_UIColor

+ (UIImage *) imageWithColor :(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
} /* imageWithColor */


@end
