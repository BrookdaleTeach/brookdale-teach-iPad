//
//  DetailViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

// Import
#import "DetailViewHeaderImports.h"

// Main Implementation
@implementation DetailViewController {

    // MGBox Declarations
    MGBox *table1;
    MGBox *table2;
    MGBox *table3;
    MGLineStyled *header;

    // UIBarButtonItems Declarations
    UIBarButtonItem *composeBarButtonItem;
    UIBarButtonItem *addContactBarButtonItem;
    UIBarButtonItem *geolocateBarButtonItem;
    UIBarButtonItem *addToCalendarBarButtonItem;
    UIBarButtonItem *editUser;

}

// Synthesizations
@synthesize mapView = _mapView;
@synthesize scroller = _scroller;
@synthesize eventStore = _eventStore;
@synthesize defaultCalendar = _defaultCalendar;
@synthesize emailActionSheet = _emailActionSheet;
@synthesize contactActionSheet = _contactActionSheet;
@synthesize addEventActionSheet = _addEventActionSheet;

#pragma mark -
#pragma mark Class Delegate's Constructor

/*
   //
   Method: viewDidLoad
   Args: none
   Notes: Initially load data
   Auth: Neil Burchfield
   //
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

} /* viewDidLoad */


#pragma mark -
#pragma mark Class Delegate's MGBox Data Handler (Allocing)

/*
   //
   Method: setupMGBoxes
   Args: none
   Notes: Initilally sets up MGBoxes for further layout
   Auth: Neil Burchfield
   //
 */
- (void) setupMGBoxes {
    // Init Scroller
    self.scroller = [[MGScrollView alloc] init];

    // Layout scroller based on interface orientation
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [self.scroller setFrame:BOX_PORTRAIT];
    else if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
        [self.scroller setFrame:BOX_LANDSCAPE];

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
    if (![nextView isEqualToString:@"All Students"])
    {
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
   //
   Method: loopValuesIntoMGBox
   Args: int: section
       int: row
   Notes: Handles UIActionSheet button press
   Auth: Neil Burchfield
   //
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
    if (![nextView isEqualToString:@"All Students"])
    {
        // Setup second menu
        MGTableBoxStyled *menu2 = MGTableBoxStyled.box;
        [table2.boxes addObject:menu2];

        
        // Add Static content to array
        NSArray *testsContent = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Modify %@ Test Scores", [nextView capitalizedString]],
                                 [NSString stringWithFormat:@"Modify %@ Assessment Scores", [nextView capitalizedString]], nil];

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
    }
    else {
        print1 = [MGLineStyled lineWithLeft:@"Print Assessments"
                                      right:[UIImage imageNamed:@"arrow"]
                                       size:ROW_SIZE];
        print2 = [MGLineStyled lineWithLeft:@"Print Standardized Tests"
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
   //
   Method: updateContent
   Args: NSNotification
   Notes: Handles update NSNotification call
   Auth: Neil Burchfield
   //
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
   //
   Method: allocContentDataView
   Args: none
   Notes: Alloc initial data
   Auth: Neil Burchfield
   //
 */
- (void) allocContentDataView {

    // Set Student Shelf
    shelfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width + 55, self.view.bounds.size.height / 8)];
    shelfView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    shelfView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    shelfView.layer.masksToBounds = YES;
    shelfView.alpha = .9;

    CAGradientLayer *bgLayer = [self customGradient:[UIColor whiteColor] :[UIColor lightGrayColor]];
    bgLayer.frame = shelfView.bounds;

    [shelfView.layer insertSublayer:bgLayer atIndex:0];
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
    studentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,
                                                                     88, 88)];
    [self.view addSubview:studentImageView];

    // Set Student Name Label
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 300, 23)];
    [nameLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:22.0f]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:nameLabel];

    // Set Student Email Label
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 300, 19)];
    [emailLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:17.0f]];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:emailLabel];

    // Set Student UID Label
    uidLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 62, 300, 19)];
    [uidLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:17.0f]];
    [uidLabel setBackgroundColor:[UIColor clearColor]];
    [uidLabel setTextColor:[UIColor grayColor]];
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

    self.emailActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Email Student", @"Email Parent", nil];
    self.emailActionSheet.tag = kEmailActionSheet;

    // Geolocation Button and Actiom
    UIButton *customBarButtonGeo = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBarButtonGeo setImage:[UIImage imageNamed:@"71-compass"] forState:UIControlStateNormal];
    [customBarButtonGeo setFrame:CGRectMake(0, 0, 50, 50)];
    [customBarButtonGeo addTarget:self action:@selector(geolocationAction:) forControlEvents:UIControlEventTouchDown];
    geolocateBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonGeo];
    geolocateBarButtonItem.enabled = NO;

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addContactBarButtonItem, composeBarButtonItem, geolocateBarButtonItem, addToCalendarBarButtonItem, nil];

    editUser = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editCurrentUser:)];
    editUser.enabled = NO;

    self.navigationItem.leftBarButtonItem = editUser;

} /* allocContentDataView */


