//
//  AddStudentView.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

#import "AddStudentView.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>

#define DATABASE_NAME @"students.sql"
#define NUM_OBJECTS 11

@implementation AddStudentView
@synthesize imageView, popoverController, toolbar;

- (id)init
{
    self = [super init];
    if (self) {
		self.title = NSLocalizedString(@"Add Student", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    userInput = [[NSMutableArray alloc] init];

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView setContentSize:CGSizeMake(320,1200)];
    [self.view addSubview:scrollView];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    placeHolders = [[NSArray alloc] initWithObjects:@"First", @"Last", @"ID", nil];
    restTitles = [[NSArray alloc] initWithObjects:@"Email", @"Phone", @"Address", @"Parent First", @"Parent Last", @"Parent Email", @"Parent Phone", @"Relationship", nil];
//    restPlaceHolders = [[NSArray alloc] initWithObjects:@"Phone", @"Home", @"Company", @"Email", nil];

    addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(32, 25, 108, 108)];
    addImageButton.backgroundColor = [UIColor lightTextColor];
    addImageButton.layer.cornerRadius = 2.0f;
    addImageButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    addImageButton.layer.shadowOffset = CGSizeMake(0, 0);
    addImageButton.layer.shadowRadius = 3.0f;
    [addImageButton setTitle:@"Add Image" forState:UIControlStateNormal];
    [addImageButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [addImageButton setTitleColor: [UIColor lightTextColor] forState: UIControlStateHighlighted];
    addImageButton.alpha = .7f;
    [addImageButton addTarget:nil action:@selector(useCamera:) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:addImageButton];
    
//    
    headTableView = [[UITableView alloc] initWithFrame:CGRectMake(178, 12, 340, 160) style:UITableViewStyleGrouped];
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
    restTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 176, 400, 100 * restTitles.count) style:UITableViewStyleGrouped];
    [restTableView setDelegate:self];
    [restTableView setDataSource:self];
    clearBackground = [[UIView alloc] initWithFrame:CGRectMake(headTableView.bounds.origin.x,
                                                                       headTableView.bounds.origin.x,
                                                                       headTableView.bounds.size.width,
                                                                       headTableView.bounds.size.height)];
    clearBackground.backgroundColor = [UIColor clearColor];
    [restTableView setBackgroundView:clearBackground];
    [scrollView addSubview:restTableView];
}

- (void) useCamera: (id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self.navigationController pushViewController:imagePicker animated:YES];
        newMedia = YES;
    }
    else
    {
        NSLog(@"Camera NOT availiable!!!");
    }
}

