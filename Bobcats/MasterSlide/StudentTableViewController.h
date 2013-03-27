//
//  StudentTableViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetailViewController.h"

/*
 * Class Main Interface
 */

@interface StudentTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate> {

    /* Local Declarations */

    AppDelegate *appDelegate;
    DetailViewController *detailViewController;
    UIPopoverController *popoverController;
    NSMutableArray *classArray;
    NSString *classTitle;
    int classkey;

}

/* Global Declarations */

@property (nonatomic, retain) NSMutableArray *studentArraySectioned;
@property (nonatomic) int classkey;

/* Global Method Declarations */

- (void) reloadTableViewData :(NSNotification *)notif;
- (id) init :(NSString *)title arraySectioned :(NSMutableArray *)as classkey :(int)ck;
- (void) realloc :(NSMutableArray *)array;

@end
