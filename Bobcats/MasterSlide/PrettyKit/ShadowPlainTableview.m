//
//  ShadowPlainTableview
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

#import "ShadowPlainTableview.h"

#define view_height 25
#define shadow_height 5

@implementation ShadowPlainTableview


@end


@implementation UITableView (KitTableViewShadows)

- (void) dropShadows
{
    if (self.style == UITableViewStylePlain)
    {
    }
}

@end
