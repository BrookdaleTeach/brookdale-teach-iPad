//
//  SettingsViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 3/17/13.
//
//

#import "SettingsViewController.h"

#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "AppDelegate.h"
#import "TeacherSettings.h"

@implementation SettingsViewController
@synthesize scroller, popoverController, buttonImageView;

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


- (void) viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor clearColor];

    [self loadSettingsSection];
} /* viewWillAppear */


- (void) viewWillDisappear :(BOOL)animated {
    [super viewWillDisappear:animated];
} /* viewWillDisappear */


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} /* didReceiveMemoryWarning */


- (void) loadSettingsSection {

    self.scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view insertSubview:self.scroller aboveSubview:self.view];

    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [self.scroller.boxes addObject:section];

    // Scroller Rows
    // a default row size
    CGSize rowSize = (CGSize) {667, 55 };

    // a string on the left and a horse on the right
    MGLineStyled *header = [MGLineStyled lineWithLeft:@"Teacher Information"
                                                right:nil size:(CGSize) {667, 45 }];
    header.leftPadding = 242.0f;
    header.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:21.0f];
    [section.topLines addObject:header];

    // a string on the left and a horse on the right
    MGLineStyled *row1 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherName]
                                              right:[self texfieldWithTag:1 andText:name andKeyboardType:UIKeyboardTypeDefault] size:rowSize];
    [section.topLines addObject:row1];

    // a string on the left and a horse on the right
    MGLineStyled *row2 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherGrade]
                                              right:[self texfieldWithTag:2 andText:grade andKeyboardType:UIKeyboardTypeNumberPad] size:rowSize];
    [section.topLines addObject:row2];


    // a string on the left and a horse on the right
    MGLineStyled *row3 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherEmail]
                                              right:[self texfieldWithTag:3 andText:email andKeyboardType:UIKeyboardTypeEmailAddress] size:rowSize];
    [section.topLines addObject:row3];


    // a string on the left and a horse on the right
    MGLineStyled *row4 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherPhone]
                                              right:[self texfieldWithTag:4 andText:phone andKeyboardType:UIKeyboardTypePhonePad] size:rowSize];
    [section.topLines addObject:row4];

    // a string on the left and a horse on the right
    MGLineStyled *row5 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@:", kTeacherImage]
                                              right:buttonImageView size:rowSize];
    row5.height = 50.0f;
    [section.topLines addObject:row5];

    [scroller layoutWithSpeed:0.3 completion:nil];
} /* loadSettingsSection */


- (UITextField *) texfieldWithTag :(NSInteger)tag andText :(NSString *)text andKeyboardType :(UIKeyboardType)keyboardType {
    UITextField *texfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 565, 30)];
    texfield.backgroundColor = [UIColor clearColor];
    texfield.keyboardType = keyboardType;
    texfield.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    texfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    texfield.tag = tag;
    texfield.text = text;
    return texfield;
} /* texfieldWithTag */


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


- (void) shouldWriteToPlist {

    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc] init];

    UITextField *textFieldName = (UITextField *)[self.view viewWithTag:1];
    UITextField *textFieldGrade = (UITextField *)[self.view viewWithTag:2];
    UITextField *textFieldEmail = (UITextField *)[self.view viewWithTag:3];
    UITextField *textFieldPhone = (UITextField *)[self.view viewWithTag:4];

    [settingsDictionary setValue:(NSString *)textFieldName.text forKey:kTeacherName];
    [settingsDictionary setValue:(NSString *)textFieldGrade.text forKey:kTeacherGrade];
    [settingsDictionary setValue:(NSString *)textFieldEmail.text forKey:kTeacherEmail];
    [settingsDictionary setValue:(NSString *)textFieldPhone.text forKey:kTeacherPhone];

    [settingsDictionary writeToFile:[self pathToFollowingResource:kTeacherSettingsPlist] atomically:YES];
} /* shouldWriteToPlist */


- (void) shouldRetainPlistData {

    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathToFollowingResource:kTeacherSettingsPlist]];

    name = [settingsDictionary objectForKey:kTeacherName];
    grade = [settingsDictionary objectForKey:kTeacherGrade];
    email = [settingsDictionary objectForKey:kTeacherEmail];
    phone = [settingsDictionary objectForKey:kTeacherPhone];

} /* shouldRetainPlistData */


- (NSString *) pathToFollowingResource :(NSString *)resource {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *plistFile = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:resource];

    return plistFile;
} /* plistPath */


- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
} /* shouldAutorotateToInterfaceOrientation */


///////// //////// ///////// //////// ///////// //////// ///////// //////// ///////// //////// ///////// ////////
# pragma Camera Delegates

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


- (void) image :(UIImage *)image finishedSavingWithError :(NSError *)error contextInfo :(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Save failed"
                                        message:@"Failed to save Teacher's image" \
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
} /* image */


@end
































