//
//  StudentTableViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface StudentTableViewController : UITableViewController {
    
    AppDelegate *appDelegate;
    DetailViewController *detailViewController;
}

- (void)reloadTableViewData:(NSNotification *)notif;


@end
