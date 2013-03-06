//
//  EditUser.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/22/13.
//
//

#import "EditUser.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import "MathAssessmentModel.h"
#import "ReadingAssessmentModel.h"
#import "WritingAssessmentModel.h"
#import "BehavioralAssessmentModel.h"

#define DATABASE_NAME      @"students.sql"
#define NUM_OBJECTS        12
#define DEFAULT_IMAGE_NAME @"default1.image"

@implementation EditUser
@synthesize imageView, popoverController, toolbar, classKey;

- (id) init:(Student *)s key:(int)k index:(NSIndexPath *)indexPath title:(NSString *)t {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Edit Student", nil);
        student = s;
        title = t;
        ip = indexPath;
        self.classKey = k;
    }
    return self;
} /* init */


- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    // Do any additional setup after loading the view from its nib.
    
    imageSavedAsDefaultTitle = NO;
    
    month = 9;
    day = 9;
    year = 9;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    userInput = [[NSMutableArray alloc] init];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView setContentSize:CGSizeMake(320, 1350)];
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    placeHolders = [[NSArray alloc] initWithObjects:[student firstName],
                    [student lastName], [student uid],
                    [NSString stringWithFormat:@"%d/%d/%d", [student dob_month], [student dob_day], [student dob_year]], nil];
    
    restTitles = [[NSArray alloc] initWithObjects:@"Email", @"Phone", @"Address", @"Parent First", @"Parent Last", @"Parent Email", @"Parent Phone", @"Relationship", nil];
    
    restValues = [[NSArray alloc] initWithObjects:[student email], [student phone], [student address], [student parent_firstName], [student parent_lastName], [student parent_email], [student parent_phone], [student relationship], nil];
        
    addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(32, 25, 108, 108)];
    addImageButton.backgroundColor = [UIColor lightTextColor];
    addImageButton.layer.cornerRadius = 2.0f;
    addImageButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    addImageButton.layer.shadowOffset = CGSizeMake(0, 0);
    addImageButton.layer.shadowRadius = 3.0f;
    [addImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addImageButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath;
    if ([AppDelegate isDemo])
        imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];
    else
        imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:imagePath]) {        
        [addImageButton setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        addImageButton.alpha = 1.0f;
    } else {
        [addImageButton setBackgroundImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
        addImageButton.alpha = .7f;
    }
    
    [addImageButton addTarget:nil action:@selector(useCameraRoll:) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:addImageButton];
    
    //
    headTableView = [[UITableView alloc] initWithFrame:CGRectMake(178, 12, 340, 190) style:UITableViewStyleGrouped];
    [headTableView setDelegate:self];
    [headTableView setDataSource:self];
    UIView *clearBackground = [[UIView alloc] initWithFrame:CGRectMake(headTableView.bounds.origin.x,
                                                                       headTableView.bounds.origin.x,
                                                                       headTableView.bounds.size.width,
                                                                       headTableView.bounds.size.height)];
    clearBackground.backgroundColor = [UIColor clearColor];
    [headTableView setBackgroundView:clearBackground];
    [scrollView addSubview:headTableView];
    
    //
    restTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 215, 400, 100 * restTitles.count) style:UITableViewStyleGrouped];
    [restTableView setDelegate:self];
    [restTableView setDataSource:self];
    clearBackground = [[UIView alloc] initWithFrame:CGRectMake(headTableView.bounds.origin.x,
                                                               headTableView.bounds.origin.x,
                                                               headTableView.bounds.size.width,
                                                               headTableView.bounds.size.height)];
    clearBackground.backgroundColor = [UIColor clearColor];
    [restTableView setBackgroundView:clearBackground];
    [scrollView addSubview:restTableView];
} /* viewDidLoad */


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
        
        imageView.image = image;
        [addImageButton setBackgroundImage:image forState:UIControlStateNormal];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:DEFAULT_IMAGE_NAME];
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
                              message:@"Failed to save image" \
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
} /* image */


- (void) viewDidUnload {
    self.imageView = nil;
    self.popoverController = nil;
    self.toolbar = nil;
} /* viewDidUnload */


- (void) imagePickerControllerDidCancel :(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
} /* imagePickerControllerDidCancel */


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} /* didReceiveMemoryWarning */


