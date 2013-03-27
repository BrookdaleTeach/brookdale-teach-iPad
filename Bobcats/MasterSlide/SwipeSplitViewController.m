//
//  SwipeSplitViewController.h
//  Bobcats
//
//

/* Imports */

#import "SwipeSplitViewController.h"
#import "AppDelegate.h"
#import "UIImage+UIColor.h"

/* Static Definitions */

#define MASTER_VIEW_WIDTH_PORTRAIT  384.0
#define MASTER_VIEW_WIDTH_LANDSCAPE 320.0

/* Private Declarations */

@interface SwipeSplitViewController ()
- (void) layoutViewControllers;
@end

/*
 * Class Main Implementation
 */

@implementation SwipeSplitViewController

/* Sythesizations */

@synthesize shieldView = _shieldView;
@synthesize masterContainerView = _masterContainerView;
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;

/*
   InitWithMasterViewController
   --------
   Purpose:        Initilizes Class with Views
   Parameters:     Two View Controllers
   Returns:        self
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) initWithMasterViewController :(UIViewController *)masterVC detailViewController :(UIViewController *)detailVC {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _detailViewController = detailVC;
        _masterViewController = masterVC;

        [self addChildViewController:detailVC];
        [self addChildViewController:masterVC];

        if ([AppDelegate isDemo]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo View"
                                                            message:@"You are granted full functionality although all of your data \
                                                                      will be erased once the application terminates."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return self;
} /* initWithMasterViewController */


/*
   CustomizeAppearance
   --------
   Purpose:        Custom Layout
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) customizeAppearance {
    // Create resizable images
    UIImage *gradientImage44 = [[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.9f alpha:1.0f]]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *gradientImage32 = [[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.9f alpha:1.0f]]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage32
                                       forBarMetrics:UIBarMetricsLandscapePhone];

    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],
      UITextAttributeTextColor, [UIColor lightTextColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset, [UIFont fontWithName:@"Arial-Bold" size:0.0],
      UITextAttributeFont, nil]];
} /* customizeAppearance */


/*
   CustomizeAppearance
   --------
   Purpose:        Loads View Controllers
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) loadView {
    [super loadView];

    [self customizeAppearance];

    self.detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.masterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;

    self.masterViewController.view.clipsToBounds = YES;
    self.detailViewController.view.clipsToBounds = YES;

    self.masterContainerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shadow.png"]];
    _masterContainerView.userInteractionEnabled = YES;
    _masterContainerView.contentStretch = CGRectMake(0.2, 0.2, 0.6, 0.6);
    _masterContainerView.image = nil;

    [self layoutViewControllers];

    [self.view addSubview:self.detailViewController.view];
    self.masterViewController.view.frame = CGRectInset(_masterContainerView.bounds, 3, 3);
    // self.masterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_masterContainerView addSubview:self.masterViewController.view];
    [self.view addSubview:_masterContainerView];

    /*  Turn off Swipe Ability For Now */
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.detailViewController.view addGestureRecognizer:rightSwipeRecognizer];
} /* loadView */


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
   ViewDidAppear
   --------
   Purpose:        Delegate
   Parameters:     --
   Returns:        --
   Notes:          Show Master on Portait
   Author:         Neil Burchfield
 */
- (void) viewDidAppear :(BOOL)animated {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self showMasterViewControllerAnimated:YES];
    }
} /* viewDidAppear */


/*
   NotifyUser
   --------
   Purpose:        Notifies user that they're in demo mode
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) notifyUser {
    if ([AppDelegate isDemo]) {
        [self displayBlurViewMessage:@"Demo View"
                             message:@"You are granted full functionality although all of your data will be erased once the application terminates."];
    }
} /* notifyUser */


/*
   WillRotateToInterfaceOrientation
   --------
   Purpose:        Handle Master View on orientation change
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) willRotateToInterfaceOrientation :(UIInterfaceOrientation)toInterfaceOrientation duration :(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.masterViewController viewWillDisappear:0];
    }
    if (self.shieldView) {
        [self.shieldView removeFromSuperview];
    }
} /* willRotateToInterfaceOrientation */


/*
   WillRotateToInterfaceOrientation
   --------
   Purpose:        Handle Master View on orientation change
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) willAnimateRotationToInterfaceOrientation :(UIInterfaceOrientation)toInterfaceOrientation duration :(NSTimeInterval)duration {
    [self layoutViewControllers];
} /* willAnimateRotationToInterfaceOrientation */