#pragma mark -
#pragma mark Class Delegate's View Loading Content method

/*
   //
   Method: loadContentDataView
   Args: int - section
       int - row
   Notes: Loads Detail View Content based on section/row pair
   Auth: Neil Burchfield
   //
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
    if (shelfViewShadow.hidden) {
        shelfViewShadow.hidden = !shelfViewShadow.hidden;
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

    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = .5f;
    [shelfView.layer addAnimation:animation forKey:nil];
    shelfView.alpha = 1.0f;
    [shelfViewShadow.layer addAnimation:animation forKey:nil];
    shelfViewShadow.alpha = 1.0f;

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
    [emailLabel setText:[student email]];

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

- (NSArray *) retrieveClassAssessmentColumnContent {
    NSArray *classContentData = nil;
    NSArray *classStringsArray = nil;
    NSString *title = nil;

    switch ([student classkey]) {
        case kMath_Key :
            title = @"Math Observation/Anecdotal Record Checklist";
            classStringsArray = [[NSMutableArray alloc] initWithObjects:[kMathBehaviorsStrings componentsSeparatedByString:@",, "],
                                 [kMathSkillsStrings componentsSeparatedByString:@",, "], nil];
            classContentData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];
            break;
        case kReading_Key :
            title = @"Reading Observation/Anecdotal Record Checklist";
            classStringsArray = [[NSMutableArray alloc] initWithObjects:[kReadingStrategiesStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kReadingDecodingStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kReadingFluencyStrings componentsSeparatedByString:kStringsDelimiter], nil];
            classContentData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];
            break;
        case kWriting_Key :
            title = @"Writing Observation/Anecdotal Record Checklist";
            classStringsArray = [[NSMutableArray alloc] initWithObjects:[kWritingMechanicStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kWritingOrganizationStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kWritingProcessesStrings componentsSeparatedByString:kStringsDelimiter], nil];
            classContentData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];
            break;
        case kBehavioral_Key :
            title = @"Writing Observation/Anecdotal Record Checklist";
            classStringsArray = [[NSMutableArray alloc] initWithObjects:[kBehavioralAttendanceStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kBehavioralRespectStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kBehavioralResponsibilityStrings componentsSeparatedByString:kStringsDelimiter],
                                 [kBehavioralFeelingsStrings componentsSeparatedByString:kStringsDelimiter], nil];
            classContentData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];
            break;
        default :
            break;
    } /* switch */
    return [[NSArray alloc] initWithObjects:classStringsArray, classContentData, title, nil];
} /* retrieveClassAssessmentColumnContent */

#pragma mark -
#pragma mark Class Delegate's Data Retrieval Method

- (NSArray *) retrieveClassFormativeStandardizedColumnContent {
    NSArray *formativeData = nil;
    NSArray *standardizedData = nil;
    NSString *title = nil;
    
    switch ([student classkey]) {
        case kMath_Key :
            title = @"Student Math Formative/Standardized Tests";
            formativeData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            standardizedData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        case kReading_Key :
            title = @"Student Reading Formative/Standardized Tests";
            formativeData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            standardizedData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        case kWriting_Key :
            title = @"Student Writing Formative/Standardized Tests";
            formativeData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            standardizedData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        case kBehavioral_Key :
            title = @"Student Behavioral Formative/Standardized Tests";
            formativeData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            standardizedData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        default :
            break;
    } /* switch */
    return [[NSArray alloc] initWithObjects:formativeData, standardizedData, title, nil];
} /* retrieveClassAssessmentColumnContent */


#pragma mark -
#pragma mark Class Delegate's MGBox Button Press Action Handler

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
            [self previewPDFData];
        }
        break;
        case kPrintStandardizedTag :
        {
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
            [self previewPDFData];
        }
            break;
        case 12311 :
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSString *next = nil;
            
            switch ([student classkey]) {
                case kMath_Key:
                    array = appDelegate.mathStudentsArray;
                    next = @"Math";
                    break;
                case kReading_Key:
                    array = appDelegate.readingStudentsArray;
                    next = @"Reading";
                    break;
                case kWriting_Key:
                    array = appDelegate.writingStudentsArray;
                    next = @"Writing";
                    break;
                case kBehavioral_Key:
                    array = appDelegate.behavioralStudentsArray;
                    next = @"Behavioral";
                    break;
                default:
                    break;
            }
            
            int sect = 0, row = 0;
            BOOL found = NO;
            for (NSArray *sarray in array)
            {
                row = 0;
                for (Student *s in sarray)
                {
                    if ([[s uid] isEqualToString:[student uid]]) {
                        found = YES;
                        break;
                    }
                    row++;
                }
                
                if (found) { break; }
                
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


#pragma mark -
#pragma mark Class Delegate's Bar Button Action Handler Methods

/*
   //
   Method: editCurrentUser
   Args: sender
   Notes: Edit User Controller
   Auth: Neil Burchfield
   //
 */
- (void) editCurrentUser :(id)sender {
    EditUser *edv = [[EditUser alloc] init:student key:[student classkey] index:indexPath title:nextView];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:edv];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
} /* editCurrentUser */


