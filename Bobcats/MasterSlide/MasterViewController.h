//
//  MasterViewController
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class DetailViewController;
@class AppDelegate;

@interface MasterViewController : UITableViewController <UIAlertViewDelegate> {
	
	DetailViewController *detailViewController;
    NSArray *headers;
    NSArray *images;
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) DetailViewController *detailViewController;


@end
