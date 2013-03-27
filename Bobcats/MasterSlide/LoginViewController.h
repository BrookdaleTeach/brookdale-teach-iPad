//
//  LoginViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 3/3/13.
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SwipeSplitViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RNBlurModalView.h"
#import "SettingsViewController.h"

/*
   Main Interface
 */
@interface LoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {

    /* Local Declarations */

    UITableView *loginTableView;
    UITextField *loginId;
    UITextField *password;

    UIButton *loginButton;
    UIButton *demoButton;

    IBOutlet UIImageView *imageView;

    UIView *loginContainer;

    UISwitch *remMeCntl;

    RNBlurModalView *blurModalView;

    BOOL isSettingsHidden;
}

/* Global Declarations */

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) SettingsViewController *settingsViewController;
@property (nonatomic, strong) SwipeSplitViewController *splitViewController;
@property (nonatomic, strong) MasterViewController *rootViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;

/* Global Method Declarations */

- (void) keyboardInView :(id)sender;
- (void) keyboardHidden :(id)sender;

@end
