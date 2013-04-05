//
//  StudentTableViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

/* Imports */

#import "StudentTableViewController.h"
#import "Student.h"
#import "AddStudentView.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomTableView.h"
#import "AboutViewController.h"
#import "ClassDefinitions.h"
#import "MathAssessmentModel.h"
#import "UIImage+UIColor.h"
#import "MGBoxLine.h"

/* Definitions */

#define start_color      [UIColor colorWithHex:0xEEEEEE]
#define end_color        [UIColor colorWithHex:0xDEDEDE]
#define kLandscapeHeight 748.0

/*
 * Class Main Implementation
 */

@implementation StudentTableViewController

/* Synthesizations */

@synthesize studentArraySectioned = _studentArraySectioned;
@synthesize classkey = _classkey;

/*
   InitWithNibName
   --------
   Purpose:        Initilizes Class with Views
   Parameters:     nib
   Returns:        self
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    return self;
} /* initWithNibName */


/*
   Init
   --------
   Purpose:        Initilizes Class
   Parameters:     string, array, int
   Returns:        self
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) init :(NSString *)title arraySectioned :(NSMutableArray *)arraySectioned classkey :(int)key {
    self.title = NSLocalizedString(title, nil);
    self.studentArraySectioned = [[NSMutableArray alloc] initWithArray:arraySectioned];
    self.classkey = key;
    return self;
} /* initWithNibName */


/*
   viewDidLoad
   --------
   Purpose:        Load View
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewDidLoad {
    [super viewDidLoad];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    detailViewController = [[DetailViewController alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableViewData:)
                                                 name:@"ReloadStudentTableView"
                                               object:nil];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.9f alpha:1.0f]]
                                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self action:@selector(addStudent:)];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutButton setTitle:NSLocalizedString(@"About Bobcats", nil) forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    aboutButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    aboutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    aboutButton.showsTouchWhenHighlighted = YES;
    [aboutButton setFrame:CGRectInset(footerView.bounds, 50, 20)];
    [aboutButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:aboutButton];
    self.tableView.tableFooterView = footerView;

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // Fixes Navigation Height On Landscape
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self performSelectorInBackground:@selector(correctNavigationHeightOnLandscape) withObject:nil];
    }
} /* viewDidLoad */


/*
   correctNavigationHeightOnLandscape
   --------
   Purpose:        Initially Installs View Height
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) correctNavigationHeightOnLandscape {
    [self.navigationController.view setHeight:kLandscapeHeight];
} /* correctNavigationHeightOnLandscape */


/*
   showInfo
   --------
   Purpose:        Show About
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) showInfo :(id)sender {
    // Show info dialog with libxar license
    AboutViewController *vc = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self.view.window.rootViewController presentModalViewController:navController animated:YES];
} /* showInfo */


/*
   realloc
   --------
   Purpose:        realloc
   Parameters:     array
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) realloc :(NSMutableArray *)array {
    [self.studentArraySectioned removeAllObjects];
    self.studentArraySectioned = [[NSMutableArray alloc] initWithArray:array];
} /* realloc */


- (void) reloadTableViewData :(NSNotification *)notif {

    if (![self.title isEqualToString:@"All Students"]) {
        if (self.classkey == 1)
            [self realloc:appDelegate.mathStudentsArray];
        else if (self.classkey == 2)
            [self realloc:appDelegate.readingStudentsArray];
        else if (self.classkey == 3)
            [self realloc:appDelegate.writingStudentsArray];
        else if (self.classkey == 4)
            [self realloc:appDelegate.behavioralStudentsArray];
    } else
        [self realloc:appDelegate.studentArraySectioned];

    [self.tableView reloadData];
} /* reloadTableViewData */


/*
   addStudent
   --------
   Purpose:        Add Student Button
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) addStudent :(id)sender {

    int initwithkey = -1;

    if ([self.title isEqualToString:@"Math"])
        initwithkey = kMath_Key;
    else if ([self.title isEqualToString:@"Reading"])
        initwithkey = kReading_Key;
    else if ([self.title isEqualToString:@"Writing"])
        initwithkey = kWriting_Key;
    else if ([self.title isEqualToString:@"Behavioral"])
        initwithkey = kBehavioral_Key;
    else
        initwithkey = kAll_key;

    AddStudentView *vc = [[AddStudentView alloc] init:initwithkey];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
} /* addStudent */


/*
   useCameraRoll
   --------
   Purpose:        Camera Roll Instance
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) useCamera :(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *)kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self.navigationController pushViewController:imagePicker animated:YES];
    } else {
        NSLog(@"Camera NOT availiable!!!");
    }
} /* useCamera */


