//
//  DetailViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */

#import "DetailViewHeaderImports.h"

/*
 * Class Main Implementation
 */
@implementation DetailViewController {

    /* MGBox Declarations */

    MGBox *table1;
    MGBox *table2;
    MGBox *table3;
    MGLineStyled *header;

    /* UIBarButtonItem Declarations */

    UIBarButtonItem *composeBarButtonItem;
    UIBarButtonItem *addContactBarButtonItem;
    UIBarButtonItem *geolocateBarButtonItem;
    UIBarButtonItem *addToCalendarBarButtonItem;
    UIBarButtonItem *editUser;
    UIBarButtonItem *addNote;

}

/* Sythesizations */

@synthesize mapView = _mapView;
@synthesize scroller = _scroller;
@synthesize eventStore = _eventStore;
@synthesize defaultCalendar = _defaultCalendar;
@synthesize emailActionSheet = _emailActionSheet;
@synthesize contactActionSheet = _cosettingsViewControllerntactActionSheet;
@synthesize addEventActionSheet = _addEventActionSheet;
@synthesize settingsViewController = _settingsViewController;
@synthesize HUD = _HUD;

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

    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(updateContent:)
            name:@"UpdateContent"
          object:nil];

    self.eventStore = [[EKEventStore alloc] init];

    // App Delegate Initilization
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // Init Headers
    tableViewHeaders = [[NSArray alloc] initWithObjects:@"Phone", @"Address", @"Birthday", @"Parent First",
                        @"Parent Last", @"Parent Email", @"Parent Phone", @"Relationship", nil];

    [self setupMGBoxes];

    [self allocContentDataView];

    toolbar = [[UIToolbar alloc] init];

    // Layout scroller based on interface orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [toolbar setFrame:CGRectMake(0, BOX_PORTRAIT.size.height - 44, BOX_PORTRAIT.size.width + 75, 44)];
    else
        [toolbar setFrame:CGRectMake(0, BOX_LANDSCAPE.size.height - 300, BOX_LANDSCAPE.size.width, 44)];

    [toolbar setTintColor:[UIColor clearColor]];

    UIImage *gradientImage44 = [[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.9f alpha:1.0f]]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    [toolbar setBackgroundImage:gradientImage44 forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    toolBarImage = [[UIImageView alloc] init];

    // Layout scroller based on interface orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [toolBarImage setFrame:CGRectMake(710, 4, 35, 35)];
    else
        [toolBarImage setFrame:CGRectMake(650, 4, 35, 35)];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:kTeacherImageDefault];

    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [toolBarImage setImage:[UIImage imageWithContentsOfFile:imagePath]];
    } else {
        [toolBarImage setImage:[UIImage imageNamed:kTeacherNoCustomImage]];
    }

    toolBarImage.layer.cornerRadius = 4.0f;
    toolBarImage.layer.borderWidth = .8f;
    toolBarImage.layer.borderColor = [[UIColor scrollViewTexturedBackgroundColor] CGColor];

    [toolbar addSubview:toolBarImage];

    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(pushSettings:) forControlEvents:UIControlEventTouchDown];
    [settingsButton setFrame:CGRectMake(10, 9.5, 25, 25)];
    [toolbar addSubview:settingsButton];

    [self.view addSubview:toolbar];

    if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathToFollowingResource:kTeacherSettingsPlist]]) {
        [settingsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
} /* viewDidLoad */


/*
   pushSettings
   --------
   Purpose:        Push Settings in view
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) pushSettings :(id)sender {
    CGRect final_portrait = CGRectMake(40, -400.0f, 700, 500);
    CGRect final_landscape = CGRectMake(10, -400.0f, 700, 500);

    CGRect initial_portrait = CGRectMake(40, -10.0f, 700, 500);
    CGRect initial_landscape = CGRectMake(10, -10.0f, 700, 500);

    if (!self.settingsViewController) {
        self.settingsViewController = [[SettingsViewController alloc] init];

        if ( UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ) {
            [self.settingsViewController.view setFrame:initial_portrait];
        } else {
            [self.settingsViewController.view setFrame:initial_landscape];
        }

        [self.view addSubview:self.settingsViewController.view];

        isSettingsHidden = YES;
    }

    if (isSettingsHidden) {

        // Begin Animations
        [UIView beginAnimations:@"scrollboxdown" context:nil];

        // Set Animation duration
        [UIView setAnimationDuration:0.7f];

        // Set Animation Content
        if ( UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ) {
            [self.settingsViewController.view setFrame:initial_portrait];
        } else {
            [self.settingsViewController.view setFrame:initial_landscape];
        }

        // Commit the Animations
        [UIView commitAnimations];
    } else {

        // Save the data
        [[NSNotificationCenter defaultCenter] postNotificationName:kSettingsShouldSaveNotification object:self];

        // Begin Animations
        [UIView beginAnimations:@"scrollboxup" context:nil];

        // Set Animation duration
        [UIView setAnimationDuration:0.7f];

        // Set Animation Content
        if ( UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ) {
            [self.settingsViewController.view setFrame:final_portrait];
        } else {
            [self.settingsViewController.view setFrame:final_landscape];
        }
        // Commit the Animations
        [UIView commitAnimations];
    }

    isSettingsHidden = !isSettingsHidden;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:kTeacherImageDefault];

    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [toolBarImage setImage:[UIImage imageWithContentsOfFile:imagePath]];
    } else {
        [toolBarImage setImage:[UIImage imageNamed:kTeacherNoCustomImage]];
    }
} /* pushSettings */


#pragma mark -
#pragma mark Class Delegate's MGBox Data Handler (Allocing)

/*
   setupMGBoxes
   --------
   Purpose:        Initilally sets up MGBoxes for further layout
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) setupMGBoxes {
    // Init Scroller
    self.scroller = [[MGScrollView alloc] init];

    self.scroller.delegate = self;

    // Layout scroller based on interface orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [self.scroller setFrame:BOX_PORTRAIT];
    else if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
        [self.scroller setFrame:CGRectMake(0, 130, 782, 525)];

    // MGBox Scroller layout mode
    self.scroller.contentLayoutMode = MGLayoutGridStyle;

    // MGBox Scroller layout mode
    self.scroller.bottomPadding = 8;

    // Add scroller to subview
    [self.view addSubview:self.scroller];

    // Setup Main Grid
    MGBox *tablesGrid = [MGBox boxWithSize:self.scroller.bounds.size];
    tablesGrid.contentLayoutMode = MGLayoutGridStyle;
    [self.scroller.boxes addObject:tablesGrid];

    // Alloc/Init First Table
    table1 = MGBox.box;
    [tablesGrid.boxes addObject:table1];
    table1.sizingMode = MGResizingShrinkWrap;

    // Only add if not "All Students" section
    if (![nextView isEqualToString:@"All Students"]) {
        // Alloc/Init Second Table
        table2 = MGBox.box;
        [tablesGrid.boxes addObject:table2];
        table2.sizingMode = MGResizingShrinkWrap;
    }

    // Alloc/Init Third Table
    table3 = MGBox.box;
    [tablesGrid.boxes addObject:table3];
    table3.sizingMode = MGResizingShrinkWrap;

} /* setupMGBoxes */


#pragma mark -
#pragma mark Class Delegate's MGBox Data Handler

/*
   loopValuesIntoMGBox
   --------
   Purpose:        Handles UIActionSheet button press
   Parameters:     int, int
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) loopValuesIntoMGBox :(int)section :(int)row {

    // Clear all previous objects from boxes
    [table1.boxes removeAllObjects];
    [table2.boxes removeAllObjects];
    [table3.boxes removeAllObjects];

    // Decide what the current view is
    if ([nextView isEqualToString:@"Math"])
        student = (Student *)[[appDelegate.mathStudentsArray objectAtIndex:section] objectAtIndex:row];
    else if ([nextView isEqualToString:@"Reading"])
        student = (Student *)[[appDelegate.readingStudentsArray objectAtIndex:section] objectAtIndex:row];
    else if ([nextView isEqualToString:@"Writing"])
        student = (Student *)[[appDelegate.writingStudentsArray objectAtIndex:section] objectAtIndex:row];
    else if ([nextView isEqualToString:@"Behavioral"])
        student = (Student *)[[appDelegate.behavioralStudentsArray objectAtIndex:section] objectAtIndex:row];
    else
        student = (Student *)[[appDelegate.studentArraySectioned objectAtIndex:section] objectAtIndex:row];

    // Insert student data into array
    tableViewContent = [[NSMutableArray alloc] initWithObjects:
                        [student phone],
                        [student address],
                        [NSString stringWithFormat:@"%d/%d/%d", [student dob_month], [student dob_day], [student dob_year]],
                        [student parent_firstName],
                        [student parent_lastName],
                        [student parent_email],
                        [student parent_phone],
                        [student relationship], nil];

    // Add menu to table
    MGTableBoxStyled *menu = MGTableBoxStyled.box;
    [table1.boxes addObject:menu];

    // Setup vars for block usage
    __block DetailViewController *dtv = self;

    // Iterate and add data to boxes
    int x = 0;
    for (; x < tableViewHeaders.count; x++) {
        // header line
        header = [MGLineStyled lineWithLeft:[tableViewHeaders objectAtIndex:x]
                                      right:[tableViewContent objectAtIndex:x]
                                       size:ROW_SIZE];
        header.tag = x;
        header.font = HEADER_FONT;
        header.onTap = ^{
            [dtv buttonpress:x];
        };

        // Add Header to box's toplines
        [menu.topLines addObject:header];
    }

    // Layout table
    [table1 layoutWithSpeed:0.3 completion:nil];

    // Only add if not "All Students" section
    if (![nextView isEqualToString:@"All Students"]) {
        // Setup second menu
        MGTableBoxStyled *menu2 = MGTableBoxStyled.box;
        [table2.boxes addObject:menu2];


        // Add Static content to array
        NSArray *testsContent = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Modify %@ Assessment Scores", [nextView capitalizedString]],
                                 [NSString stringWithFormat:@"Modify %@ Checklist", [nextView capitalizedString]], nil];

        // Loop through data and add to menu
        for (int y = 0; y < testsContent.count; y++) {
            // header line
            header = [MGLineStyled lineWithLeft:[testsContent objectAtIndex:y]
                                          right:[UIImage imageNamed:@"arrow"]
                                           size:ROW_SIZE];
            header.font = HEADER_FONT;
            header.tag = x + y;
            header.onTap = ^{
                [dtv buttonpress:x + y];
            };

            [menu2.topLines addObject:header];
        }

        // Layout table
        [table2 layoutWithSpeed:0.3 completion:nil];
    }

    MGLineStyled *print1, *print2;
    // Setup second menu
    MGTableBoxStyled *menu3 = MGTableBoxStyled.box;

    if ([[nextView capitalizedString] isEqualToString:@"All Students"]) {

        header = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"Go to %@'s class page", [student firstName]]
                                      right:[UIImage imageNamed:@"arrow"]
                                       size:ROW_SIZE];
        header.font = HEADER_FONT;

        header.tag = 12311;

        header.onTap = ^{
            [dtv buttonpress:12311];
        };

        [menu3.topLines addObject:header];
    } else {
        print1 = [MGLineStyled lineWithLeft:@"Print Checklists"
                                      right:[UIImage imageNamed:@"arrow"]
                                       size:ROW_SIZE];
        print2 = [MGLineStyled lineWithLeft:@"Print Test Scores"
                                      right:[UIImage imageNamed:@"arrow"]
                                       size:ROW_SIZE];

        print1.font = HEADER_FONT;
        print2.font = HEADER_FONT;

        print1.tag = kPrintAssessmentTag;
        print2.tag = kPrintStandardizedTag;

        print1.onTap = ^{
            [dtv buttonpress:kPrintAssessmentTag];
        };
        print2.onTap = ^{
            [dtv buttonpress:kPrintStandardizedTag];
        };

        [menu3.topLines addObject:print1];
        [menu3.topLines addObject:print2];
    }

    [table3.boxes addObject:menu3];

    // Layout table
    [table3 layoutWithSpeed:0.3 completion:nil];

    // Layout Scroller
    [self.scroller layoutWithSpeed:0.3 completion:nil];
} /* loopValuesIntoMGBox */


#pragma mark -
#pragma mark Class Delegate's Custom Notification Handler

/*
   updateContent
   --------
   Purpose:        Handles update NSNotification call
   Parameters:     NSNotification
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) updateContent :(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"UpdateContent"]) {
        NSDictionary *userInfo = [notification userInfo];
        indexPath = [userInfo objectForKey:@"indexPath"];
        nextView = [userInfo objectForKey:@"view"];

        if (self.navigationController.view.subviews.count > 1)
            [self.navigationController popToRootViewControllerAnimated:YES];

        if ((indexPath.section >= 0) && (indexPath.row >= 0)) {
            [self loopValuesIntoMGBox:indexPath.section:indexPath.row];
            [self loadContentDataView:indexPath.section:indexPath.row];
        }
    }
} /* receiveTestNotification */


#pragma mark -
#pragma mark Class Delegate's View Allocing Content method

/*
   allocContentDataView
   --------
   Purpose:        Alloc initial data
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) allocContentDataView {

    // Set Student Shelf
    shelfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width + 55, self.view.bounds.size.height / 8 + 3)];
    shelfView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    shelfView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    shelfView.layer.masksToBounds = YES;
    shelfView.alpha = .9;

    UIImage *gradientImage44 = [[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.86f alpha:1.0f]]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    [shelfView setBackgroundColor:[UIColor colorWithPatternImage:gradientImage44]];
    shelfView.hidden = YES;
    [self.view addSubview:shelfView];

    shelfViewShadow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shelfView.bounds.size.width, shelfView.bounds.size.height - 4)];
    shelfViewShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    shelfViewShadow.layer.shadowOffset = CGSizeMake(0, 1);
    shelfViewShadow.layer.shadowOpacity = 1;
    shelfViewShadow.layer.shadowRadius = 10.0;
    shelfViewShadow.clipsToBounds = NO;
    shelfViewShadow.hidden = YES;
    [self.view insertSubview:shelfViewShadow belowSubview:shelfView];

    // Set Student Image
    studentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10,
                                                                     101, 101)];

    // Get the Layer of any view
    CALayer *sivl = [studentImageView layer];
    [sivl setMasksToBounds:YES];
    [sivl setCornerRadius:6.5];
    // Add a border
    [sivl setBorderWidth:2.0];
    [sivl setBorderColor:[[UIColor darkGrayColor] CGColor]];
    studentImageView.hidden = YES;
    [self.view insertSubview:studentImageView aboveSubview:shelfView];

    // Set Student Name Label
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 18, 300, 26)];
    [nameLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:24.0f]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:nameLabel];

    // Set Student Email Label
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(143, 45, 300, 19)];
    [emailLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.0f]];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:emailLabel];

    // Set Student UID Label
    uidLabel = [[UILabel alloc] initWithFrame:CGRectMake(143, 68, 300, 19)];
    [uidLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.0f]];
    [uidLabel setBackgroundColor:[UIColor clearColor]];
    [uidLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:uidLabel];

    // Calendar Button and Actiom
    UIButton *customBarButtonCalendarAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBarButtonCalendarAdd setImage:[UIImage imageNamed:@"83-calendar"] forState:UIControlStateNormal];
    [customBarButtonCalendarAdd setFrame:CGRectMake(0, 0, 50, 50)];
    [customBarButtonCalendarAdd addTarget:self action:@selector(checkIfEventsAreAccessible:) forControlEvents:UIControlEventTouchDown];
    addToCalendarBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonCalendarAdd];
    addToCalendarBarButtonItem.enabled = NO;

    self.addEventActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Add Student Birthday", @"Add Parent Birthday", nil];
    self.addEventActionSheet.tag = kCalendarEventActionSheet;

    // Add Contact Button and Actiom
    UIButton *customBarButtonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBarButtonAdd setImage:[UIImage imageNamed:@"111-user"] forState:UIControlStateNormal];
    [customBarButtonAdd setFrame:CGRectMake(0, 0, 40, 22)];
    [customBarButtonAdd addTarget:self action:@selector(contactAddPopoverAction:) forControlEvents:UIControlEventTouchDown];
    addContactBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonAdd];
    addContactBarButtonItem.enabled = NO;

    self.contactActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Add Student", @"Add Parent", nil];
    self.contactActionSheet.tag = kContactActionSheet;

    // Email Button and Actiom
    UIButton *customBarButtonEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBarButtonEmail setImage:[UIImage imageNamed:@"18-envelope"] forState:UIControlStateNormal];
    [customBarButtonEmail setFrame:CGRectMake(0, 0, 50, 50)];
    [customBarButtonEmail addTarget:self action:@selector(emailPopoverAction:) forControlEvents:UIControlEventTouchDown];
    composeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonEmail];
    composeBarButtonItem.enabled = NO;

    self.emailActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Email Myself", @"Email Parent", nil];
    self.emailActionSheet.tag = kEmailActionSheet;

    // Geolocation Button and Actiom
    UIButton *customBarButtonGeo = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBarButtonGeo setImage:[UIImage imageNamed:@"71-compass"] forState:UIControlStateNormal];
    [customBarButtonGeo setFrame:CGRectMake(0, 0, 50, 50)];
    [customBarButtonGeo addTarget:self action:@selector(geolocationAction:) forControlEvents:UIControlEventTouchDown];
    geolocateBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonGeo];
    geolocateBarButtonItem.enabled = NO;

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addContactBarButtonItem, composeBarButtonItem, geolocateBarButtonItem, addToCalendarBarButtonItem, nil];

    editUser = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCurrentUser:)];
    editUser.enabled = NO;

    addNote = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pushNotesModalView:)];
    addNote.enabled = NO;

    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:editUser, addNote, nil];

} /* allocContentDataView */


#pragma mark -
#pragma mark Class Delegate's View Loading Content method

/*
   loadContentDataView
   --------
   Purpose:        Loads Detail View Content based on section/row pair
   Parameters:     int, int
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) loadContentDataView :(int)section :(int)row {

    if ([nextView isEqualToString:@"Math"])
        student = (Student *)[[appDelegate.mathStudentsArray objectAtIndex:section] objectAtIndex:row];
    else if ([nextView isEqualToString:@"Reading"])
        student = (Student *)[[appDelegate.readingStudentsArray objectAtIndex:section] objectAtIndex:row];
    else if ([nextView isEqualToString:@"Writing"])
        student = (Student *)[[appDelegate.writingStudentsArray objectAtIndex:section] objectAtIndex:row];
    else if ([nextView isEqualToString:@"Behavioral"])
        student = (Student *)[[appDelegate.behavioralStudentsArray objectAtIndex:section] objectAtIndex:row];
    else
        student = (Student *)[[appDelegate.studentArraySectioned objectAtIndex:section] objectAtIndex:row];

    self.title = [student fullName];

    if (shelfView.hidden) {
        shelfView.hidden = !shelfView.hidden;
    }
    if (!editUser.enabled) {
        editUser.enabled = !editUser.enabled;
    }
    if (!addNote.enabled) {
        addNote.enabled = !addNote.enabled;
    }
    if (shelfViewShadow.hidden) {
        shelfViewShadow.hidden = !shelfViewShadow.hidden;
    }
    if (studentImageView.hidden) {
        studentImageView.hidden = !studentImageView.hidden;
    }
    if (!composeBarButtonItem.enabled) {
        composeBarButtonItem.enabled = !composeBarButtonItem.enabled;
    }
    if (!geolocateBarButtonItem.enabled) {
        geolocateBarButtonItem.enabled = !geolocateBarButtonItem.enabled;
    }
    if (!addContactBarButtonItem.enabled) {
        addContactBarButtonItem.enabled = !addContactBarButtonItem.enabled;
    }
    if (!addToCalendarBarButtonItem.enabled) {
        addToCalendarBarButtonItem.enabled = !addToCalendarBarButtonItem.enabled;
    }

    [ribbon removeFromSuperview];
    ribbon = [[UIImageView alloc] initWithFrame:CGRectMake(600, -10, 80, 146)];
    ribbon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_ribbon.png", [nextView lowercaseString]]];
    ribbon.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    ribbon.layer.shadowOffset = CGSizeMake(-2, 2);
    ribbon.layer.shadowOpacity = 1.0f;
    ribbon.layer.shadowRadius = 3.0f;
    [self.view addSubview:ribbon];

    shelfView.alpha = 0.09f;
    shelfViewShadow.alpha = 0.09f;
    studentImageView.alpha = 0.09f;

    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = .5f;
    [shelfView.layer addAnimation:animation forKey:nil];
    shelfView.alpha = 1.0f;
    [shelfViewShadow.layer addAnimation:animation forKey:nil];
    shelfViewShadow.alpha = 1.0f;
    [studentImageView.layer addAnimation:animation forKey:nil];
    studentImageView.alpha = 1.0f;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *imagePath;
    if ([AppDelegate isDemo])
        imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];
    else
        imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [student uid]]];

    NSFileManager *filemanager = [NSFileManager defaultManager];

    if ([filemanager fileExistsAtPath:imagePath]) {
        studentImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    } else {
        studentImageView.image = [UIImage imageNamed:@"person.png"];
    }

    // Set Student Name Label
    [nameLabel setText:[student fullName]];

    // Set Student Email Label
    [emailLabel setText:[[student email] lowercaseString]];

    // Set Student UID Label
    [uidLabel setText:[student uid]];

    [tableViewContent removeAllObjects];
    tableViewContent = [[NSMutableArray alloc] initWithObjects:
                        [student phone],
                        [student address],
                        [NSString stringWithFormat:@"%d/%d/%d", [student dob_month], [student dob_day], [student dob_year]],
                        [student parent_firstName],
                        [student parent_lastName],
                        [student parent_email],
                        [student parent_phone],
                        [student relationship], nil];

} /* loadContentDataView */


#pragma mark -
#pragma mark Class Delegate's Data Retrieval Method

/*
   retrieveClassAssessmentColumnContent
   --------
   Purpose:        Retrieves Assessment Data
   Parameters:     --
   Returns:        Array
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSArray *) retrieveClassAssessmentColumnContent {
    NSArray *classContentData = nil;
    NSArray *classStringsArray = nil;
    NSString *title = nil;

    if ([[nextView lowercaseString] isEqualToString:@"math"]) {
        title = @"Math Observation/Anecdotal Record Checklist";
        classStringsArray = [[NSMutableArray alloc] initWithObjects:[kMathBehaviorsStrings componentsSeparatedByString:@",, "],
                             [kMathSkillsStrings componentsSeparatedByString:@",, "], nil];
        classContentData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];
    } else if ([[nextView lowercaseString] isEqualToString:@"reading"]) {
        title = @"Reading Observation/Anecdotal Record Checklist";
        classStringsArray = [[NSMutableArray alloc] initWithObjects:[kReadingStrategiesStrings componentsSeparatedByString:kStringsDelimiter],
                             [kReadingDecodingStrings componentsSeparatedByString:kStringsDelimiter],
                             [kReadingFluencyStrings componentsSeparatedByString:kStringsDelimiter], nil];
        classContentData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];

    } else if ([[nextView lowercaseString] isEqualToString:@"writing"]) {
        title = @"Writing Observation/Anecdotal Record Checklist";
        classStringsArray = [[NSMutableArray alloc] initWithObjects:[kWritingMechanicStrings componentsSeparatedByString:kStringsDelimiter],
                             [kWritingOrganizationStrings componentsSeparatedByString:kStringsDelimiter],
                             [kWritingProcessesStrings componentsSeparatedByString:kStringsDelimiter], nil];
        classContentData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];
    } else if ([[nextView lowercaseString] isEqualToString:@"behavioral"]) {
        title = @"Writing Observation/Anecdotal Record Checklist";
        classStringsArray = [[NSMutableArray alloc] initWithObjects:[kBehavioralAttendanceStrings componentsSeparatedByString:kStringsDelimiter],
                             [kBehavioralRespectStrings componentsSeparatedByString:kStringsDelimiter],
                             [kBehavioralResponsibilityStrings componentsSeparatedByString:kStringsDelimiter],
                             [kBehavioralFeelingsStrings componentsSeparatedByString:kStringsDelimiter], nil];
        classContentData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];

    } /* if else */

    return [[NSArray alloc] initWithObjects:classStringsArray, classContentData, title, nil];
} /* retrieveClassAssessmentColumnContent */