- (IBAction) useCameraRoll: (id)sender
{
    if ([self.popoverController isPopoverVisible]) {
        [self.popoverController dismissPopoverAnimated:YES];
        [popoverController release];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            
            self.popoverController = [[UIPopoverController alloc]
                                      initWithContentViewController:imagePicker];
            
            popoverController.delegate = self;
            
            [self.popoverController
             presentPopoverFromBarButtonItem:sender
             permittedArrowDirections:UIPopoverArrowDirectionUp
             animated:YES];
            
            [imagePicker release];
            newMedia = NO;
        }
        else
        {
            NSLog(@"Camera ROLL NOT availiable!!!");
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    [popoverController release];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)viewDidUnload {
    self.imageView = nil;
    self.popoverController = nil;
    self.toolbar = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)insertEmployeeIntoDatabase
{        
    sqlite3 * database;
    
    BOOL success = YES;

    NSLog(@"db path: %@", appDelegate.databasePath );
        
        if (sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK)
        {
            const char * sql = "INSERT INTO students (firstName, lastName, fullName, gender, dob_month, dob_day, dob_year, image, uid, email, phone, address, parent_firstName, parent_lastName, parent_email, parent_phone, relationship, notes, key) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            sqlite3_stmt * compiledStatement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                sqlite3_bind_text(compiledStatement, 1, [[userInput objectAtIndex:0] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 2, [[userInput objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 3, [[NSString stringWithFormat:@"%@ %@", [userInput objectAtIndex:0], [userInput objectAtIndex:1]] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 4, [@"male" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 5, 7);
                sqlite3_bind_int(compiledStatement, 6, 25);
                sqlite3_bind_int(compiledStatement, 7, 1991);
                sqlite3_bind_text(compiledStatement, 8, [[NSString stringWithFormat:@"%@.jpg", [userInput objectAtIndex:2]] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 9, [[userInput objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 10, [[userInput objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 11, [[userInput objectAtIndex:4] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 12, [[userInput objectAtIndex:5] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 13, [[userInput objectAtIndex:6] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 14, [[userInput objectAtIndex:7] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 15, [[userInput objectAtIndex:8] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 16, [[userInput objectAtIndex:9]UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 17, [[userInput objectAtIndex:10] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 18, [@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 19, 0);
                
                sqlite3_reset(compiledStatement);
            }
            else
            {
                success = NO;
            }
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE)
            {
                success = NO;
                NSLog(@"Save Error (Insert Recent): %s", sqlite3_errmsg(database) );
            }
            
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            success = NO;
        }
        
        sqlite3_close(database);
    
    [appDelegate reloadData];
    
    return success;
}

- (void)done:(id)sender
{
    UIAlertView *resultMessage;
    
    if ([self verifyUserIndex])
    {
        if ([self insertEmployeeIntoDatabase])
        {
            resultMessage = [[UIAlertView alloc] initWithTitle:@"Success"
                                                              message:@"Student Added!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        }
        else
        {
            resultMessage = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Unable to Add Student"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        }
        
        [resultMessage show];
    }
    
    [appDelegate reloadData];
    studentTableViewController = [[StudentTableViewController alloc] init];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadStudentTableView" object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return YES;
	}
	return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (headTableView == tableView)
        return 1;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (headTableView == tableView)
        return 3;
    else
        return restTitles.count;
}

// RootViewController.m
- (UITableViewCell *) getCellContentViewForLogin:(NSString *)cellIdentifier :(NSString *)placeholder :(int)tag {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UITextField *formTitleEntryField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 275, 30)];
    formTitleEntryField.adjustsFontSizeToFitWidth = YES;
    formTitleEntryField.placeholder = placeholder;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tag == 1)
        [formTitleEntryField becomeFirstResponder];
    
    return cell;
} /* getCellContentViewForLogin */

// RootViewController.m
- (UITableViewCell *) getCellContentViewForPassword:(NSString *)cellIdentifier :(NSString *)text :(int)tag {
    
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
    vLine.backgroundColor = [UIColor colorWithRed:173.0f/255.0f green:175.0f/255.0f blue:179.0f/255.0f alpha:.7f];
    [cell.contentView addSubview:vLine];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
} /* getCellContentViewForPassword */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == headTableView)
    {
        NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
        cell = [headTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil)
        {
            cell = [self getCellContentViewForLogin:CellIdentifier1 :[placeHolders objectAtIndex:indexPath.row] : 1 + indexPath.row];
        }
    }
    else if (tableView == restTableView)
    {
        NSString *CellIdentifier2 = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
        cell = [restTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        restIndexPath = indexPath;
        
        if (cell == nil)
        {
            cell = [self getCellContentViewForPassword:CellIdentifier2 :[restTitles objectAtIndex:indexPath.row] : 4 + indexPath.row];
        }
    }

    return cell;
}

- (BOOL) verifyUserIndex
{    
    for (int x = 0; x < NUM_OBJECTS; x++)
    {
        UILabel *label = (UILabel*)[self.view viewWithTag:x + 1];

        if (label.text == NULL || [label.text isEqualToString:@""])
            break;
        else if (x == NUM_OBJECTS - 1)
        {
            [userInput addObject:label.text];
            return YES;
        }
        else
            [userInput addObject:label.text];
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Form Incomplete"
                                                      message:@"Required field missing"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == headTableView)
        [headTableView deselectRowAtIndexPath:indexPath animated:YES];
    else if (tableView == restTableView)
        [restTableView deselectRowAtIndexPath:indexPath animated:YES];
    else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [restTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


@end