- (BOOL) updateEmployeeIntoDatabase {
    sqlite3 *database;
    
    BOOL success = YES;
    
    NSLog(@"db path: %@", appDelegate.databasePath);
    
    if (sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "UPDATE students SET firstName=?, lastName=?, fullName=?, gender=?, dob_month=?, dob_day=?, dob_year=?, image=?, uid=?, email=?, phone=?, address=?, parent_firstName=?, parent_lastName=?, parent_email=?, parent_phone=?, relationship=?, notes=?, classkey=? WHERE uid=?";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(compiledStatement, 1, [[[userInput objectAtIndex:0] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2, [[[userInput objectAtIndex:1] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [[NSString stringWithFormat:@"%@ %@", [userInput objectAtIndex:0], [userInput objectAtIndex:1]] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [@"male" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 5, month);
            sqlite3_bind_int(compiledStatement, 6, day);
            sqlite3_bind_int(compiledStatement, 7, year);
            sqlite3_bind_text(compiledStatement, 8, [[NSString stringWithFormat:@"%@.jpg", [userInput objectAtIndex:2]] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 9, [[userInput objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 10, [[[userInput objectAtIndex:4] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 11, [[[userInput objectAtIndex:5] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 12, [[[userInput objectAtIndex:6] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 13, [[[userInput objectAtIndex:7] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 14, [[[userInput objectAtIndex:8] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 15, [[[userInput objectAtIndex:9] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 16, [[[userInput objectAtIndex:10] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 17, [[[userInput objectAtIndex:11] capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 18, [[@"" capitalizedString] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 19, self.classKey);
            sqlite3_bind_text(compiledStatement, 20, [[userInput objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_reset(compiledStatement);
        } else {
            success = NO;
        }
        
        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            success = NO;
            NSLog(@"Save Error (Insert Recent): %s", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(compiledStatement);
    } else {
        success = NO;
    }
    
    sqlite3_close(database);
    
    //    [appDelegate reloadCoreData];
    
    return success;
} /* updateEmployeeIntoDatabase */


- (void) done :(id)sender {
    UIAlertView *resultMessage;
    
    if ([self verifyUserIndex]) {
        if ([self updateEmployeeIntoDatabase]) {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:DEFAULT_IMAGE_NAME];
            NSFileManager *filemanager = [NSFileManager defaultManager];
            NSError *err;
            UILabel *uid = (UILabel *)[self.view viewWithTag:3];
            
            if ([filemanager fileExistsAtPath:imagePath]) {
                
                BOOL result = [filemanager moveItemAtPath:imagePath toPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", uid.text]] error:&err];
                if (!result) {}
//                    NSLog(@"Error moving: %@", err);
                else {
//                    NSLog(@"moved image to %@", imagePath);
                }
            } else {
//                NSLog(@"Couldn't find image to move!!!");
            }
            
            resultMessage = [[UIAlertView alloc] initWithTitle:@"Success"
                                                       message:@"Student Updated"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
            
        } else {
            resultMessage = [[UIAlertView alloc] initWithTitle:@"Error"
                                                       message:@"Unable to Add Student"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        }
        
        [resultMessage show];
        
        [appDelegate reloadCoreData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadStudentTableView" object:nil];
        [self dismissModalViewControllerAnimated:YES];
                
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [userInfo setObject:ip forKey:@"indexPath"];
        [userInfo setObject:title forKey:@"view"];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"UpdateContent" object:self userInfo:userInfo];

    }
} /* done */


- (void) cancel :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* cancel */


- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
} /* shouldAutorotateToInterfaceOrientation */


- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    if (headTableView == tableView)
        return 1;
    else
        return 1;
} /* numberOfSectionsInTableView */


- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    if (headTableView == tableView)
        return 4;
    else
        return restTitles.count;
} /* tableView */


// RootViewController.m
- (UITableViewCell *) getCellContentViewTopSection :(NSString *)cellIdentifier :(NSString *)value :(int)tag {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UITextField *formTitleEntryField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 275, 30)];
    formTitleEntryField.adjustsFontSizeToFitWidth = YES;
    formTitleEntryField.text = value;
    formTitleEntryField.keyboardType = UIKeyboardTypeEmailAddress;
    formTitleEntryField.returnKeyType = UIReturnKeyNext;
    formTitleEntryField.backgroundColor = [UIColor clearColor];
    formTitleEntryField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    formTitleEntryField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    formTitleEntryField.textAlignment = NSTextAlignmentLeft;
    formTitleEntryField.tag = tag;
    formTitleEntryField.delegate = self;
    formTitleEntryField.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    formTitleEntryField.textColor = [UIColor grayColor];
    formTitleEntryField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [formTitleEntryField setEnabled:YES];
    [cell addSubview:formTitleEntryField];
    
    if (tag == 3)
        [formTitleEntryField setEnabled:NO];
        
    if (tag == 4) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.tag = 123;
        formTitleEntryField.inputView = datePicker;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tag == 1)
        [formTitleEntryField becomeFirstResponder];
    
    return cell;
} /* getCellContentViewForLogin */


- (void) datePickerValueChanged :(id)sender {
    // Use NSDateFormatter to write out the date in a friendly format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:4];
    textField.text = [df stringFromDate:datePicker.date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:datePicker.date];
    month = [components month];
    day = [components day];
    year = [components year];
} /* datePickerValueChanged */


// RootViewController.m
- (UITableViewCell *) getCellContentViewForBottomSection :(NSString *)cellIdentifier :(NSString *)text :(NSString *)value :(int)tag {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UITextField *formEntryField = [[UITextField alloc] initWithFrame:CGRectMake(155, 14, 230, 30)];
    formEntryField.adjustsFontSizeToFitWidth = YES;
    formEntryField.textColor = [UIColor blackColor];
    formEntryField.font = [UIFont systemFontOfSize:14.0f];
    formEntryField.keyboardType = UIKeyboardTypeDefault;
    formEntryField.returnKeyType = UIReturnKeyNext;
    formEntryField.backgroundColor = [UIColor clearColor];
    formEntryField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    formEntryField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    formEntryField.textAlignment = NSTextAlignmentLeft;
    formEntryField.tag = tag;
    formEntryField.text = value;
    formEntryField.delegate = self;
    formEntryField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [formEntryField setEnabled:YES];
    
    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(6, 12, 116, 20)];
    formTitleField.textColor = [UIColor darkGrayColor];
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentRight;
    formTitleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    formTitleField.text = text;
    [cell.contentView addSubview:formTitleField];
    
    [cell addSubview:formEntryField];
    
    UILabel *vLine = [[UILabel alloc] initWithFrame:CGRectMake(132, 1, 1, cell.frame.size.height - 18)];
    vLine.backgroundColor = [UIColor colorWithRed:173.0f / 255.0f green:175.0f / 255.0f blue:179.0f / 255.0f alpha:.7f];
    [cell.contentView addSubview:vLine];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
} /* getCellContentViewForPassword */


- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == headTableView) {
        NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
        cell = [headTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil) {
            cell = [self getCellContentViewTopSection:CellIdentifier1 :[placeHolders objectAtIndex:indexPath.row] :1 + indexPath.row];
        }
    } else {
        NSString *CellIdentifier2 = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
        cell = [restTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        restIndexPath = indexPath;
        
        if (cell == nil) {
            cell = [self getCellContentViewForBottomSection:CellIdentifier2 :[restTitles objectAtIndex:indexPath.row] :[restValues objectAtIndex:indexPath.row] :5 + indexPath.row];
        }
    }
    
    return cell;
} /* tableView */


- (BOOL) verifyUserIndex {
    for (int x = 0; x < NUM_OBJECTS; x++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:x + 1];
        
        if ((label.text == NULL) || [label.text isEqualToString:@""])
        {
            if (x < 4)
                break;
            else
                [userInput addObject:@" "];
        }
        else
        {
            [userInput addObject:label.text];
        }
        
        if (x == NUM_OBJECTS - 1)
        {
            return YES;
        }
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Form Incomplete"
                                                      message:@"Required field missing"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    return NO;
} /* verifyUserIndex */


- (NSString *) tableView :(UITableView *)tableView titleForFooterInSection :(NSInteger)section {
    return @"";
} /* tableView */


- (void) tableView :(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    if (tableView == headTableView)
        [headTableView deselectRowAtIndexPath:indexPath animated:YES];
    else if (tableView == restTableView)
        [restTableView deselectRowAtIndexPath:indexPath animated:YES];
    else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [restTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
} /* tableView */


@end
