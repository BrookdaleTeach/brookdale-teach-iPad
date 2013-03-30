//
//  SettingsViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 3/17/13.
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import <MobileCoreServices/MobileCoreServices.h>

/*
 * Class Main Interface
 */

@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {

    /* Local Declarations */

    NSString *name;
    NSString *grade;
    NSString *email;
    NSString *phone;
    NSString *imageView;
}

/* Global Declarations */

@property (nonatomic, weak) IBOutlet MGScrollView *scroller;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIButton *buttonImageView;

@end
