//
//  CustomViewTableViewCell
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TableViewCell.h"

/** `CustomViewTableViewCell` is a subclass of `TableViewCell`.
 
 `CustomViewTableViewCell` adds a custom view inside the cell (*not 
 inside the contentView!*), and masks it to the cell's shape. So you can add
 an image, for example, and it will get masked to the cell's shape, with the
 rounded corners.
*/

@interface CustomViewTableViewCell : TableViewCell

/** Holds a reference to the custom view. */
@property (nonatomic, retain) UIView *customView;

@end
