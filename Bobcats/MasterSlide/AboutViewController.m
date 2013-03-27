//
//  AboutViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */

#import "AboutViewController.h"

/*
 * Class Main Implementation
 */
@implementation AboutViewController

/* Sythesizations */

@synthesize webView = _webView;

/*
   loadView
   --------
   Purpose:        Setup View
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) loadView {
    [super loadView];
    self.title = NSLocalizedString(@"About Bobcats", nil);
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:self.webView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
} /* loadView */


/*
   done
   --------
   Purpose:        Dismiss Modal
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) done :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* done */


/*
   viewDidLoad
   --------
   Purpose:        Start Webview
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewDidLoad {
    [super viewDidLoad];
    NSURL *aboutPageURL = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:aboutPageURL]];
} /* viewDidLoad */


/*
   shouldStartLoadWithRequest
   --------
   Purpose:        Load Webview data
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) webView :(UIWebView *)webView shouldStartLoadWithRequest :(NSURLRequest *)request navigationType :(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
} /* webView */


/*
   shouldAutorotateToInterfaceOrientation
   --------
   Purpose:        Rotate Support
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    return YES;
} /* shouldAutorotateToInterfaceOrientation */


@end
