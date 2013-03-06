//
//  SwipeSplitViewController.h
//  Bobcats
//
//

#import <UIKit/UIKit.h>
#import "RNBlurModalView.h"

@interface SwipeSplitViewController : UIViewController {

    UIImageView *_masterContainerView;
    UIViewController *_masterViewController;
    UIViewController *_detailViewController;

    UIView *_shieldView;
    
    RNBlurModalView *blurModalView;

}

@property (nonatomic, strong) UIImageView *masterContainerView;
@property (nonatomic, strong, readonly) UIViewController *masterViewController;
@property (nonatomic, strong, readonly) UIViewController *detailViewController;
@property (nonatomic, strong) UIView *shieldView;

- (id) initWithMasterViewController :(UIViewController *)masterVC detailViewController :(UIViewController *)detailVC;
- (void) showMasterViewControllerAnimated :(BOOL)animated;
- (void) hideMasterViewControllerAnimated :(BOOL)animated;

@end