#pragma mark -
#pragma mark Class Delegate's Data Retrieval Method

/*
   retrieveClassFormativeStandardizedColumnContent
   --------
   Purpose:        Retrieves Formative Data
   Parameters:     --
   Returns:        Array
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSArray *) retrieveClassFormativeStandardizedColumnContent {
    NSArray *formativeData = nil;
    NSArray *standardizedData = nil;
    NSString *title = nil;

    if ([[nextView lowercaseString] isEqualToString:@"math"]) {
        title = @"Student Math Formative/Standardized Tests";
        formativeData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
        standardizedData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
    } else if ([[nextView lowercaseString] isEqualToString:@"reading"]) {
        title = @"Student Reading Formative/Standardized Tests";
        formativeData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
        standardizedData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
    } else if ([[nextView lowercaseString] isEqualToString:@"writing"]) {
        title = @"Student Writing Formative/Standardized Tests";
        formativeData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
        standardizedData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
    } else if ([[nextView lowercaseString] isEqualToString:@"behavioral"]) {
        title = @"Student Behavioral Formative/Standardized Tests";
        formativeData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
        standardizedData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];

    } /* if else */

    return [[NSArray alloc] initWithObjects:formativeData, standardizedData, title, nil];
} /* retrieveClassAssessmentColumnContent */


