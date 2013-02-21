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

@interface StudentTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate> {

    AppDelegate *appDelegate;
    DetailViewController *detailViewController;
    UIPopoverController *popoverController;

    NSMutableArray *classArray;
    NSString *classTitle;
    int classkey;

}

@property (nonatomic, retain) NSMutableArray *studentArraySectioned;
@property (nonatomic) int classkey;

- (void) reloadTableViewData :(NSNotification *)notif;
- (id) init :(NSString *)title arraySectioned :(NSMutableArray *)as classkey :(int)ck;
- (void) realloc :(NSMutableArray *)array;

@end
