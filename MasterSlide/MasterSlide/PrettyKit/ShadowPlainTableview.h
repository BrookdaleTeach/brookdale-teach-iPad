//
//  ShadowPlainTableview.h
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ShadowPlainTableviewPositionHeader = 0,
    ShadowPlainTableviewPositionFooter
} ShadowPlainTableviewPosition;

/** `ShadowPlainTableview` is a subclass of `UIView` that drops a top
 or bottom shadow to use with plain tables.
 
 Just call `setUpTableView:` and everything will be done for you.
 */

@interface ShadowPlainTableview : UIView {
@private
    ShadowPlainTableviewPosition _position;
}
@end


/** This category adds a shortcut to drop shadows in both header and footer of
 a `UITableView`. */
@interface UITableView (KitTableViewShadows)

/** Configures automatically the receiver tableView by dropping a shadow in both
 header and footer. It will also change the tableView's `contentInset` according
 to the shadows' height. 
 
 Shadows will be included __only__ if the tableView's style is plain.
 */
- (void) dropShadows;

@end