/*
   LayoutViewControllers
   --------
   Purpose:        Layout View Controllers
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) layoutViewControllers {
    CGSize boundsSize = self.view.bounds.size;
    CGRect masterFrame;
    CGRect detailFrame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        masterFrame = CGRectMake(-MASTER_VIEW_WIDTH_PORTRAIT, 0, MASTER_VIEW_WIDTH_PORTRAIT, boundsSize.height);
        detailFrame = self.view.bounds;
    } else {
        masterFrame = CGRectMake(0, 0, MASTER_VIEW_WIDTH_LANDSCAPE, boundsSize.height);
        detailFrame = CGRectMake(MASTER_VIEW_WIDTH_LANDSCAPE + 1, 0, boundsSize.width - MASTER_VIEW_WIDTH_LANDSCAPE - 1, boundsSize.height);
    }
    self.masterContainerView.frame = CGRectInset(masterFrame, -3, -3);
    self.masterViewController.view.frame = CGRectInset(self.masterContainerView.bounds, 3, 3);

    self.detailViewController.view.frame = detailFrame;

} /* layoutViewControllers */


/*
   DidRotateFromInterfaceOrientation
   --------
   Purpose:        Handle View after orientation change
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) didRotateFromInterfaceOrientation :(UIInterfaceOrientation)fromInterfaceOrientation {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.masterContainerView.image = nil;
    }

    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation) && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.masterViewController viewDidDisappear:YES];
    }
} /* didRotateFromInterfaceOrientation */


/*
   ShowMasterViewControllerAnimated
   --------
   Purpose:        Displays Master View
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) showMasterViewControllerAnimated :(BOOL)animated {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        return;
    }

    [self.masterViewController viewWillAppear:animated];

    CGSize boundsSize = self.view.bounds.size;
    CGRect masterFrame = CGRectMake(0, 0, MASTER_VIEW_WIDTH_PORTRAIT, boundsSize.height);

    self.masterContainerView.image = [UIImage imageNamed:@"Shadow.png"];

    void (^ transition)(void) = ^(void) {
        self.masterContainerView.frame = CGRectInset(masterFrame, -3, -3);
    };

    if (!self.shieldView) {
        _shieldView = [[UIView alloc] initWithFrame:self.view.bounds];
        _shieldView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _shieldView.backgroundColor = [UIColor clearColor];
        [_shieldView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shieldViewTapped:)]];
        UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shieldViewLeftSwipe:)];
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [_shieldView addGestureRecognizer:leftSwipeRecognizer];

        UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shieldViewRightSwipe:)];
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [_shieldView addGestureRecognizer:rightSwipeRecognizer];
    }
    self.shieldView.frame = self.view.bounds;
    [self.view insertSubview:self.shieldView belowSubview:self.masterContainerView];

    if (animated) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:transition
                         completion: ^(BOOL finished) {
             [self.masterViewController viewDidAppear:YES];
         }];
    } else {
        transition();
        [self.masterViewController viewDidAppear:NO];
    }
} /* showMasterViewControllerAnimated */


/*
   HideMasterViewControllerAnimated
   --------
   Purpose:        Hides Master View
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) hideMasterViewControllerAnimated :(BOOL)animated {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        return;
    }
    void (^ transition)(void) = ^(void) {
        [self.masterViewController viewWillDisappear:animated];
        [self layoutViewControllers];
        [self.shieldView removeFromSuperview];
    };
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:transition
                         completion: ^(BOOL finished) {
             if (finished) {
                 self.masterContainerView.image = nil;
                 [self.masterViewController viewDidDisappear:YES];
             }
         }];
    } else {
        transition();
        [self.masterViewController viewDidDisappear:NO];
    }
} /* hideMasterViewControllerAnimated */


/*
   RightSwipe
   --------
   Purpose:        Hides/Shows Master View based on swipe Gesture
   Parameters:     --
   Returns:        --
   Notes:          Currently Disabled
   Author:         Neil Burchfield
 */
- (void) rightSwipe :(UISwipeGestureRecognizer *)recognizer {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self showMasterViewControllerAnimated:YES];
    } else {
        if ([self.masterViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)self.masterViewController popViewControllerAnimated : YES];
        }
    }
} /* rightSwipe */


/*
   ShieldViewRightSwipe
   --------
   Purpose:        Swipe Gesture Right
   Parameters:     --
   Returns:        --
   Notes:          Currently Disabled
   Author:         Neil Burchfield
 */
- (void) shieldViewRightSwipe :(UISwipeGestureRecognizer *)recognizer {
    if ([self.masterViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self.masterViewController popViewControllerAnimated : YES];
    }
} /* shieldViewRightSwipe */


/*
   ShieldViewTapped
   --------
   Purpose:        Swipe Gesture Tapped Handler
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) shieldViewTapped :(UITapGestureRecognizer *)recognizer {
    [self hideMasterViewControllerAnimated:YES];
} /* shieldViewTapped */


/*
   ShieldViewLeftSwipe
   --------
   Purpose:        Swipe Gesture Left Handler
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) shieldViewLeftSwipe :(UISwipeGestureRecognizer *)recognizer {
    [self hideMasterViewControllerAnimated:YES];
} /* shieldViewLeftSwipe */


/*
   ShouldAutorotateToInterfaceOrientation
   --------
   Purpose:        Allow Orientation Changes in all directions
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    return YES;
} /* shouldAutorotateToInterfaceOrientation */


@end
