//
//  DetailViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import "DetailViewController.h"
#import "SwipeSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "MathAssessmentTableViewController.h"
#import "ReadingAssesmentViewController.h"
#import "WritingAssesmentViewController.h"
#import "BehavioralAssesmentViewController.h"

#import "MathTestTableViewController.h"
#import "ReadingTestTableViewController.h"
#import "WritingTestTableViewController.h"
#import "BehavioralTestTableViewController.h"

#import "MGBox.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"

#define HEADER_FONT   [UIFont fontWithName:@"HelveticaNeue" size:18]
#define ROW_SIZE      (CGSize) {666, 44 }
#define BOX_LANDSCAPE (CGRect) {12, 150, 768, 960 }
#define BOX_PORTRAIT  (CGRect) {40, 150, 704, 960 }

@implementation DetailViewController {
    MGBox *table1;
    MGBox *table2;
    MGLineStyled *header;
}
@synthesize scroller = _scroller;

- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    tableViewHeaders = [[NSArray alloc] initWithObjects:@"Phone", @"Address", @"Birthday", @"Parent First",
                        @"Parent Last", @"Parent Email", @"Parent Phone", @"Relationship", nil];

    self.scroller = [[MGScrollView alloc] init];

    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
        [self.scroller setFrame:BOX_PORTRAIT];
    else if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
        [self.scroller setFrame:BOX_LANDSCAPE];

    self.scroller.contentLayoutMode = MGLayoutGridStyle;
    self.scroller.bottomPadding = 8;
    [self.view addSubview:self.scroller];

    MGBox *tablesGrid = [MGBox boxWithSize:self.scroller.bounds.size];
    tablesGrid.contentLayoutMode = MGLayoutGridStyle;
    [self.scroller.boxes addObject:tablesGrid];

    table1 = MGBox.box;
    [tablesGrid.boxes addObject:table1];
    table1.sizingMode = MGResizingShrinkWrap;

    table2 = MGBox.box;
    [tablesGrid.boxes addObject:table2];
    table2.sizingMode = MGResizingShrinkWrap;

    return self;
} /* initWithNibName */


- (void) loopValuesIntoMGBox :(int)section :(int)row {
    [table1.boxes removeAllObjects];
    [table2.boxes removeAllObjects];

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

    tableViewContent = [[NSMutableArray alloc] initWithObjects:
                        [student phone],
                        [student address],
                        [NSString stringWithFormat:@"%d/%d/%d", [student dob_month], [student dob_day], [student dob_year]],
                        [student parent_firstName],
                        [student parent_lastName],
                        [student parent_email],
                        [student parent_phone],
                        [student relationship], nil];

    MGTableBoxStyled *menu = MGTableBoxStyled.box;
    [table1.boxes addObject:menu];

    __block DetailViewController *dtv = self;

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

        [menu.topLines addObject:header];
    }

    [table1 layoutWithSpeed:0.3 completion:nil];


    MGTableBoxStyled *menu2 = MGTableBoxStyled.box;
    [table2.boxes addObject:menu2];

    NSArray *testsContent = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Modify %@ Test Scores", [nextView capitalizedString]],
                             [NSString stringWithFormat:@"Modify %@ Assessment Scores", [nextView capitalizedString]], nil];

    for (int y = 0; y < 2; y++) {
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

    [table2 layoutWithSpeed:0.3 completion:nil];

    [self.scroller layoutWithSpeed:0.3 completion:nil];
} /* loopValuesIntoMGBox */


- (void) buttonpress :(int)row {
    switch (row) {
        case 8 :
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
        case 9 :
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
        default :
            break;
    } /* switch */
} /* buttonpress */


- (void) viewDidAppear :(BOOL)animated {
    if (( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
} /* viewDidAppear */


- (void) viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(updateContent:)
            name:@"UpdateContent"
          object:nil];
} /* viewDidLoad */


- (void) updateContent :(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"UpdateContent"]) {
        NSDictionary *userInfo = [notification userInfo];
        NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
        nextView = [userInfo objectForKey:@"view"];

        if (self.navigationController.view.subviews.count > 1)
            [self.navigationController popToRootViewControllerAnimated:YES];

        if ((indexPath.section >= 0) && (indexPath.row >= 0)) {
            [self loopValuesIntoMGBox:indexPath.section:indexPath.row];
            [self loadContentDataView:indexPath.section:indexPath.row];
        }
    }
} /* receiveTestNotification */


- (void) loadView {
    [super loadView];

    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [self allocContentDataView];

} /* loadView */


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
} /* allocContentDataView */


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

    if (shelfView.hidden)
        shelfView.hidden = !shelfView.hidden;
    if (shelfViewShadow.hidden)
        shelfViewShadow.hidden = !shelfViewShadow.hidden;

    self.title = [student fullName];

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

    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.bounds = CGRectMake(0, 0, 30, 30);
    [customButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png", [nextView lowercaseString]]] forState:UIControlStateNormal];
    UIBarButtonItem *customBarButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];

    self.navigationItem.rightBarButtonItem = customBarButton;

    NSString *asd = [NSString stringWithFormat:@"%@.jpg", [student uid]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:asd];
    NSFileManager *filemanager = [NSFileManager defaultManager];

    if ([filemanager fileExistsAtPath:imagePath]) {
        NSLog(@"IMAGE FOUND");
        studentImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    } else {
        NSLog(@"IMAGE NOT FOUND");
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


- (void) didRotateFromInterfaceOrientation :(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"self.view.width: %f", self.view.bounds.size.width);
    NSLog(@"self.view.height: %f", self.view.bounds.size.height);
} /* didRotateFromInterfaceOrientation */


- (void) willAnimateRotationToInterfaceOrientation :(UIInterfaceOrientation)orient duration :(NSTimeInterval)duration {

    if ( UIInterfaceOrientationIsPortrait(orient) )
        [self.scroller setFrame:BOX_PORTRAIT];
    else if ( UIInterfaceOrientationIsLandscape(orient) )
        [self.scroller setFrame:BOX_LANDSCAPE];

    // relayout the sections
    [self.scroller layoutWithSpeed:0.0f completion:nil];
} /* willAnimateRotationToInterfaceOrientation */


@end
