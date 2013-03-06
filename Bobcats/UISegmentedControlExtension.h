//
//  UISegmentedControlExtension.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/21/13.
//
//

#import <Foundation/Foundation.h>

@interface UISegmentedControl(CustomTintExtension)
    -(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSUInteger)segment forSegmentTag:(NSInteger)segTag;
    -(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag forSegmentTag:(NSInteger)segTag;
    -(void)setTextColor:(UIColor*)color forTag:(NSInteger)aTag;
    -(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag;
@end
