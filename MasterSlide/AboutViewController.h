//
//  AboutViewController.h
//  DocSets
//
//  Created by Ole Zorn on 11.03.12.
//  Copyright (c) 2012 omz:software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate> {

	UIWebView *_webView;
}

@property (nonatomic, strong) UIWebView *webView;

@end
