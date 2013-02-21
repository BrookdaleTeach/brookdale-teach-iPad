//
//  StudentTableViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

#import "StudentTableViewController.h"
#import "Student.h"
#import "AddStudentView.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomTableView.h"
#import "AboutViewController.h"
#import "ClassDefinitions.h"
#import "MathAssessmentModel.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color   [UIColor colorWithHex:0xDEDEDE]

@implementation StudentTableViewController
@synthesize studentArraySectioned = _studentArraySectioned;
@synthesize classkey = _classkey;

- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    return self;
} /* initWithNibName */


- (id) init :(NSString *)title arraySectioned :(NSMutableArray *)arraySectioned classkey :(int)key {
    self.title = NSLocalizedString(title, nil);
    self.studentArraySectioned = [[NSMutableArray alloc] initWithArray:arraySectioned];
    self.classkey = key;
    return self;
} /* initWithNibName */


- (void) viewDidLoad {
    [super viewDidLoad];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    detailViewController = [[DetailViewController alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableViewData:)
                                                 name:@"ReloadStudentTableView"
                                               object:nil];

    self.tableView.frame = CGRectMake(self.tableView.bounds.origin.x,
                                      self.tableView.bounds.origin.y,
                                      self.tableView.bounds.size.width,
                                      self.tableView.bounds.size.height);

    self.tableView.contentSize = CGSizeMake(self.tableView.bounds.size.width, self.tableView.bounds.size.height + 200);
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whitey.png"]];
    self.clearsSelectionOnViewWillAppear = YES;
    self.contentSizeForViewInPopover = CGSizeMake(400.0, 1024.0);

    if (![self.title isEqualToString:@"All Students"])
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
} /* viewDidLoad */


- (void) showInfo :(id)sender {
    // Show info dialog with libxar license
    AboutViewController *vc = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self.view.window.rootViewController presentModalViewController:navController animated:YES];
} /* showInfo */


- (void) viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
} /* viewWillAppear */


- (void) realloc :(NSMutableArray *)array {
    [self.studentArraySectioned removeAllObjects];
    self.studentArraySectioned = [[NSMutableArray alloc] initWithArray:array];
} /* realloc */


- (void) reloadTableViewData :(NSNotification *)notif {

    if (self.classkey == 1)
        [self realloc:appDelegate.mathStudentsArray];
    else if (self.classkey == 2)
        [self realloc:appDelegate.readingStudentsArray];
    else if (self.classkey == 3)
        [self realloc:appDelegate.writingStudentsArray];
    else if (self.classkey == 4)
        [self realloc:appDelegate.behavioralStudentsArray];

    [self.tableView reloadData];
} /* reloadTableViewData */


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
        initwithkey = -9999;

    AddStudentView *vc = [[AddStudentView alloc] init:initwithkey];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
} /* addStudent */


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


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} /* didReceiveMemoryWarning */


- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {

    if ([[self.studentArraySectioned objectAtIndex:section] count] > 0)
        return [[[[[self.studentArraySectioned objectAtIndex:section] objectAtIndex:0] lastName] substringToIndex:1] capitalizedString];
    else
        return @"";
} /* tableView */


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    // Return the number of sections.
    return [self.studentArraySectioned count];
} /* numberOfSectionsInTableView */


- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.studentArraySectioned objectAtIndex:section] count];
} /* tableView */


- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    /*   Instantiate the reversed array within the student class object */
    Student *student = (Student *)[[self.studentArraySectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
    }

    /*    Set Custom Background for favorites Employee Cell View */
    cell.textLabel.text = [student fullName];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];
    NSFileManager *filemanager = [NSFileManager defaultManager];

    if ([filemanager fileExistsAtPath:imagePath])
        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    else
        cell.imageView.image = [UIImage imageNamed:@"person.png"];

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];

    return cell;
} /* tableView */


- (void) deleteEmployee :(NSString *)uid {
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
} /* deleteEmployee */