#pragma mark -
#pragma mark Class Delegate's MGBox Button Press Action Handler

/*
   buttonpress
   --------
   Purpose:        Handles MGBox Button Down
   Parameters:     int
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) buttonpress :(int)row {
    switch (row) {
        case 9 :
        {
            if ([[nextView lowercaseString] isEqualToString:@"math"]) {
                MathAssessmentTableViewController *asvc = [[MathAssessmentTableViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:asvc animated:YES];
            } else if ([[nextView lowercaseString] isEqualToString:@"reading"]) {
                ReadingAssesmentViewController *ravc = [[ReadingAssesmentViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:ravc animated:YES];
            } else if ([[nextView lowercaseString] isEqualToString:@"writing"]) {
                WritingAssesmentViewController *wavc = [[WritingAssesmentViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:wavc animated:YES];
            } else if ([[nextView lowercaseString] isEqualToString:@"behavioral"]) {
                BehavioralAssesmentViewController *bavc = [[BehavioralAssesmentViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:bavc animated:YES];
            }
        }
        break;
        case 8 :
        {
            if ([[nextView lowercaseString] isEqualToString:@"math"]) {
                MathTestTableViewController *mttvc = [[MathTestTableViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:mttvc animated:YES];
            } else if ([[nextView lowercaseString] isEqualToString:@"reading"]) {
                ReadingTestTableViewController *rttvc = [[ReadingTestTableViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:rttvc animated:YES];
            } else if ([[nextView lowercaseString] isEqualToString:@"writing"]) {
                WritingTestTableViewController *wttvc = [[WritingTestTableViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:wttvc animated:YES];
            } else if ([[nextView lowercaseString] isEqualToString:@"behavioral"]) {
                BehavioralTestTableViewController *bttvc = [[BehavioralTestTableViewController alloc] initWithStyle:UITableViewStyleGrouped :student];
                [self.navigationController pushViewController:bttvc animated:YES];
            }
        }
        break;
        case kPrintAssessmentTag :
        {
            [self processRequest:@selector(generateAssessmentPortableDocumentFormat)];
        }
        break;
        case kPrintStandardizedTag :
        {
            [self processRequest:@selector(generateStandardizedPortableDocumentFormat)];
        }
        break;
        case 12311 :
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSString *next = nil;

            if ([self returnValueOfSubstringDoesEqual:kMath_Key withStudentClassKey:[student classkey]] == kMath_Key) {
                array = appDelegate.mathStudentsArray;
                next = @"Math";
            }
            if ([self returnValueOfSubstringDoesEqual:kReading_Key withStudentClassKey:[student classkey]] == kReading_Key) {
                array = appDelegate.readingStudentsArray;
                next = @"Reading";
            }
            if ([self returnValueOfSubstringDoesEqual:kWriting_Key withStudentClassKey:[student classkey]] == kWriting_Key) {
                array = appDelegate.writingStudentsArray;
                next = @"Writing";
            }
            if ([self returnValueOfSubstringDoesEqual:kBehavioral_Key withStudentClassKey:[student classkey]] == kBehavioral_Key) {
                array = appDelegate.behavioralStudentsArray;
                next = @"Behavioral";

            }

            int sect = 0, row = 0;
            BOOL found = NO;
            for (NSArray *sarray in array) {
                row = 0;
                for (Student *s in sarray) {
                    if ([[s uid] isEqualToString:[student uid]]) {
                        found = YES;
                        break;
                    }
                    row++;
                }

                if (found) {
                    break;
                }

                sect++;
            }

            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:[NSIndexPath indexPathForRow:row inSection:sect] forKey:@"indexPath"];
            [userInfo setObject:next forKey:@"view"];

            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"UpdateContent" object:self userInfo:userInfo];
        }
        break;
        default :
            break;
    } /* switch */
} /* buttonpress */


