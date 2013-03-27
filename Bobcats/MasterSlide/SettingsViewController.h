//
//  SettingsViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 3/17/13.
//
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate> {
    
    NSString * name;
    NSString * grade;
    NSString * email;
    NSString * phone;
    NSString * imageView;
}

@property (nonatomic, weak) IBOutlet MGScrollView *scroller;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIButton *buttonImageView;

@end
