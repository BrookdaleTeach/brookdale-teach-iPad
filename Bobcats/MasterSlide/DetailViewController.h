//
//  DetailViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"
#import "MGScrollView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MapKit/MapKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "SettingsViewController.h"
#import "MBProgressHUD.h"

/* Class Declarations */

@class AppDelegate;

/*
 * Class Main Implementation
 */
@interface DetailViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MKMapViewDelegate,
                                                    EKEventEditViewDelegate, UIScrollViewDelegate, UIWebViewDelegate> {

    /* Local Declarations */

    Student *student;
    AppDelegate *appDelegate;
    MBProgressHUD *HUD;

    NSArray *tableViewHeaders;
    NSMutableArray *tableViewContent;
    UIView *shelfView;
    UILabel *shelfViewShadow;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *uidLabel;
    UIToolbar *toolbar;
    UIImageView *toolBarImage;
    UIImageView *studentImageView;
    UIImageView *ribbon;
    UITextView *notesTextView;
    NSString *nextView;
    NSIndexPath *indexPath;

    int selectedContactActionSheetButton;
    BOOL isSettingsHidden;
}

/* Global Declarations */

@property (nonatomic, strong) SettingsViewController *settingsViewController;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MGScrollView *scroller;
@property (nonatomic, strong) UIActionSheet *emailActionSheet;
@property (nonatomic, strong) UIActionSheet *contactActionSheet;
@property (nonatomic, strong) UIActionSheet *addEventActionSheet;
@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;

/* Global Method Declarations */

- (void) loadContentDataView :(int)section :(int)row;

@end