/*
   generateAssessmentPortableDocumentFormat
   --------
   Purpose:        Generates Assessment PDF
   Parameters:     --
   Returns:        --
   Notes:          Throws PDF into WebView
   Author:         Neil Burchfield
 */
- (void) generateAssessmentPortableDocumentFormat {
    // Fetch data and store in array
    NSArray *studentContent = [[NSArray alloc] initWithArray:[self retrieveClassAssessmentColumnContent]];

    // Render the PDF data
    [PDFRenderer drawPDF:[self getFilePathForPrintingPDF]
                   frame:LEGAL_PAPER_SIZE
             columnArray:[studentContent objectAtIndex:0]
            contentArray:[studentContent objectAtIndex:1]
             titleString:[studentContent objectAtIndex:2]
                 student:student
                testType:1];

    // Preview The PDF Data
    [self performSelectorOnMainThread:@selector(previewPDFData) withObject:nil waitUntilDone:NO];
} /* generateAssessmentPortableDocumentFormat */


/*
   generateStandardizedPortableDocumentFormat
   --------
   Purpose:        Generates Standardized PDF
   Parameters:     --
   Returns:        --
   Notes:          Throws PDF into WebView
   Author:         Neil Burchfield
 */
- (void) generateStandardizedPortableDocumentFormat {
    // Fetch data and store in array
    NSArray *studentContent = [[NSArray alloc] initWithArray:[self retrieveClassFormativeStandardizedColumnContent]];

    // Render the PDF data
    [PDFRenderer drawPDF:[self getFilePathForPrintingPDF]
                   frame:LEGAL_PAPER_SIZE
             columnArray:[[NSMutableArray alloc] initWithObjects:@"Formative", @"Standardized", nil]
            contentArray:[[NSMutableArray alloc] initWithObjects:[studentContent objectAtIndex:0], [studentContent objectAtIndex:1], nil]
             titleString:[studentContent objectAtIndex:2]
                 student:student
                testType:2];

    // Preview The PDF Data
    [self performSelectorOnMainThread:@selector(previewPDFData) withObject:nil waitUntilDone:NO];
} /* generateStandardizedPortableDocumentFormat */


