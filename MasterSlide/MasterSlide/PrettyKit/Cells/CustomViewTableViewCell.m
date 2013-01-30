//
//  CustomViewTableViewCell
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

#import "CustomViewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomViewTableViewCell
@synthesize customView;

#define shadow_margin 4 

- (void) dealloc 
{
    self.customView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void) drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    if (self.customView != nil) 
    {    
        self.customView.frame = self.innerFrame;
        
		self.customView.layer.mask = self.mask;
        self.customView.layer.masksToBounds = YES;
        
        if (![self.subviews containsObject:self.customView])
        {
            [self addSubview:self.customView];
        }
    }
}

- (void) setBackgroundColor:(UIColor *)backgroundColor 
{
    [super setBackgroundColor:backgroundColor];
    self.customView.backgroundColor = backgroundColor;
}

- (void) setCustomBackgroundColor:(UIColor *)customBackgroundColor 
{
    [super setCustomBackgroundColor:customBackgroundColor];
    self.customView.backgroundColor = customBackgroundColor;
}

@end
