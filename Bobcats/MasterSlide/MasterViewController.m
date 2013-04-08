//
//  MasterViewController
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AboutViewController.h"
#import "StudentTableViewController.h"
#import "CustomTableView.h"
#import "UIImage+UIColor.h"
#import "ClassDefinitions.h"
#import "MGBoxLine.h"
#import "TestFlight.h"

/* Static Definitions */

#define start_color         [UIColor colorWithHex:0xEEEEEE]
#define end_color           [UIColor colorWithHex:0xDEDEDE]
#define LANDSCAPE_PADDING   44
#define FIRST_USE_ALERT_TAG 1

/*
 * Class Main Implementation
 */
@implementation MasterViewController

/* Sythesizations */

@synthesize detailViewController;

/*
   InitWithMasterViewController
   --------
   Purpose:        Initilizes Class with Views
   Parameters:     nib
   Returns:        self
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    self.title = NSLocalizedString(@"Home", nil);
    return self;
} /* initWithNibName */


/*
   viewDidLoad
   --------
   Purpose:        Delegate
   Parameters:     --
   Returns:        --
   Notes:          Show Master on Portait
   Author:         Neil Burchfield
 */
- (void) viewDidLoad {
    [super viewDidLoad];

    // Reload TableView Subtitles TableView Data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSectionSubtitles)
                                                 name:kMasterShouldReloadTableView object:nil];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.9f alpha:1.0f]]
                                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    self.clearsSelectionOnViewWillAppear = YES;
    self.contentSizeForViewInPopover = CGSizeMake(400.0, 1024.0);
    self.tableView.rowHeight = 64.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    headers = [[NSArray alloc] initWithObjects:@"Math", @"Reading", @"Writing", @"Behavior", nil];
    images = [[NSArray alloc] initWithObjects:@"math_icon", @"reading_icon", @"writing_icon", @"behavioral_icon", nil];

    [self insertFooter];

} /* viewDidLoad */


/*
   shouldAutorotateToInterfaceOrientation
   --------
   Purpose:        AutoRotate
   Parameters:     UIInterfaceOrientation
   Returns:        BOOL
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    return YES;
} /* shouldAutorotateToInterfaceOrientation */


/*
   shouldAutorotateToInterfaceOrientation
   --------
   Purpose:        showInfo
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) showInfo :(id)sender {
    // TODO: Show info dialog with libxar license
    AboutViewController *vc = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self.view.window.rootViewController presentModalViewController:navController animated:YES];
} /* showInfo */


/*
   titleForHeaderInSection
   --------
   Purpose:        Title based on section
   Parameters:     string
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {
    if (section == 0)
        return @"View All";
    else
        return @"Subjects";
} /* tableView */


/*
   numberOfSectionsInTableView
   --------
   Purpose:        Section count
   Parameters:     UITableView, int
   Returns:        int
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) numberOfSectionsInTableView :(UITableView *)aTableView {
    return 2;
} /* numberOfSectionsInTableView */


/*
   numberOfRowsInSection
   --------
   Purpose:        Row count
   Parameters:     UITableView, int
   Returns:        int
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) tableView :(UITableView *)aTableView numberOfRowsInSection :(NSInteger)section {
    if (section == 0)
        return 1;
    else
        return [headers count];
} /* tableView */


/*
   cellForRowAtIndexPath
   --------
   Purpose:        Delegate Tableview Content
   Parameters:     UITableView, NSIndexPath
   Returns:        UITableViewCell
   Notes:          --
   Author:         Neil Burchfield
 */
- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        if (indexPath.section == 0)
            cell = [self getCellContentView:CellIdentifier :indexPath.row:10 + indexPath.row:50 + indexPath.row];
        else if (indexPath.section == 1)
            cell = [self getCellContentView:CellIdentifier :100 + indexPath.row:105 + indexPath.row:150 + indexPath.row];
    }

    if (indexPath.section == 0) {
        UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, 200, 30)];
        formTitleField.textColor = [UIColor darkGrayColor]; // 60	62	62
        formTitleField.text = @"Class List";
        formTitleField.backgroundColor = [UIColor clearColor];
        formTitleField.textAlignment = NSTextAlignmentLeft;
        formTitleField.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21.0f];
        [cell.contentView addSubview:formTitleField];

        UILabel *formSubTitleField = [[UILabel alloc] initWithFrame:CGRectMake(85, 33, 116, 30)];
        formSubTitleField.textColor = [UIColor darkGrayColor]; // 60	62	62
        formSubTitleField.backgroundColor = [UIColor clearColor];
        formSubTitleField.textAlignment = NSTextAlignmentLeft;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 1);
        imageView.layer.shadowRadius = 4.0f;
        imageView.layer.masksToBounds = NO;

        UIImage *im = [UIImage imageNamed:@"all_icon"];
        imageView.frame = CGRectMake(20, 10, 48, 48);
        imageView.image = im;
        [cell addSubview:imageView]; // 210	206	203

        UIImageView *corner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreyCorner"]];
        corner.frame = CGRectMake(-1, -2, 29, 32);
        [cell.contentView addSubview:corner];

    } else {
        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:100 + indexPath.row];
        mainContentLabel.text = [headers objectAtIndex:indexPath.row];

        UIImageView *mainContentValueImage = (UIImageView *)[cell viewWithTag:105 + indexPath.row];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
        mainContentValueImage.frame = CGRectMake(20, 10, 48, 48);
        mainContentValueImage.image = image;

        UIImageView *corner = [[UIImageView alloc] init];
        corner.frame = CGRectMake(-1, -2, 29, 32);
        switch (indexPath.row) {
            case 0 :
                corner.image = [UIImage imageNamed:@"RedCorner"];
                break;
            case 1 :
                corner.image = [UIImage imageNamed:@"BlueCorner"];
                break;
            case 2 :
                corner.image = [UIImage imageNamed:@"GreenCorner"];
                break;
            case 3 :
                corner.image = [UIImage imageNamed:@"OrangeCorner"];
                break;
            default :
                break;
        } /* switch */
        [cell.contentView addSubview:corner];

    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [iv setFrame:CGRectMake(0, 0, 17, 17)];
    cell.accessoryView = iv;

    return cell;
} /* tableView */


/*
   viewWillAppear
   --------
   Purpose:        Delegate On Class Appear
   Parameters:     BOOL
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadSectionSubtitles];
} /* viewWillAppear */


/*
   realloc
   --------
   Purpose:        Re-allocate data
   Parameters:     BOOL
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (int) realloc :(NSMutableArray *)array {
    return [[[NSMutableArray alloc] initWithArray:array] count];
} /* realloc */


/*
   returnValueOfSubstringDoesEqual
   --------
   Purpose:        Find class key
   Parameters:     int, NSString
   Returns:        int
   Notes:          --
   Author:         Neil Burchfield
 */
- (int) returnValueOfSubstringDoesEqual :(int)i withStudentClassKey :(NSString *)string {

    // Range
    NSRange textRange;

    // Range of int
    textRange = [string rangeOfString:[NSString stringWithFormat:@"%d", i] options:NSCaseInsensitiveSearch];

    // Return yes if found
    if (textRange.location != NSNotFound)
        return i;

    return -1;
} /* returnValueOfSubstringDoesEqual */


/*
   reloadSectionSubtitles
   --------
   Purpose:        Reload Section Subtitle data
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) reloadSectionSubtitles {

    int total = 0, math = 0, reading = 0, writing = 0, behavioral = 0;
    for (NSArray *array in appDelegate.studentArraySectioned) {
        for (Student *student in array) {
            if ([self returnValueOfSubstringDoesEqual:kMath_Key withStudentClassKey:[student classkey]] == kMath_Key) {
                math++;
            }
            if ([self returnValueOfSubstringDoesEqual:kReading_Key withStudentClassKey:[student classkey]] == kReading_Key) {
                reading++;
            }
            if ([self returnValueOfSubstringDoesEqual:kWriting_Key withStudentClassKey:[student classkey]] == kWriting_Key) {
                writing++;
            }
            if ([self returnValueOfSubstringDoesEqual:kBehavioral_Key withStudentClassKey:[student classkey]] == kBehavioral_Key) {
                behavioral++;
            }
        }
        total += array.count;
    }

    [(UILabel *)[self.view viewWithTag:400] setText :[NSString stringWithFormat:@"%d students total", total]];
    [(UILabel *)[self.view viewWithTag:500] setText :[NSString stringWithFormat:@"%d students enrolled", math]];
    [(UILabel *)[self.view viewWithTag:501] setText :[NSString stringWithFormat:@"%d students enrolled", reading]];
    [(UILabel *)[self.view viewWithTag:502] setText :[NSString stringWithFormat:@"%d students enrolled", writing]];
    [(UILabel *)[self.view viewWithTag:503] setText :[NSString stringWithFormat:@"%d students enrolled", behavioral]];

} /* reloadSectionSubtitles */


/*
   getCellContentView
   --------
   Purpose:        Custom Cell Usage
   Parameters:     int, int, int, string
   Returns:        UITableViewCell
   Notes:          --
   Author:         Neil Burchfield
 */