/*
   processRequest
   --------
   Purpose:        Executes with HUD
   Parameters:     SEL
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) processRequest :(SEL)process {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.labelText = @"Generating Document";
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.navigationController.view addSubview:HUD];
    [HUD showWhileExecuting:process onTarget:self withObject:nil animated:YES];
} /* processRequest */


/*
   returnValueOfSubstringDoesEqual
   --------
   Purpose:        Compare string
   Parameters:     int, string
   Returns:        int
   Notes:          --
   Author:         Neil Burchfield
 */
- (int) returnValueOfSubstringDoesEqual :(int)i withStudentClassKey :(NSString *)string {

    // Range
    NSRange textRange;

    // Range of int
    textRange = [string rangeOfString:[NSString stringWithFormat:@"%d", i]];

    // Return yes if found
    if (textRange.location != NSNotFound)
        return i;

    return -1;
} /* returnValueOfSubstringDoesEqual */


#pragma mark -
#pragma mark Class Delegate's Bar Button Action Handler Methods

/*
   editCurrentUser
   --------
   Purpose:        Display Edit User View
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) editCurrentUser :(id)sender {

    int next = -1;
    if ([[nextView lowercaseString] isEqualToString:@"math"]) {
        next = kMath_Key;
    } else if ([[nextView lowercaseString] isEqualToString:@"reading"]) {
        next = kReading_Key;
    } else if ([[nextView lowercaseString] isEqualToString:@"writing"]) {
        next = kWriting_Key;
    } else if ([[nextView lowercaseString] isEqualToString:@"behavioral"]) {
        next = kBehavioral_Key;
    }

    EditUser *edv = [[EditUser alloc] init:student key:next index:indexPath title:nextView];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:edv];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
} /* editCurrentUser */


