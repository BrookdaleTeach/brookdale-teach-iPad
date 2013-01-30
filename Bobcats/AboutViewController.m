//
//  AboutViewController.m
//  DocSets
//
//  Created by Ole Zorn on 11.03.12.
//  Copyright (c) 2012 omz:software. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize webView=_webView;

- (void)loadView
{
	[super loadView];
	self.title = NSLocalizedString(@"About Bobcats", nil);
	self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.webView.delegate = self;
	self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
	[self.view addSubview:self.webView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}

- (void)done:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSURL *aboutPageURL = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@"html"];
	[self.webView loadRequest:[NSURLRequest requestWithURL:aboutPageURL]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return YES;
	}
	return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
	_webView.delegate = nil;
}

@end
