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
    UIImageView *imageView;


}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
- (IBAction)useCamera: (id)sender;
- (IBAction)useCameraRoll: (id)sender;
@end
