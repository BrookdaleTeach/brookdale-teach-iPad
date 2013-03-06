//
//  CustomUI.m
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/15/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

#import "CustomUI.h"

@implementation CustomUI

/*
   MakeButton
   --------
   Purpose:        Construct custom button
   Parameters:     title, font, x, y, width, height, back_image, etc
   Returns:        UIButton
   Notes:          Creates a scalable button
   Author:         Neil Burchfield
 */
+ (UIButton *) makeButton:(NSString *)title title_font:(UIFont *)font x_value:(int)x y_value:(int)y width:(int)w height:(int)h back_image_normal:(UIImage *)bin
        back_state_normal:(UIControlState)cs_normal back_image_selected:(UIImage *)bis back_state_selected:(UIControlState)cs_selected
                      tag:(int)t t_color_normal:(UIColor *)tcn t_color_selected:(UIColor *)tcs {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [button setBackgroundImage:bin forState:cs_normal];
    [button setBackgroundImage:bis forState:cs_selected];
    [button setTag:t];
    [button setTitleColor:tcn forState:cs_normal];
    [button setTitleColor:tcs forState:cs_selected];
    [button setTitle:title forState:cs_normal];
    [button.titleLabel setFont:font];

    return button;
} /* makeButton */


/*
   MakeLabel
   --------
   Purpose:        Construct custom label
   Parameters:     title, font, x, y, width, height, back_color, text_color, linebreakmode, shadow_color, shadow_off
   Returns:        UILabel
   Notes:          Creates a scalable label
   Author:         Neil Burchfield
 */
+ (UILabel *) makeLabel:(NSString *)title x_value:(int)x y_value:(int)y width:(int)w height:(int)h back_color:(UIColor *)bc font:(UIFont *)f text_color:(UIColor *)tc linebreakmode:(UILineBreakMode)lbm shadow_color:(UIColor *)sc shadow_off:(CGSize)so {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [label setBackgroundColor:bc];
    [label setText:title];
    [label setFont:f];
    [label setTextColor:tc];
    [label setLineBreakMode:lbm];
    [label setShadowColor:sc];
    [label setShadowOffset:so];
    return label;
} /* makeLabel */


@end
