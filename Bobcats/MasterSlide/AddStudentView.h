//
//  AddStudentView.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
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

@interface AddStudentView : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
                                              UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {

    /* Local Declarations */

    UITableView *headTableView;
    UITableView *restTableView;
    UIButton *addImageButton;
    NSArray *placeHolders;
    NSArray *restPlaceHolders;
    NSArray *restTitles;
    AppDelegate *appDelegate;
    NSString *databasePath;
    NSString *databaseName;
    UIImageView *imageView;
    UIDatePicker *datePicker;
    NSMutableArray *userInput;
    UIScrollView *scrollView;

    NSIndexPath *restIndexPath;
    BOOL newMedia;
    BOOL imageSavedAsDefaultTitle;

    int classKey;
    int month;
    int day;
    int year;

    UIButton *mathCheckbutton;
    UIButton *readingCheckbutton;
    UIButton *writingCheckbutton;
    UIButton *behavioralCheckbutton;

    StudentTableViewController *studentTableViewController;
}

/* Global Declarations */

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic) int classKey;

/* Global Method Declarations */

- (IBAction) useCameraRoll :(id)sender;
- (id) init :(int)key;

@end
