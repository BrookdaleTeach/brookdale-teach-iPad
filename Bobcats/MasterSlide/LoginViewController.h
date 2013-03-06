//
//  LoginViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 3/3/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

// Login Imports
#import "AppDelegate.h"
#import "SwipeSplitViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

#import "RNBlurModalView.h"

@interface LoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    
    UITableView *loginTableView;
    UITextField *loginId;
    UITextField *password;
    
    UIButton *loginButton;
    UIButton *demoButton;

    IBOutlet UIImageView *imageView;
    
    UIView *loginContainer;
    
    UISwitch *remMeCntl;
    
    RNBlurModalView *blurModalView;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) SwipeSplitViewController *splitViewController;
@property (nonatomic, strong) MasterViewController *rootViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;


- (void)keyboardInView:(id)sender;
- (void)keyboardHidden:(id)sender;

@end
