//
//  LoginViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 3/3/13.
//
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomUI.h"
#import "UserCredentials.h"

#define kLoginPassword @"brookdale"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize appDelegate, splitViewController, rootViewController, detailViewController;

- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
} /* initWithNibName */

#pragma mark -
#pragma mark Orientation (Landscape) Methods.
- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}


- (void) willRotateToInterfaceOrientation :(UIInterfaceOrientation)toInterfaceOrientation duration :(NSTimeInterval)duration {
   
    // Begin Animations
    [UIView beginAnimations:@"transformLandscape" context:nil];
    // Set Animation duration
    [UIView setAnimationDuration:1.0];
    
    // Set Animation Content based on orientation
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        // Set Login Container Frame
        [loginContainer setFrame:CGRectMake(245, 275, 320, 387)];
    }
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        // Set Login Container Frame
        [loginContainer setFrame:CGRectMake(675, 100, 320, 387)];
    }

    
    // Commit the Animations
    [UIView commitAnimations];

} /* willRotateToInterfaceOrientation */

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Hide nav bar 
    self.navigationController.navigationBarHidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardInView:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Set up login credentials
    [self setUpLogin];

    // Layout view
    [self layoutSubviews];
} /* viewDidLoad */


- (void) setUpLogin {
    // Alloc UserCredentials model
    UserCredentials *uc = [[UserCredentials alloc] init];

    // Alloc array and store model values
    NSArray *creds = [uc fetchUsernamePasswordStateFromPlist];

    // Store return in delegate
    [AppDelegate setEmail:[creds objectAtIndex:0]];
    [AppDelegate setPassword:[creds objectAtIndex:1]];
    [AppDelegate setRememberMeState:[[creds objectAtIndex:2] boolValue]];
} /* setUpLogin */


