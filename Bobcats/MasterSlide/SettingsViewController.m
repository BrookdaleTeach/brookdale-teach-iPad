//
//  SettingsViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 3/17/13.
//
//

/* Imports */

#import "SettingsViewController.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "AppDelegate.h"
#import "TeacherSettings.h"
#import "Util.h"

/*
 * Class Main Implementation
 */

@implementation SettingsViewController

/* Synthesizations */

@synthesize scroller;
@synthesize popoverController;
@synthesize buttonImageView;

/*
   viewDidLoad
   --------
   Purpose:        Initilizes Class with Views
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldWriteToPlist)
                                                 name:kSettingsShouldSaveNotification
                                               object:nil];

    // Do any additional setup after loading the view from its nib.
    [self shouldRetainPlistData];

    [self setButtonView];

} /* viewDidLoad */


/*
   setButtonView
   --------
   Purpose:        Set Teacher Image Button
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) setButtonView {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:kTeacherImageDefault];

    NSFileManager *filemanager = [NSFileManager defaultManager];

    if (!buttonImageView) {
        buttonImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonImageView.frame = CGRectMake(0, 0, 40, 40);
        buttonImageView.layer.cornerRadius = 4.0f;
        buttonImageView.layer.borderWidth = .8f;
        buttonImageView.layer.borderColor = [[UIColor scrollViewTexturedBackgroundColor] CGColor];
        [buttonImageView addTarget:self action:@selector(useCameraRoll:) forControlEvents:UIControlEventTouchDown];
    }

    if ([filemanager fileExistsAtPath:imagePath]) {
        [buttonImageView setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    } else {
        [buttonImageView setBackgroundImage:[UIImage imageNamed:kTeacherNoCustomImage] forState:UIControlStateNormal];
    }
} /* setButtonView */


/*
   viewWillAppear
   --------
   Purpose:        Appear Inits
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor clearColor];

    [self loadSettingsSection];
} /* viewWillAppear */


/*
   loadSettingsSection
   --------
   Purpose:        Loads Settings Data
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) loadSettingsSection {

    self.scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view insertSubview:self.scroller aboveSubview:self.view];

    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [self.scroller.boxes addObject:section];

    // Scroller Rows
    // a default row size
    CGSize rowSize = (CGSize) {667, 38 };

    // a string on the left and a horse on the right
    MGLineStyled *firstSectionHeader = [MGLineStyled lineWithLeft:@"Teacher Information"
                                                            right:nil size:(CGSize) {667, 45 }];
    firstSectionHeader.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:17.0f];
    [section.topLines addObject:firstSectionHeader];

    // a string on the left and a horse on the right
    MGLineStyled *row1 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherName]
                                              right:[self texfieldWithTag:1 andText:name andKeyboardType:UIKeyboardTypeDefault] size:rowSize];
    row1.leftPadding = 35.0f;
    [section.topLines addObject:row1];

    // a string on the left and a horse on the right
    MGLineStyled *row2 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherGrade]
                                              right:[self texfieldWithTag:2 andText:grade andKeyboardType:UIKeyboardTypeNumberPad] size:rowSize];
    row2.leftPadding = 35.0f;
    [section.topLines addObject:row2];


    // a string on the left and a horse on the right
    MGLineStyled *row3 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherEmail]
                                              right:[self texfieldWithTag:3 andText:email andKeyboardType:UIKeyboardTypeEmailAddress] size:rowSize];
    row3.leftPadding = 35.0f;
    [section.topLines addObject:row3];


    // a string on the left and a horse on the right
    MGLineStyled *row4 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherPhone]
                                              right:[self texfieldWithTag:4 andText:phone andKeyboardType:UIKeyboardTypePhonePad] size:rowSize];
    row4.leftPadding = 35.0f;
    [section.topLines addObject:row4];

    // a string on the left and a horse on the right
    MGLineStyled *row5 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherImage]
                                              right:buttonImageView size:rowSize];
    row5.height = 50.0f;
    row5.leftPadding = 35.0f;
    [section.topLines addObject:row5];

//    // a string on the left and a horse on the right
//    MGLineStyled *secondSectionHeader = [MGLineStyled lineWithLeft:@"Application Settings"
//                                                             right:nil size:(CGSize) {667, 45 }];
//    secondSectionHeader.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:17.0f];
//    [section.topLines addObject:secondSectionHeader];
//
//    // a string on the left and a horse on the right
//    MGLineStyled *row6 = [MGLineStyled lineWithLeft:@"Default Assessment Status (B,D,S)"
//                                                       right:[self texfieldWithTag:5 andText:status andKeyboardType:UIKeyboardTypeDefault] size:rowSize];
//    row6.leftPadding = 35.0f;
//    [section.topLines addObject:row6];
//
//
    [scroller layoutWithSpeed:0.3 completion:nil];
} /* loadSettingsSection */