/*
   emailPopoverAction
   --------
   Purpose:        Email Popover
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) emailPopoverAction :(id)sender {
    [self.emailActionSheet showFromBarButtonItem:composeBarButtonItem animated:YES];
} /* emailPopoverAction */


/*
   contactAddPopoverAction
   --------
   Purpose:        Add Contact Popover
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) contactAddPopoverAction :(id)sender {
    [self.contactActionSheet showFromBarButtonItem:addContactBarButtonItem animated:YES];
} /* contactAddPopoverAction */


/*
   geolocationAction
   --------
   Purpose:        Geolocate Popover
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) geolocationAction :(id)sender {
    MapKitDisplayViewController *mkdvc = [[MapKitDisplayViewController alloc] initWithNibName:@"MapKitDisplayViewController"
                                                                                       bundle:[NSBundle mainBundle]
                                                                                      student:student];
    [self.navigationController pushViewController:mkdvc animated:YES];
} /* geolocationAction */


#pragma mark -
#pragma mark Custom UI Methods

/*
   pushNotesModalView
   --------
   Purpose:        Notes Modal
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) pushNotesModalView :(id)sender  {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(insertNote:)];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    vc.title = [NSString stringWithFormat:@"%@ Notes", [student fullName]];

    notesTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 495, 535)];
    notesTextView.contentInset = UIEdgeInsetsMake(12, 10, 0, 0);
    notesTextView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    notesTextView.textColor = [UIColor darkGrayColor];
    notesTextView.text = [StudentsDataLayer retrieveStudentDataFromClassDatabaseColumn:@"notes" withStudent:[student uid]];
    notesTextView.layer.cornerRadius = 4.0f;
    [vc.view addSubview:notesTextView];

    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
} /* pushModalView */


