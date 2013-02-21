//
//  AboutViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate> {

    UIWebView *_webView;
}

@property (nonatomic, strong) UIWebView *webView;

@end
