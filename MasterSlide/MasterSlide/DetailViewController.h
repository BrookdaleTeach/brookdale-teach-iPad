#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"

@class AppDelegate;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate> {
    
	UIActionSheet *activeSheet;
	UIPopoverController *outlinePopover;
	UIViewController *outlineViewController;
	UIPopoverController *bookmarksPopover;
	
	NSArray *portraitToolbarItems;
	NSArray *landscapeToolbarItems;
	
	UIToolbar *toolbar;
	UIBarButtonItem *backButtonItem;
	UIBarButtonItem *forwardButtonItem;
	UIBarButtonItem *outlineButtonItem;
	UIBarButtonItem *bookmarksButtonItem;
	UIBarButtonItem *actionButtonItem;
	UILabel *titleLabel;
	
	UIView *coverView;
	UIWebView *webView;
	
	NSDictionary *book;
	NSString *bookPath;
	NSURL *selectedExternalLinkURL;
    
    CGFloat topToolbarHeight;
    
    
    NSArray *tableViewHeaders;
    
    NSMutableArray *tableViewContent;
    AppDelegate *appDelegate;
    
//    Content
    bool studentContentHidden;
    UIView *shelfView;
    UITableView *studentContentTableView;
    UITableView *assesmentsTableView;
    Student * student;
    UIImageView *studentImageView;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *uidLabel;
}

@property (nonatomic, strong) NSURL *currentURL;
- (void)loadContentDataView:(int)section :(int)row;

@end