// Override to support editing the table view.
- (void)    tableView :(UITableView *)tableView commitEditingStyle :(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath :(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *student = (Student *)[[self.studentArraySectioned objectAtIndex:indexPath.section]
                                       objectAtIndex:indexPath.row];

        [self deleteEmployee:[student lastName]];

        [appDelegate reloadCoreData];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadStudentTableView" object:nil];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
} /* tableView */


/* Set section index titles */
- (NSArray *) sectionIndexTitlesForTableView :(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
} /* sectionIndexTitlesForTableView */


- (CAGradientLayer *) blueGradient {

    UIColor *colorOne = [UIColor colorWithRed:(120 / 255.0) green:(135 / 255.0) blue:(150 / 255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57 / 255.0)  green:(79 / 255.0)  blue:(96 / 255.0)  alpha:1.0];

    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];

    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];

    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;

    return headerLayer;
} /* blueGradient */


- (CAGradientLayer *) customGradient :(UIColor *)first :(UIColor *)second {

    NSArray *colors = [NSArray arrayWithObjects:(id)first.CGColor, second.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];

    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];

    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;

    return headerLayer;
} /* customGradient */


- (UIView *) tableView :(UITableView *)tableView viewForHeaderInSection :(NSInteger)section {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight - 2)];
    [headerView setBackgroundColor:[UIColor clearColor]];

    CAGradientLayer *bgLayer = [self blueGradient];

    if ([self.title isEqualToString:@"Math"])
        bgLayer = [self customGradient:[UIColor colorWithRed:235.0f / 255.0f green:79.0f / 255.0f blue:66.0f / 255.0f alpha:0.7f]  // 235	79	66
                                      :[UIColor colorWithRed:229.0f / 255.0f green:51.0f / 255.0f blue:46.0f / 255.0f alpha:1.0f]];  // 229	51	46
    else if ([self.title isEqualToString:@"Reading"])
        bgLayer = [self customGradient:[UIColor colorWithRed:(7 / 255.0) green:(175 / 255.0) blue:(228 / 228) alpha:1.0] // 7	175	228
                                      :[UIColor colorWithRed:(0 / 255.0)  green:(163 / 255.0)  blue:(223 / 255.0)  alpha:1.0]];      // 0	163	223
    else if ([self.title isEqualToString:@"Writing"])
        bgLayer = [self customGradient:[UIColor colorWithRed:(80 / 255.0) green:(185 / 255.0) blue:(65 / 255.0) alpha:1.0]
                                      :[UIColor colorWithRed:(65 / 255.0)  green:(162 / 255.0)  blue:(52 / 255.0)  alpha:1.0]];
    else if ([self.title isEqualToString:@"Behavioral"])
        bgLayer = [self customGradient:[UIColor colorWithRed:(249 / 255.0) green:(121 / 255.0) blue:(55 / 255.0) alpha:1.0] // 249	121	55
                                      :[UIColor colorWithRed:(232 / 255.0)  green:(85 / 255.0)  blue:(19 / 255.0)  alpha:1.0]];      // 232	85	19

    bgLayer.frame = headerView.bounds;
    [headerView.layer insertSublayer:bgLayer atIndex:0];
    [headerView.layer setMasksToBounds:YES];

    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.5f, tableView.bounds.size.width - 10, 18)];
    headerText.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    headerText.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    headerText.textColor = [UIColor whiteColor];
    headerText.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerText];

    return headerView;
} /* tableView */


- (void) tableView :(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:indexPath forKey:@"indexPath"];
    [userInfo setObject:self.title forKey:@"view"];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateContent" object:self userInfo:userInfo];
} /* tableView */


#pragma mark -

- (void) didRotateFromInterfaceOrientation :(UIInterfaceOrientation)fromInterfaceOrientation {

    [self.tableView reloadData];
} /* didRotateFromInterfaceOrientation */


- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait;
} /* shouldAutorotateToInterfaceOrientation */


@end
