//////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// ////////////
#pragma mark -
#pragma mark Layout Methods.
//////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// ////////////
// Lays out subviews
- (void) layoutSubviews {

    // Set imageView's alpha to zero
    imageView.alpha = 0.15f;

    // Set loginButton's alpha to zero
    loginButton.alpha = 0;

    // Set demoButton's alpha to zero
    demoButton.alpha = 0;

    // Initilize Login Container
    loginContainer = [[UIView alloc] init];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        [loginContainer setFrame:CGRectMake(675, -140, 320, 387)];
    }
    else {
        [loginContainer setFrame:CGRectMake(245, -140, 320, 387)];
    }

    // Set Login Container's background color
    [loginContainer setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:.8f]];

    // Set Login Container's shadow
    [loginContainer.layer setShadowOffset:CGSizeMake(0, 3)];

    // Set Login Container's shadow opacity
    [loginContainer.layer setShadowOpacity:0.4];

    // Set Login Container's shadow radius
    [loginContainer.layer setShadowRadius:3.0f];

    // Set Login Container's layer rasterization
    [loginContainer.layer setShouldRasterize:YES];

    // Set Login Container's layer corner radius
    [loginContainer.layer setCornerRadius:12.0f];

    // Set Login Container's shadow path
    [loginContainer.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:[loginContainer bounds]
                                                                    cornerRadius:12.0f] CGPath]];

    // Setup logo for adding to container
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(116, 20, 100, 100)];

    // Append logo image to view
    [logoImageView setImage:[UIImage imageNamed:@"AboutIcon@2x"]];

    // Setup imageView's corner radius
    logoImageView.layer.cornerRadius = 10.0f;

    // Set logoImageView's alpha to zero
    logoImageView.alpha = 0;

    // Setup Login Title Label
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, loginContainer.bounds.size.width - 40, 100)];

    // Setup Login Title Label's textAlignment
    loginLabel.textAlignment = NSTextAlignmentCenter;

    // Setup Login Title Label's clear background
    loginLabel.backgroundColor = [UIColor clearColor];

    // Setup Login Title Label's text color
    loginLabel.textColor = [UIColor darkGrayColor];

    // Setup Login Title Label's text font
    loginLabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:24];

    // Setup Login Title Label's text
    loginLabel.text = @"Brookdale Elementary";

    // Setup Login Title Label's alpha to zero
    loginLabel.alpha = 0;

    // Setup table view's login
    loginTableView = [[UITableView alloc] initWithFrame:loginContainer.bounds style:UITableViewStyleGrouped];

    // Setup table view's datasource
    [loginTableView setDataSource:self];

    // Setup table view's delegate
    [loginTableView setDelegate:self];

    // Set table view's alpha to zero
    loginTableView.alpha = 0;

    // Create clear background
    UIView *clearBackground = [[UIView alloc] initWithFrame:loginTableView.bounds];

    // Create clear background's color
    [clearBackground setBackgroundColor:[UIColor clearColor]];

    // Append clear background to tableview
    [loginTableView setBackgroundView:clearBackground];

    // Create Remember me label
    UILabel *remMeLabel = [CustomUI makeLabel:@"Remember Me?" x_value:15 y_value:335 width:135 height:20 back_color:[UIColor clearColor] font:[UIFont fontWithName:@"ChalkboardSE-Regular" size:17.5f] text_color:[UIColor darkGrayColor] linebreakmode:NSLineBreakByWordWrapping shadow_color:[UIColor lightGrayColor] shadow_off:CGSizeMake(0, 1)];

    // Set remember me label's alpha to zero
    remMeLabel.alpha = 0;

    // Setup remember me switch
    remMeCntl = [[UISwitch alloc] initWithFrame:CGRectMake(226, 331, 58, 19)];

    // Setup remember me alpha to zero
    remMeCntl.alpha = 0;

    // Set state
    [remMeCntl setOn:[AppDelegate getRememberMeState]];

    // Add remember me label to login container
    [loginContainer addSubview:remMeLabel];

    // Add login label to login container
    [loginContainer addSubview:loginLabel];

    // Add login logo image to login container
    [loginContainer addSubview:logoImageView];

    // Add table view to login container
    [loginContainer addSubview:loginTableView];

    // Add remember me controller to container
    [loginContainer addSubview:remMeCntl];

    // Add container to navigation controller
    [self.view addSubview:loginContainer];


    // Begin Animations
    [UIView beginAnimations:@"fade" context:nil];
    // Set Animation duration
    [UIView setAnimationDuration:1.0];
    // Set Animation Content

    // Set Tableview Frame
    [loginTableView setFrame:CGRectMake(loginTableView.bounds.origin.x,
                                        loginTableView.bounds.origin.y + 173,
                                        loginTableView.bounds.size.width,
                                        loginTableView.bounds.size.height)];

    // Set Login Container Frame    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        [loginContainer setFrame:CGRectMake(675, 100, 320, 387)];
    }
    else {
        [loginContainer setFrame:CGRectMake(245, 275, 320, 387)];
    }

    // Set Remember me cntl to full alpha
    remMeCntl.alpha = 1.0f;

    // Set Remember me label to full alpha
    remMeLabel.alpha = 1.0f;

    // Set Login label to full alpha
    loginLabel.alpha = 1.0f;

    // Set Login logo to full alpha
    logoImageView.alpha = 1.0f;

    // Set Login image to full alpha
    imageView.alpha = 1.0f;

    // Set Login table view to full alpha
    loginTableView.alpha = 1.0f;

    // Add Login Button
    [self drawLoginButton];

    // Add Demo Button
    [self drawDemoButton];

    // Commit the Animations
    [UIView commitAnimations];
} /* layoutSubviews */

/*
   cacheCredentialsInPlist
   --------
   Purpose:        Cache User Creds in Plist (temporary)
   Parameters:     none
   Returns:        none
   Notes:          Writes Creds to .plist
   Author:         Neil Burchfield
 */
- (BOOL) cacheCredentialsInPlist {
    if ([self cacheUsersCredentialsOffline]) {
        /* Cache User Credentials From KeyChain */
        UserCredentials *userCredentials = [[UserCredentials alloc] init];
        if ([userCredentials initilize:NO]) {
            [userCredentials writeUsernamePasswordStateToPlist:loginId.text password:password.text state:YES];
            [self setUpLogin];
            return YES;
        }
        return NO;
    }
    else
    {
        return NO;
    }
} /* cacheCredentialsInPlist */


/*
   cacheUsersCredentialsOffline
   --------
   Purpose:        Cache User Creds
   Parameters:     none
   Returns:        none
   Notes:          Writes Creds to .plist and
                 sets them in KeyChain
   Author:         Neil Burchfield
 */
