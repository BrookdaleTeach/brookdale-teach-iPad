//
//  AddStudentView.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AddStudentView : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {

    UITableView *headTableView;
    UITableView *restTableView;
    UIButton *addImageButton;
    NSArray *placeHolders;
    NSArray *restPlaceHolders;
    NSArray *restTitles;
    AppDelegate *appDelegate;
    NSString *databasePath;
    NSString *databaseName;

    NSMutableArray *userInput;

    UIScrollView *scrollView;

    StudentTableViewController *studentTableViewController;

    NSIndexPath *restIndexPath;
    BOOL newMedia;
    BOOL imageSavedAsDefaultTitle;
    UIImageView *imageView;

    int classKey;

    UIDatePicker *datePicker;

    int month;
    int day;
    int year;
    
    // Add Classes Buttons
    UIButton *mathCheckbutton;
    UIButton *readingCheckbutton;
    UIButton *writingCheckbutton;
    UIButton *behavioralCheckbutton;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic) int classKey;

- (IBAction) useCameraRoll :(id)sender;

- (id) init :(int)key;

@end