/*
   insertNote
   --------
   Purpose:        Insert Notes into SQL
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) insertNote :(id)sender {
    [StudentsDataLayer insertStudentDataIntoClassDatabaseColumn:@"notes" withStudent:[student uid] withText:notesTextView.text];
    [self dismissModalViewControllerAnimated:YES];
} /* insertNote */


/*
   cancel
   --------
   Purpose:        Dismiss Modal
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) cancel :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* cancel */


#pragma mark -
#pragma mark Class Orientation Method Delegate

/*
   willAnimateRotationToInterfaceOrientation
   --------
   Purpose:        Resets/Relayouts scroller based on orientation
   Parameters:     UIInterfaceOrientation, NSTimeInterval
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) willAnimateRotationToInterfaceOrientation :(UIInterfaceOrientation)orient duration :(NSTimeInterval)duration {

    // Layout scroller based on interface orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [toolBarImage setFrame:CGRectMake(710, 4, 35, 35)];
    else
        [toolBarImage setFrame:CGRectMake(650, 4, 35, 35)];

    CGRect initial_portrait = CGRectMake(40, -10.0f, 700, 500);
    CGRect initial_landscape = CGRectMake(10, -10.0f, 700, 500);

    // Layout scroller based on interface orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ) {
        [toolbar setFrame:CGRectMake(0, BOX_PORTRAIT.size.height - 44, BOX_PORTRAIT.size.width + 75, 44)];
        if (!isSettingsHidden) {
            [self.settingsViewController.view setFrame:initial_portrait];
        }
    } else {
        [toolbar setFrame:CGRectMake(0, BOX_LANDSCAPE.size.height - 300, BOX_LANDSCAPE.size.width, 44)];
        if (!isSettingsHidden) {
            [self.settingsViewController.view setFrame:initial_landscape];
        }
    }

    // Reset Scroller based on orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [self.scroller setFrame:BOX_PORTRAIT];
    else if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
        [self.scroller setFrame:CGRectMake(0, 130, 782, 525)];

    // relayout the sections
    [self.scroller layoutWithSpeed:0.0f completion:nil];
} /* willAnimateRotationToInterfaceOrientation */


#pragma mark -
#pragma mark Address Book Delegate Methods

/*
   checkIfContactsAreAccessible
   --------
   Purpose:        Checks if Contacts address book are accessible
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) checkIfContactsAreAccessible :(id)sender {
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                                                     // If access granted, revert selector on main thread since we're on another
                                                     [self performSelectorOnMainThread:
                                                      @selector(addContactToAddressBook:)
                                                                            withObject:nil
                                                                         waitUntilDone:NO];

                                                 });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addContactToAddressBook:self];
    } else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        UIAlertView *addressBookDeniedEntry = [[UIAlertView alloc] initWithTitle:@"No Address Book Access" message:@"Please change privacy setting in settings app to allow us add contacts" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [addressBookDeniedEntry show];
    }
} /* checkIfContactsAreAccessible */


/*
   addContactToAddressBook
   --------
   Purpose:        Adds contact if contacts address book are accessible
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) addContactToAddressBook :(id)sender {
    if ( selectedContactActionSheetButton != -1 ) {
        NSString *firstName = nil;
        NSString *lastName = nil;
        NSString *phone = nil;
        NSString *email = nil;
        NSString *address = NSLocalizedString([student address], @"Parent and Student share address");
        NSString *state = NSLocalizedString(@"Illinois", @"Default State");

        switch (selectedContactActionSheetButton) {
            case 0 :
            {
                firstName = [student firstName];
                lastName = [student lastName];
                phone = [student phone];
                email = [student email];
            }
            break;
            case 1 :
            {
                firstName = [student parent_firstName];
                lastName = [student parent_lastName];
                phone = [student parent_phone];
                email = [student parent_email];
            }
            break;
            default :
                break;
        } /* switch */

        CFErrorRef error = NULL;
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
        ABRecordRef newPerson = ABPersonCreate();
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), &error);
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), &error);


        // Add my phone number
        ABMutableMultiValueRef PhoneVar = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(PhoneVar, (__bridge CFTypeRef)(phone), kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, PhoneVar, nil);
        CFRelease(PhoneVar);


        // Add my email address
        ABMutableMultiValueRef EmailVar = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(EmailVar, (__bridge CFTypeRef)(email), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonEmailProperty, EmailVar, nil);
        CFRelease(EmailVar);


        // Add my mailing address
        ABMutableMultiValueRef Address = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
        [addressDict setObject:address forKey:(NSString *)kABPersonAddressStreetKey];
        [addressDict setObject:state forKey:(NSString *)kABPersonAddressStateKey];
        [addressDict setObject:@"United States" forKey:(NSString *)kABPersonAddressCountryKey];
        ABMultiValueAddValueAndLabel(Address, (__bridge CFTypeRef)(addressDict), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonAddressProperty, Address, &error);
        CFRelease(Address);

        // Finally saving the contact in the address book
        ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
        ABAddressBookSave(iPhoneAddressBook, &error);
        if (error != NULL) {
            NSLog(@"Saving contact failed.");
        }
    }
} /* addContactToAddressBook */


#pragma mark -
#pragma mark EKEventEditViewDelegate and other EKEvent methods

/*
   checkIfEventsAreAccessible
   --------
   Purpose:        Checks if User's Calendar events are accessible
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) checkIfEventsAreAccessible :(id)sender {
    if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion: ^(BOOL granted, NSError *er) {

             if (granted) {
                 // If access granted, revert selector on main thread since we're on another
                 [self performSelectorOnMainThread:
                  @selector(addEventToCalendar:)
                                        withObject:self.eventStore
                                     waitUntilDone:NO];
             }
         }];
    } else {
        [self addEventToCalendar:self];
    }
} /* checkIfEventsAreAccessible */