- (BOOL) cacheUsersCredentialsOffline {

    if ((loginId.text != nil) && ![loginId.text isEqualToString:@""] &&
        ( password.text != nil) && ![password.text isEqualToString:@""]) {
        return remMeCntl.on;
    } else {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"Missing Required Credential"
                                                         message:@"Please update your email address and/or password"
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        alView.delegate = self;
        [alView show];

        return NO;
    }
} /* cacheUsersCredentialsOffline */


/*
   KeyboardInView
   --------
   Purpose:        Handle Keyboard Notifs
   Parameters:     none
   Returns:        none
   Notes:          Keyboard in view
   Author:         Neil Burchfield
 */
- (void) keyboardInView :(id)sender {
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        [UIView beginAnimations:@"scrollup" context:nil];
        [UIView setAnimationDuration:0.5f];
            [loginContainer setFrame:CGRectMake(675, 20, 320, 387)];
        [UIView commitAnimations];
        
    }
} /* keyboardInView */


/*
   DisplayBlurViewMessage
   --------
   Purpose:        General Blur Modal Object
   Parameters:     -- title
   -- message
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) displayBlurViewMessage :(NSString *)title message :(NSString *)mes {
    blurModalView = [[RNBlurModalView alloc] initWithViewController:self title:title message:mes];
    [blurModalView show];
} /* displayBlurViewMessage */


/*
   DismissBlurViewMessage
   --------
   Purpose:        General Blur Modal Object
   Parameters:     --
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) dismissBlurViewMessage {
    [blurModalView hide];
    return ![blurModalView isVisible];
} /* dismissBlurViewMessage */


/*
   KeyboardHidden
   --------
   Purpose:        Handle Keyboard Notifs
   Parameters:     none
   Returns:        none
   Notes:          Keyboard hidden
   Author:         Neil Burchfield
 */
- (void) keyboardHidden :(id)sender {
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {

        [UIView beginAnimations:@"scrolldown" context:nil];
        [UIView setAnimationDuration:0.8f];
            [loginContainer setFrame:CGRectMake(675, 100, 320, 387)];
        [UIView commitAnimations];
    }
} /* keyboardHidden */


/*
   DrawLoginButton
   --------
   Purpose:        Draw Login Button
   Parameters:     none
   Returns:        none
   Notes:          Alloc/Create/Add Login Button
   Author:         Neil Burchfield
 */
- (void) drawLoginButton {

    // Alloc Login Button
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 142, 33)];

    // Setup Login Button Background
    [loginButton setBackgroundImage:[UIImage imageNamed:@"gray-action-button-background"] forState:UIControlStateNormal];

    // Setup Login Button Background Highlighted
    [loginButton setBackgroundImage:[UIImage imageNamed:@"gray-action-button-background-pressed"] forState:UIControlStateHighlighted];

    // Setup Login Button Action
    [loginButton addTarget:self action:@selector(loadRootView:) forControlEvents:UIControlEventTouchUpInside];

    // Setup Login Button Title Color
    [loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    // Setup Login Button Title Color Highlighted
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    // Setup Login Button Title text
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];

    // Setup Login Button Font
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];

    // Setup Login Button to full alpha
    loginButton.alpha = 1.0f;

    // Add Button To table view
    [loginTableView addSubview:loginButton];
} /* drawLoginButton */


/*
   DrawDemoButton
   --------
   Purpose:        Draw Demo Button
   Parameters:     none
   Returns:        none
   Notes:          Alloc/Create/Add Login Button
   Author:         Neil Burchfield
 */
