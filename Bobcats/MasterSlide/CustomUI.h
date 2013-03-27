//
//  CustomUI.h
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/15/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */

#import <Foundation/Foundation.h>

/*
 * Class Main Interface
 */

@interface CustomUI : NSObject

+ (UIButton *) makeButton:(NSString *)title title_font:(UIFont *)font x_value:(int)x y_value:(int)y width:(int)w height:(int)h back_image_normal:(UIImage *)bin
        back_state_normal:(UIControlState)cs_normal back_image_selected:(UIImage *)bis back_state_selected:(UIControlState)cs_selected
                      tag:(int)t t_color_normal:(UIColor *)tcn t_color_selected:(UIColor *)tcs;

+ (UILabel *) makeLabel:(NSString *)title x_value:(int)x y_value:(int)y width:(int)w height:(int)h back_color:(UIColor *)bc font:(UIFont *)f text_color:(UIColor *)tc linebreakmode:(UILineBreakMode)lbm shadow_color:(UIColor *)sc shadow_off:(CGSize)so;

@end