- (UITableViewCell *) getCellContentView :(NSString *)cellIdentifier :(int)headtag :(int)imageTag :(int)layerTag {

    CGRect CellFrame = CGRectMake(0, 0, 300, 60);

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    UIImage *gradientImage44 = [[UIImage_UIColor imageWithColor:[UIColor colorWithWhite:.86f alpha:1.0f]]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    cell.backgroundColor = [UIColor colorWithPatternImage:gradientImage44];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setFrame:CellFrame];

    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, 116, 30)];
    formTitleField.textColor = [UIColor darkGrayColor]; // 60	62	62
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentLeft;
    formTitleField.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21.0f];
    formTitleField.tag = headtag;
    [cell.contentView addSubview:formTitleField];

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];

    UILabel *formSubTitleField = [[UILabel alloc] initWithFrame:CGRectMake(85, 33, 116, 30)];
    formSubTitleField.textColor = [UIColor darkGrayColor]; // 60	62	62
    formSubTitleField.backgroundColor = [UIColor clearColor];
    formSubTitleField.textAlignment = NSTextAlignmentLeft;
    formSubTitleField.tag = headtag + 400;

    if (headtag - 99 == kMath_Key)
        formSubTitleField.text = [NSString stringWithFormat:@"%d students enrolled", appDelegate.mathStudentsArray.count];
    else if (headtag - 99 == kWriting_Key)
        formSubTitleField.text = [NSString stringWithFormat:@"%d students enrolled", appDelegate.writingStudentsArray.count];
    else if (headtag - 99 == kReading_Key)
        formSubTitleField.text = [NSString stringWithFormat:@"%d students enrolled", appDelegate.readingStudentsArray.count];
    else if (headtag - 99 == kBehavioral_Key)
        formSubTitleField.text = [NSString stringWithFormat:@"%d students enrolled", appDelegate.behavioralStudentsArray.count];
    else {
        int numberOfStudentsPerClass = 0;
        for (NSArray *studentArray in appDelegate.studentArraySectioned) {
            numberOfStudentsPerClass += studentArray.count;
        }
        formSubTitleField.text = [NSString stringWithFormat:@"%d students total", numberOfStudentsPerClass];
    }

    formSubTitleField.font = [UIFont fontWithName:@"Arial-ItalicMT" size:12.0f];

    [cell.contentView addSubview:formSubTitleField];

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    imageView.tag = imageTag;
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    imageView.layer.shadowRadius = 4.0f;
    imageView.layer.masksToBounds = NO;
    [cell addSubview:imageView];

    MGBoxLine *line = [MGBoxLine lineWithWidth:cell.width];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height + 2.5 - line.height, cell.width, line.height)];
    [lineView addSubview:line];
    [cell addSubview:lineView];

    return cell;
} /* getCellContentView */


/*
   shouldAutorotate
   --------
   Purpose:        Autorotate
   Parameters:     UIInterfaceOrientation
   Returns:        BOOL
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotate :(UIInterfaceOrientation)interfaceOrientation {
    return YES;
} /* shouldAutorotate */


/*
   didSelectRowAtIndexPath
   --------
   Purpose:        TableView Cell
   Parameters:     NSIndexPath, UITableView
   Returns:        BOOL
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) tableView :(UITableView *)aTableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *initwitharray = nil;
    NSString *initwithtitle = nil;
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0 :
                initwithtitle = @"Math";
                initwitharray = [[NSMutableArray alloc] initWithArray:appDelegate.mathStudentsArray];
                break;
            case 1 :
                initwithtitle = @"Reading";
                initwitharray = [[NSMutableArray alloc] initWithArray:appDelegate.readingStudentsArray];
                break;
            case 2 :
                initwithtitle = @"Writing";
                initwitharray = [[NSMutableArray alloc] initWithArray:appDelegate.writingStudentsArray];
                break;
            case 3 :
                initwithtitle = @"Behavioral";
                initwitharray = [[NSMutableArray alloc] initWithArray:appDelegate.behavioralStudentsArray];
                break;
            default :
                initwitharray = [[NSMutableArray alloc] initWithArray:appDelegate.studentArraySectioned];
                break;
        } /* switch */
    } else {
        initwithtitle = @"All Students";
        initwitharray = [[NSMutableArray alloc] initWithArray:appDelegate.studentArraySectioned];
    }

    StudentTableViewController *stvc = [[StudentTableViewController alloc] init:initwithtitle
                                                                 arraySectioned:initwitharray
                                                                       classkey:indexPath.row + 1];
    [self.navigationController pushViewController:stvc animated:YES];
    
    [self sendTestFlightCheckPointWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]
                                   withMessage:[NSString stringWithFormat:@"%@ TableView Cell Selected", initwithtitle]];
} /* tableView */


/*
   insertFooter
   --------
   Purpose:        Footer View
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) insertFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutButton setTitle:NSLocalizedString(@"About iTeach", nil) forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    aboutButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    aboutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    aboutButton.showsTouchWhenHighlighted = YES;
    [aboutButton setFrame:CGRectInset(footerView.bounds, 50, 20)];
    [aboutButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:aboutButton];
    self.tableView.tableFooterView = footerView;
} /* insertFooter */

- (void)sendTestFlightCheckPointWithFunction:(NSString *)functionName withMessage:(NSString *)mess {
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@: %@", functionName, mess]];
}

@end