/*
   addEventToCalendar
   --------
   Purpose:        Adds Event if User's Calendar events are accessible
   Parameters:     sender
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) addEventToCalendar :(id)sender {
    EKEventEditViewController *addEKEventEditViewController = [[EKEventEditViewController alloc]
                                                               initWithNibName:nil
                                                                        bundle:nil];

    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
    event.title = [NSString stringWithFormat:@"Meeting with %@", [student fullName]];

    // set the addController's event store to the current event store.
    addEKEventEditViewController.eventStore = self.eventStore;
    addEKEventEditViewController.event = event;
    addEKEventEditViewController.modalPresentationStyle = UIModalPresentationFormSheet;

    // present EventsAddViewController as a modal view controller
    [self presentModalViewController:addEKEventEditViewController animated:YES];

    addEKEventEditViewController.editViewDelegate = self;

    return YES;
} /* addEventToCalendar */


/*
   didCompleteWithAction
   --------
   Purpose:        Overriding EKEventEditViewDelegate method to update event store according to user actions.
   Parameters:     EKEventEditViewController, EKEventEditViewAction
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) eventEditViewController :(EKEventEditViewController *)controller didCompleteWithAction :(EKEventEditViewAction)action {

    NSError *error = nil;

    switch (action) {
        case EKEventEditViewActionCanceled :
            break;
        case EKEventEditViewActionSaved :
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
        case EKEventEditViewActionDeleted :
            break;
        default :
            break;
    } /* switch */

    // Dismiss the modal view controller
    [controller dismissModalViewControllerAnimated:YES];
} /* eventEditViewController */


#pragma mark -
#pragma mark UIActionSheet didDismissWithButtonIndex delegate

/*
   didDismissWithButtonIndex
   --------
   Purpose:        Handles UIActionSheet button press.
   Parameters:     button index
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) actionSheet :(UIActionSheet *)actionSheet didDismissWithButtonIndex :(NSInteger)buttonIndex {

    switch (actionSheet.tag) {
        case kEmailActionSheet :
            [self emailSpecifiedIndividual:buttonIndex];
            break;
        case kContactActionSheet :
            selectedContactActionSheetButton = buttonIndex;
            [self checkIfContactsAreAccessible:self];
            break;
        default :
            break;
    } /* switch */
} /* actionSheet */


#pragma mark -
#pragma mark MFMailComposeViewController didFinishWithResult delegate and other Mailing methods

/*
   pathToFollowingResource
   --------
   Purpose:        Path to Resource in Documents
   Parameters:     button index
   Returns:        --
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
   emailSpecifiedIndividual
   --------
   Purpose:        Emails user based on button index
   Parameters:     int
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) emailSpecifiedIndividual :(int)buttonIndex {
    if ( buttonIndex != -1 ) {
        MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];

        switch (buttonIndex) {
            case 0 :
            {
                NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]
                                                           initWithContentsOfFile:[self pathToFollowingResource:kTeacherSettingsPlist]];

                if ([settingsDictionary objectForKey:kTeacherEmail])
                    [mailComposeViewController setToRecipients:[NSArray arrayWithObject:[settingsDictionary objectForKey:kTeacherEmail]]];
                else
                    [mailComposeViewController setToRecipients:[NSArray arrayWithObject:@""]];
            }
            break;
            case 1 :
                [mailComposeViewController setToRecipients:[NSArray arrayWithObject:[student parent_email]]];
                break;
            default :
                break;
        } /* switch */

        [mailComposeViewController setSubject:@""];
        [mailComposeViewController setMessageBody:@"" isHTML:NO];
        mailComposeViewController.mailComposeDelegate = self;

        [self presentModalViewController:mailComposeViewController animated:YES];
    }
} /* emailSpecifiedIndividual */


/*
   didFinishWithResult
   --------
   Purpose:        Handles MFMailComposeViewController finished result
   Parameters:     MFMailComposeResult, MFMailComposeViewController, NSError
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) mailComposeController :(MFMailComposeViewController *)controller didFinishWithResult :(MFMailComposeResult)result error :(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
} /* mailComposeController */


/*
   emailWithAttachment
   --------
   Purpose:        Email w/ Attachment
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) emailWithAttachment :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(loadMailComposer:) withObject:self afterDelay:0.7f];
} /* emailWithAttachment */


/*
   loadMailComposer
   --------
   Purpose:        Load Composer
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) loadMailComposer :(id)sender {
    MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
    [mailComposeViewController setSubject:@""];
    [mailComposeViewController setMessageBody:@"" isHTML:NO];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController addAttachmentData:[NSData dataWithContentsOfFile:[self getFilePathForPrintingPDF]]
                                        mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@_assessment.pdf", [student uid]]];
    [self presentModalViewController:mailComposeViewController animated:YES];
} /* loadMailComposer */


#pragma mark -
#pragma mark Method Declarations for printing PDF files

/*
   getFilePathForPrintingPDF
   --------
   Purpose:        Find PDF in Documents
   Parameters:     --
   Returns:        String
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) getFilePathForPrintingPDF {
    NSArray *arrayPaths =
        NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory,
            NSUserDomainMask,
            YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString *pdfFileName = [path stringByAppendingPathComponent:kPDFFileName];

    return pdfFileName;
} /* getFilePathForPrintingPDF */


/*
   previewPDFData
   --------
   Purpose:        Display PDF in WebView
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) previewPDFData {
    UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];

    NSString *pdfFileName = [self getFilePathForPrintingPDF];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:LEGAL_PAPER_SIZE];

    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    [vc setTitle:@"Preview"];

    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStyleBordered target:self action:@selector(emailWithAttachment:)];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    [vc.view addSubview:webView];

    webView.delegate = self;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController presentModalViewController:navController animated:YES];
} /* previewPDFData */


/*
   webViewDidFinishLoad
   --------
   Purpose:        WebView Delegate
   Parameters:     wEBvIEW
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) webViewDidFinishLoad :(UIWebView *)webView {
    webView.scrollView.minimumZoomScale = .68f;
    webView.scrollView.maximumZoomScale = .68f;
    webView.scrollView.zoomScale = .68f;
} /* webViewDidFinishLoad */


@end
