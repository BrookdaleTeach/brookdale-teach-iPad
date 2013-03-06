//
//  AboutViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize webView = _webView;

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


- (void) done :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* done */


- (void) viewDidLoad {
    [super viewDidLoad];
    NSURL *aboutPageURL = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:aboutPageURL]];
} /* viewDidLoad */


- (BOOL) webView :(UIWebView *)webView shouldStartLoadWithRequest :(NSURLRequest *)request navigationType :(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
} /* webView */


- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
} /* shouldAutorotateToInterfaceOrientation */


@end
