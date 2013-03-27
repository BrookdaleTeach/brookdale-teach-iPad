//
//  SwipeSplitViewController.h
//  Bobcats
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import "RNBlurModalView.h"

/*
   Main Interface
 */
@interface SwipeSplitViewController : UIViewController {

    /* Local Declarations */

    UIImageView *_masterContainerView;
    UIViewController *_masterViewController;
    UIViewController *_detailViewController;

    UIView *_shieldView;

    RNBlurModalView *blurModalView;

}

/* Global Declarations */

@property (nonatomic, strong) UIImageView *masterContainerView;
@property (nonatomic, strong, readonly) UIViewController *masterViewController;
@property (nonatomic, strong, readonly) UIViewController *detailViewController;
@property (nonatomic, strong) UIView *shieldView;

/* Global Method Declarations */

- (id) initWithMasterViewController :(UIViewController *)masterVC detailViewController :(UIViewController *)detailVC;
- (void) showMasterViewControllerAnimated :(BOOL)animated;
- (void) hideMasterViewControllerAnimated :(BOOL)animated;

@end
