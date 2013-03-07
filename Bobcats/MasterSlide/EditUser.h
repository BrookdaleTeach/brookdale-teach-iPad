//
//  EditUser.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/22/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditUser : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {
    
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
    
    Student *student;
    NSString *title;
    NSIndexPath *ip;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic) int classKey;

- (IBAction) useCameraRoll :(id)sender;

- (id) init:(Student *)s key:(int)k index:(NSIndexPath *)ip title:(NSString *)t;

@end