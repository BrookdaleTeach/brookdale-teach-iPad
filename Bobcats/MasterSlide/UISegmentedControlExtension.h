//
//  UISegmentedControlExtension.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/21/13.
//
//

/* Imports */

#import <Foundation/Foundation.h>

/*
 * Class Main Interface
 */

@interface UISegmentedControl (CustomTintExtension)

/* Global Method Declarations */

-(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSUInteger)segment forSegmentTag:(NSInteger)segTag;
-(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag forSegmentTag:(NSInteger)segTag;
-(void)setTextColor:(UIColor*)color forTag:(NSInteger)aTag;
-(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag;

@end