- (void) drawDemoButton {

    // Alloc Demo Button
    demoButton = [[UIButton alloc] initWithFrame:CGRectMake(164, 110, 142, 33)];

    // Setup Demo Button Background
    [demoButton setBackgroundImage:[UIImage imageNamed:@"gray-action-button-background"] forState:UIControlStateNormal];

    // Setup Demo Button Background Highlighted
    [demoButton setBackgroundImage:[UIImage imageNamed:@"gray-action-button-background-pressed"] forState:UIControlStateHighlighted];

    // Setup Demo Button Action
    [demoButton addTarget:self action:@selector(loadRootView:) forControlEvents:UIControlEventTouchUpInside];

    // Setup Demo Button Title Color
    [demoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    // Setup Demo Button Title Color Highlighted
    [demoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    // Setup Demo Button Title text
    [demoButton setTitle:@"Demo" forState:UIControlStateNormal];

    // Setup Demo Button Font
    demoButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];

    // Setup Demo Button to full alpha
    demoButton.alpha = 1.0f;

    // Add Button To table view
    [loginTableView addSubview:demoButton];
} /* drawDemoButton */


- (void) createMBProgressHUD :(SEL)selector {

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"Initilizing Application...";
    HUD.square = YES;

    [HUD showWhileExecuting:selector onTarget:self withObject:nil animated:YES];

} /* createMBProgressHUDViewForLogin */


- (void) loadRootView :(id)sender {

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (sender == loginButton) {
        if ([password.text isEqualToString:kLoginPassword]) {
            if ([self cacheCredentialsInPlist]) {
                [appDelegate loadApplicationFromLogin:NO];
                [self createMBProgressHUD:@selector(loadApplicationRoot:)];
            }
        } else
            return;
    } else if (sender == demoButton) {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                         message:@"Loading this application in demo mode will remove all previous data"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Proceed", nil];
        alView.delegate = self;
        alView.tag = 912;
        [alView show];
    }
} /* loadRootView */


- (void) alertView :(UIAlertView *)alertView willDismissWithButtonIndex :(NSInteger)buttonIndex {

    if ((alertView.tag == 912) && (buttonIndex == 1)) {
        UserCredentials *uc = [[UserCredentials alloc] init];
        [uc writeDemoStateIntoPlist:YES];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] loadApplicationFromDemo];
        [self createMBProgressHUD:@selector(loadApplicationRoot:)];
    }

} /* alertView */


- (void) loadApplicationRoot :(id)sender {
    [self performSelectorOnMainThread:@selector(pushRootControllerAnimated:) withObject:self waitUntilDone:YES];
} /* loadApplicationRoot */


- (void) pushRootControllerAnimated :(id)sender {

    self.rootViewController = [[MasterViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

    self.detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *detailRoot = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
    self.splitViewController = [[SwipeSplitViewController alloc] initWithMasterViewController:rootNavigationController
                                                                         detailViewController:detailRoot];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:self.splitViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
} /* pushRootControllerAnimated */


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} /* didReceiveMemoryWarning */

/*
   NumberOfRowsInSection
   --------
   Purpose:        Tableview Delegate
   Parameters:     none
   Returns:        none
   Notes:          Number of Tableview Rows
   Author:         Neil Burchfield
 */
- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    return 2;
} /* tableView */


/*
   CellForRowAtIndexPath
   --------
   Purpose:        Tableview Cell Delegate
   Parameters:     none
   Returns:        none
   Notes:          View for Cell
   Author:         Neil Burchfield
 */
- (UITableViewCell *) tableView :(UITableView *)table cellForRowAtIndexPath :(NSIndexPath *)indexPath {

    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if ( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

    if (indexPath.row == 0) {
        loginId = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        loginId.placeholder = @"Login";
        loginId.autocorrectionType = UITextAutocorrectionTypeNo;
        loginId.returnKeyType = UIReturnKeyNext;
        loginId.keyboardType = UIKeyboardTypeEmailAddress;
        if ([AppDelegate getRememberMeState])
            loginId.text = [AppDelegate getEmail];
        else
            loginId.text = @"";
        [loginId setClearButtonMode:UITextFieldViewModeAlways];
        cell.accessoryView = loginId;
    }
    if (indexPath.row == 1) {
        password = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        password.placeholder = @"Password";
        password.secureTextEntry = YES;
        password.returnKeyType = UIReturnKeyDefault;
        password.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        password.autocorrectionType = UITextAutocorrectionTypeNo;
        if ([AppDelegate getRememberMeState])
            password.text = [AppDelegate getPassword];
        else
            password.text = @"";
        [password setClearButtonMode:UITextFieldViewModeAlways];
        cell.accessoryView = password;
    }
    loginId.delegate = self;
    password.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
} /* tableView */


/*
   NumberOfSectionsInTableView
   --------
   Purpose:        Tableview Sections Delegate
   Parameters:     none
   Returns:        none
   Notes:          Number of sections
   Author:         Neil Burchfield
 */
- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    return 1;
} /* numberOfSectionsInTableView */


/*
   textFieldShouldReturn
   --------
   Purpose:        TextField Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) textFieldShouldReturn :(UITextField *)textField {

    if (textField == loginId) {
        [password becomeFirstResponder];
    } else if (textField == password) {
        [textField resignFirstResponder];
    }

    return YES;
} /* textFieldShouldReturn */


@end
