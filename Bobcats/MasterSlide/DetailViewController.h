//
//  DetailViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

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

@class AppDelegate;

@interface DetailViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MKMapViewDelegate, EKEventEditViewDelegate, UIScrollViewDelegate, UIWebViewDelegate> {

    Student *student;
    AppDelegate *appDelegate;

    NSArray *tableViewHeaders;
    NSMutableArray *tableViewContent;

    UIView *shelfView;
    UILabel *shelfViewShadow;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *uidLabel;

    UIImageView *studentImageView;
    UIImageView *ribbon;

    NSString *nextView;
    NSIndexPath *indexPath;
    
    UIToolbar *toolbar;

    int selectedContactActionSheetButton;
    
    BOOL isSettingsHidden;
    
    UIImageView *toolBarImage;
    
    MBProgressHUD *HUD;
    
    UITextView *notesTextView;
}

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

- (void) loadContentDataView :(int)section :(int)row;

@end