/*
   useCameraRoll
   --------
   Purpose:        Camera Roll Existing Images Selection Instance
   Parameters:     UIImagePickerController, NSDictionary
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (IBAction) useCameraRoll :(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *)kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;

        popoverController = [[UIPopoverController alloc]
                             initWithContentViewController:imagePicker];

        popoverController.delegate = self;

        [popoverController
         presentPopoverFromBarButtonItem:sender
                permittedArrowDirections:UIPopoverArrowDirectionUp
                                animated:YES];

    } else {
        NSLog(@"Camera ROLL NOT availiable!!!");
    }
} /* useCameraRoll */


#pragma mark - Table view data source

/*
   titleForHeaderInSection
   --------
   Purpose:        Section Title
   Parameters:     UITableView, NSInteger
   Returns:        NSString
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {

    if ([[self.studentArraySectioned objectAtIndex:section] count] > 0)
        return [[[[[self.studentArraySectioned objectAtIndex:section] objectAtIndex:0] lastName] substringToIndex:1] capitalizedString];
    else
        return @"";
} /* tableView */


/*
   numberOfSectionsInTableView
   --------
   Purpose:        Section Count
   Parameters:     UITableView
   Returns:        NSInteger
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    // Return the number of sections.
    return [self.studentArraySectioned count];
} /* numberOfSectionsInTableView */


/*
   numberOfRowsInSection
   --------
   Purpose:        Rows Count
   Parameters:     UITableView
   Returns:        NSInteger
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.studentArraySectioned objectAtIndex:section] count];
} /* tableView */


/*
   cellForRowAtIndexPath
   --------
   Purpose:        Delegate
   Parameters:     UITableView, NSIndexPath
   Returns:        UITableViewCell
   Notes:          --
   Author:         Neil Burchfield
 */
- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    /*   Instantiate the reversed array within the student class object */
    Student *student = (Student *)[[self.studentArraySectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        MGBoxLine *line = [MGBoxLine lineWithWidth:cell.width];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - line.height - 1, cell.width, line.height)];
        [lineView addSubview:line];
        [cell addSubview:lineView];
    }

    /*    Set Custom Background for favorites Employee Cell View */
    cell.textLabel.text = [NSString stringWithFormat:@"         %@", [student fullName]];
    cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:17.5f];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *imagePath;
    if ([AppDelegate isDemo])
        imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];
    else
        imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];

    NSFileManager *filemanager = [NSFileManager defaultManager];

    // Set Student Image
    UIImageView *studentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.height, cell.height)];

    if ([filemanager fileExistsAtPath:imagePath])
        studentImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    else
        studentImageView.image = [UIImage imageNamed:@"person.png"];
        
    // Get the Layer of any view
    CALayer *sivl = [studentImageView layer];
    [sivl setMasksToBounds:YES];
    [sivl setCornerRadius:0];
    // Add a border
    [sivl setBorderWidth:2.0];
    [sivl setBorderColor:[[UIColor lightTextColor] CGColor]];
    
    [cell.contentView addSubview:studentImageView];

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];

    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    return cell;
} /* tableView */


/*
   deleteStudent
   --------
   Purpose:        Delete Student
   Parameters:     NSString
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) deleteStudent :(NSString *)uid {
    sqlite3 *database;

    if (sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *deleteSql = "DELETE FROM students WHERE lastName = ?";
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, deleteSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(compiledStatement, 1, [uid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error: %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }

    sqlite3_close(database);
} /* deleteStudent */


/*
   commitEditingStyle
   --------
   Purpose:        Override to support editing the table view
   Parameters:     UITableView, UITableViewCellEditingStyle
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void)    tableView :(UITableView *)tableView commitEditingStyle :(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath :(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *student = (Student *)[[self.studentArraySectioned objectAtIndex:indexPath.section]
                                       objectAtIndex:indexPath.row];

        [self deleteStudent:[student lastName]];

        [appDelegate reloadCoreData];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadStudentTableView" object:nil];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
} /* tableView */


/*
   sectionIndexTitlesForTableView
   --------
   Purpose:        Set section index titles
   Parameters:     UITableView
   Returns:        NSArray
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSArray *) sectionIndexTitlesForTableView :(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
} /* sectionIndexTitlesForTableView */


/*
   didSelectRowAtIndexPath
   --------
   Purpose:        Delegate
   Parameters:     UITableView, NSIndexPath
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) tableView :(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:indexPath forKey:@"indexPath"];
    [userInfo setObject:self.title forKey:@"view"];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateContent" object:self userInfo:userInfo];
} /* tableView */


/*
   shouldAutorotate
   --------
   Purpose:        Autorotate
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotate {
    return YES;
} /* shouldAutorotate */


/*
   shouldAutorotateToInterfaceOrientation
   --------
   Purpose:        Autorotate
   Parameters:     --
   Returns:        BOOL
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    return YES;
} /* shouldAutorotateToInterfaceOrientation */


@end