/*
   //
   Method: emailPopoverAction
   Args: sender
   Notes: Email Popover Action Handler
   Auth: Neil Burchfield
   //
 */
- (void) emailPopoverAction :(id)sender {
    [self.emailActionSheet showFromBarButtonItem:composeBarButtonItem animated:YES];
} /* emailPopoverAction */


/*
   //
   Method: contactAddPopoverAction
   Args: sender
   Notes: Add Contact Popover Action Handler
   Auth: Neil Burchfield
   //
 */
- (void) contactAddPopoverAction :(id)sender {
    [self.contactActionSheet showFromBarButtonItem:addContactBarButtonItem animated:YES];
} /* contactAddPopoverAction */


/*
   //
   Method: geolocationAction
   Args: sender
   Notes: Push Maps Popover Action Handler
   Auth: Neil Burchfield
   //
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
   //
   Method: customGradient
   Args: UIColor first, UIColor Second
   Notes: Creates custom gradient based on two colors
   Auth: Neil Burchfield
   //
 */
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


#pragma mark -
#pragma mark Class Orientation Method Delegate

/*
   //
   Method: willAnimateRotationToInterfaceOrientation
   Args: UIInterfaceOrientation, NSTimeInterval
   Notes: Resets/Relayouts scroller based on orientation
   Auth: Neil Burchfield
   //
 */
- (void) willAnimateRotationToInterfaceOrientation :(UIInterfaceOrientation)orient duration :(NSTimeInterval)duration {

    // Reset Scroller based on orientation
    if ( UIInterfaceOrientationIsPortrait(orient) )
        [self.scroller setFrame:BOX_PORTRAIT];
    else if ( UIInterfaceOrientationIsLandscape(orient) )
        [self.scroller setFrame:BOX_LANDSCAPE];

    // relayout the sections
    [self.scroller layoutWithSpeed:0.0f completion:nil];
} /* willAnimateRotationToInterfaceOrientation */


#pragma mark -
#pragma mark Address Book Delegate Methods

/*
   //
   Method: checkIfContactsAreAccessible
   Args: sender
   Notes: Checks if Contacts address book are accessible
   Auth: Neil Burchfield
   //
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
   //
   Method: addContactToAddressBook
   Args: sender
   Notes: Adds contact if contacts address book are accessible
   Auth: Neil Burchfield
   //
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
   //
   Method: checkIfEventsAreAccessible
   Args: sender
   Notes: Checks if User's Calendar events are accessible
   Auth: Neil Burchfield
   //
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
   //
   Method: addEventToCalendar
   Args: sender
   Notes: Adds Event if User's Calendar events are accessible
   Auth: Neil Burchfield
   //
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
   //
   Method: didCompleteWithAction
   Args: EKEventEditViewController, EKEventEditViewAction
   Notes: Overriding EKEventEditViewDelegate method to update event store according to user actions.
   Auth: Neil Burchfield
   //
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
   //
   Method: didDismissWithButtonIndex
   Args: button index
   Notes: Handles UIActionSheet button press
   Auth: Neil Burchfield
   //
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
   //
   Method: emailSpecifiedIndividual
   Args: int - buttonIndex
   Notes: Emails user based on button index
   Auth: Neil Burchfield
   //
 */
- (void) emailSpecifiedIndividual :(int)buttonIndex {
    if ( buttonIndex != -1 ) {
        MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];

        switch (buttonIndex) {
            case 0 :
                [mailComposeViewController setToRecipients:[NSArray arrayWithObject:[student email]]];
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
   //
   Method: didFinishWithResult
   Args: MFMailComposeResult: result handler
   NSError: error
   Notes: Handles UIActionSheet button press
   Auth: Neil Burchfield
   //
 */
- (void) mailComposeController :(MFMailComposeViewController *)controller didFinishWithResult :(MFMailComposeResult)result error :(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
} /* mailComposeController */


- (void) emailWithAttachment :(id)sender {

    [self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(loadMailComposer:) withObject:self afterDelay:0.7f];

} /* emailWithAttachment */

- (void)loadMailComposer:(id)sender
{
    
    MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
    
    [mailComposeViewController setSubject:@""];
    
    [mailComposeViewController setMessageBody:@"" isHTML:NO];
    
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController addAttachmentData:[NSData dataWithContentsOfFile:[self getFilePathForPrintingPDF]] mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@_assessment.pdf", [student uid]]];
    
    [self presentModalViewController:mailComposeViewController animated:YES];
}
#pragma mark -
#pragma mark Method Declarations for printing PDF files

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


- (void) webViewDidFinishLoad :(UIWebView *)webView {
    webView.scrollView.minimumZoomScale = .68f;
    webView.scrollView.maximumZoomScale = .68f;
    webView.scrollView.zoomScale = .68f;
} /* webViewDidFinishLoad */


- (void) cancel :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* cancel */


@end
