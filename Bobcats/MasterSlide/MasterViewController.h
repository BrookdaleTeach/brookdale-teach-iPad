//
//  MasterViewController
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/* Class Objects Declatations */

@class DetailViewController;
@class AppDelegate;

/*
 * Class Main Implementation
 */

@interface MasterViewController : UITableViewController <UIAlertViewDelegate> {

    /* Local Declarations */

    DetailViewController *detailViewController;
    NSArray *headers;
    NSArray *images;
    AppDelegate *appDelegate;
}

/* Global Method Declarations */

@property (nonatomic, strong) DetailViewController *detailViewController;


@end
