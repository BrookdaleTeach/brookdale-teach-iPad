//
//  EditUser.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/22/13.
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

/*
 * Class Main Interface
 */

@interface EditUser : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate, UIPopoverControllerDelegate> {

    /* Local Declarations */

    StudentTableViewController *studentTableViewController;
    UITableView *headTableView;
    UITableView *restTableView;
    UIButton *addImageButton;
    NSArray *placeHolders;
    NSArray *restPlaceHolders;
    NSArray *restTitles;
    NSArray *restValues;
    AppDelegate *appDelegate;
    NSString *databasePath;
    NSString *databaseName;
    NSMutableArray *userInput;
    UIScrollView *scrollView;
    NSIndexPath *restIndexPath;
    UIImageView *imageView;
    UIDatePicker *datePicker;
    Student *student;
    NSString *title;
    NSIndexPath *ip;
    UIButton *mathCheckbutton;
    UIButton *readingCheckbutton;
    UIButton *writingCheckbutton;
    UIButton *behavioralCheckbutton;

    int classKey;
    int month;
    int day;
    int year;
    BOOL newMedia;
    BOOL imageSavedAsDefaultTitle;
}

/* Global Declarations */

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic) int classKey;

/* Global Method Declarations */

- (IBAction) useCameraRoll :(id)sender;
- (id) init :(Student *)s key :(int)k index :(NSIndexPath *)ip title :(NSString *)t;

@end