/*
   texfieldWithTag
   --------
   Purpose:        Creates TextView
   Parameters:     NSInteger, NSString, UIKeyboardType
   Returns:        UITextField
   Notes:          --
   Author:         Neil Burchfield
 */
- (UITextField *) texfieldWithTag :(NSInteger)tag andText :(NSString *)text andKeyboardType :(UIKeyboardType)keyboardType {
    UITextField *texfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 530, 30)];
    texfield.backgroundColor = [UIColor clearColor];
    texfield.keyboardType = keyboardType;
    texfield.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    texfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    texfield.tag = tag;
    texfield.text = text;

    if (tag == 1)
        [texfield becomeFirstResponder];

    if (tag <= 3) {
        texfield.returnKeyType = UIReturnKeyNext;
    } else if (tag == 5) {
        texfield.frame = CGRectMake(0, 0, 300, 30);
        texfield.textAlignment = NSTextAlignmentRight;
        
        NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]
                                                   initWithContentsOfFile:[self pathToFollowingResource:kTeacherSettingsPlist]];
        
        if ([settingsDictionary objectForKey:kTeacherAssStat])
            [texfield setText:[NSArray arrayWithObject:[settingsDictionary objectForKey:kTeacherAssStat]]];
        else
            texfield.text = @"B";
    } else {
        texfield.returnKeyType = UIReturnKeyDone;
    }

    texfield.delegate = self;
    return texfield;
} /* texfieldWithTag */


/*
   textFieldShouldReturn
   --------
   Purpose:        Dismiss TextView
   Parameters:     textField
   Returns:        BOOL
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) textFieldShouldReturn :(UITextField *)textField {

    UITextField *textFieldName = (UITextField *)[self.view viewWithTag:1];
    UITextField *textFieldGrade = (UITextField *)[self.view viewWithTag:2];
    UITextField *textFieldEmail = (UITextField *)[self.view viewWithTag:3];
    UITextField *textFieldPhone = (UITextField *)[self.view viewWithTag:4];

    switch (textField.tag) {
        case 1 :
            [textFieldGrade becomeFirstResponder];
            break;
        case 2 :
            [textFieldEmail becomeFirstResponder];
            break;
        case 3 :
            [textFieldPhone becomeFirstResponder];
            break;
        case 5 :
            [textFieldName becomeFirstResponder];
            break;
        default :
            [textField resignFirstResponder];
            break;
    } /* switch */

    return YES;
} /* textFieldShouldReturn */


/*
   texfieldWithTag
   --------
   Purpose:        Creates Button
   Parameters:     NSString, SEL
   Returns:        UIButton
   Notes:          --
   Author:         Neil Burchfield
 */
- (UIButton *) button :(NSString *)title for :(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [button setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9]
                 forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.2 alpha:0.9]
                       forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    CGSize size = [title sizeWithFont:button.titleLabel.font];
    button.frame = CGRectMake(0, 0, size.width + 18, 26);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector
     forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 3;
    button.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 1);
    button.layer.shadowRadius = 0.8;
    button.layer.shadowOpacity = 0.6;
    return button;
} /* button */


/*
   shouldWriteToPlist
   --------
   Purpose:        Writes Input to plist
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) shouldWriteToPlist {

    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc] init];

    UITextField *textFieldName = (UITextField *)[self.view viewWithTag:1];
    UITextField *textFieldGrade = (UITextField *)[self.view viewWithTag:2];
    UITextField *textFieldEmail = (UITextField *)[self.view viewWithTag:3];
    UITextField *textFieldPhone = (UITextField *)[self.view viewWithTag:4];
    UITextField *textFieldStatus = (UITextField *)[self.view viewWithTag:5];

    [settingsDictionary setValue:(NSString *)textFieldName.text forKey:kTeacherName];
    [settingsDictionary setValue:(NSString *)textFieldGrade.text forKey:kTeacherGrade];
    [settingsDictionary setValue:(NSString *)textFieldEmail.text forKey:kTeacherEmail];
    [settingsDictionary setValue:(NSString *)textFieldPhone.text forKey:kTeacherPhone];
    [settingsDictionary setValue:(NSString *)textFieldStatus.text forKey:kTeacherAssStat];

    [settingsDictionary writeToFile:[self pathToFollowingResource:kTeacherSettingsPlist] atomically:YES];
} /* shouldWriteToPlist */


/*
   shouldRetainPlistData
   --------
   Purpose:        Reads Input from plist
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) shouldRetainPlistData {

    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathToFollowingResource:kTeacherSettingsPlist]];

    name = [settingsDictionary objectForKey:kTeacherName];
    grade = [settingsDictionary objectForKey:kTeacherGrade];
    email = [settingsDictionary objectForKey:kTeacherEmail];
    phone = [settingsDictionary objectForKey:kTeacherPhone];
    status = [settingsDictionary objectForKey:kTeacherAssStat];
    
} /* shouldRetainPlistData */


/*
   pathToFollowingResource
   --------
   Purpose:        Retains plist path
   Parameters:     NSString
   Returns:        NSString
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) pathToFollowingResource :(NSString *)resource {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *plistFile = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:resource];

    return plistFile;
} /* plistPath */


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


# pragma Camera Delegates

/*
   useCameraRoll
   --------
   Purpose:        Camera Roll Instance
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) useCameraRoll :(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.delegate = self;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        cameraPicker.allowsEditing = NO;

        UIImagePickerController *cameraRollPicker = [[UIImagePickerController alloc] init];
        cameraRollPicker.delegate = self;
        cameraRollPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraRollPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        cameraRollPicker.allowsEditing = NO;

        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[cameraPicker, cameraRollPicker];
        [[tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Camera"];
        [[tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Camera Roll"];

        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:tabBarController];
        self.popoverController.delegate = self;

        [self.popoverController presentPopoverFromRect:CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2, 1, 1) inView:self.view permittedArrowDirections:0 animated:YES];
    } else {
        NSLog(@"Camera ROLL NOT availiable!!!");
    }
} /* useCameraRoll */


/*
   imagePickerController
   --------
   Purpose:        Camera Roll Existing Images Selection Instance
   Parameters:     UIImagePickerController, NSDictionary
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) imagePickerController :(UIImagePickerController *)picker didFinishPickingMediaWithInfo :(NSDictionary *)info {
    [self.popoverController dismissPopoverAnimated:true];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];

        [buttonImageView setBackgroundImage:image forState:UIControlStateNormal];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:kTeacherImageDefault];
        NSFileManager *filemanager = [NSFileManager defaultManager];
        [filemanager removeItemAtPath:imagePath error:nil];
        [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imagePath atomically:YES];

        if ([filemanager fileExistsAtPath:imagePath])
            NSLog(@"successfully saved");
        else
            NSLog(@"image not saved");
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // Code here to support video if enabled
    }
} /* imagePickerController */


/*
   finishedSavingWithError
   --------
   Purpose:        Camera Roll Error Handler
   Parameters:     NSError, UIImage
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) image :(UIImage *)image finishedSavingWithError :(NSError *)error contextInfo :(void *)contextInfo {
    if (error) {
        Alert(@"Save failed", @"Failed to save Teacher's image");
    }
} /* image */


/*
   shouldChangeCharactersInRange
   --------
   Purpose:        Format Phone Input
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) textField :(UITextField *)textField shouldChangeCharactersInRange :(NSRange)range replacementString :(NSString *)string {
    NSString *totalString = [NSString stringWithFormat:@"%@%@", textField.text, string];

    if ( textField.tag == 4 ) {
        if (range.length == 1) {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        return NO;
    }
    return YES;
} /* textField */


/*
   formatPhoneNumber
   --------
   Purpose:        Format Phone Input
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) formatPhoneNumber :(NSString *)simpleNumber deleteLastChar :(BOOL)deleteLastChar {
    if (simpleNumber.length == 0)
        return @"";

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];

    if (simpleNumber.length > 10) {
        simpleNumber = [simpleNumber substringToIndex:10];
    }

    if (deleteLastChar) {
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }

    if (simpleNumber.length < 7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];

    else
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
} /* formatPhoneNumber */

@end
































