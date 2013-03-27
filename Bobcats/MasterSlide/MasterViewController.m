//
//  MasterViewController
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AboutViewController.h"
#import "StudentTableViewController.h"
#import "CustomTableView.h"
#import "UIImage+UIColor.h"
#import "ClassDefinitions.h"
#import "MGBoxLine.h"

#define start_color         [UIColor colorWithHex:0xEEEEEE]
#define end_color           [UIColor colorWithHex:0xDEDEDE]
#define LANDSCAPE_PADDING   44
#define FIRST_USE_ALERT_TAG 1

@implementation MasterViewController

@synthesize detailViewController;

- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    self.title = NSLocalizedString(@"Home", nil);
    return self;
} /* initWithNibName */


- (void) viewDidLoad {
    [super viewDidLoad];
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


- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
} /* shouldAutorotateToInterfaceOrientation */


- (void) showInfo :(id)sender {
    // TODO: Show info dialog with libxar license
    AboutViewController *vc = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self.view.window.rootViewController presentModalViewController:navController animated:YES];
} /* showInfo */


- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {
    if (section == 0)
        return @"View All";
    else
        return @"Subjects";
} /* tableView */


- (NSInteger) numberOfSectionsInTableView :(UITableView *)aTableView {
    return 2;
} /* numberOfSectionsInTableView */


- (NSInteger) tableView :(UITableView *)aTableView numberOfRowsInSection :(NSInteger)section {
    if (section == 0)
        return 1;
    else
        return [headers count];
} /* tableView */


- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        if (indexPath.section == 0)
            cell = [self getCellContentViewForPassword:CellIdentifier :indexPath.row:10 + indexPath.row:50 + indexPath.row];
        else if (indexPath.section == 1)
            cell = [self getCellContentViewForPassword:CellIdentifier :100 + indexPath.row:105 + indexPath.row:150 + indexPath.row];
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
                case 0:
                    corner.image = [UIImage imageNamed:@"RedCorner"];
                    break;
                case 1:
                    corner.image = [UIImage imageNamed:@"BlueCorner"];
                    break;
                case 2:
                    corner.image = [UIImage imageNamed:@"GreenCorner"];
                    break;
                case 3:
                    corner.image = [UIImage imageNamed:@"OrangeCorner"];
                    break;
                default:
                    break;
            }
            [cell.contentView addSubview:corner];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [iv setFrame:CGRectMake(0, 0, 17, 17)];
    cell.accessoryView = iv;

    return cell;
} /* tableView */


- (void) viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadSectionSubtitles];
} /* viewWillAppear */


- (int) realloc :(NSMutableArray *)array {
    return [[[NSMutableArray alloc] initWithArray:array] count];
} /* realloc */


- (void) reloadSectionSubtitles {

    int total = 0, math = 0, reading = 0, writing = 0, behavioral = 0;
    for (NSArray *array in appDelegate.studentArraySectioned) {
        for (Student *student in array) {

            switch ([[student classkey] integerValue]) {
                case kMath_Key :
                    math++;
                    break;
                case kReading_Key :
                    reading++;
                    break;
                case kWriting_Key :
                    writing++;
                    break;
                case kBehavioral_Key :
                    behavioral++;
                    break;
                default :
                    break;
            } /* switch */
        }
        total += array.count;
    }

    [(UILabel *)[self.view viewWithTag:400] setText :[NSString stringWithFormat:@"%d students total", total]];
    [(UILabel *)[self.view viewWithTag:500] setText :[NSString stringWithFormat:@"%d students enrolled", math]];
    [(UILabel *)[self.view viewWithTag:501] setText :[NSString stringWithFormat:@"%d students enrolled", reading]];
    [(UILabel *)[self.view viewWithTag:502] setText :[NSString stringWithFormat:@"%d students enrolled", writing]];
    [(UILabel *)[self.view viewWithTag:503] setText :[NSString stringWithFormat:@"%d students enrolled", behavioral]];

} /* reloadSectionSubtitles */


- (UITableViewCell *) getCellContentViewForPassword :(NSString *)cellIdentifier :(int)headtag :(int)imageTag :(int)layerTag {

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
} /* getCellContentViewForPassword */


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


- (BOOL) shouldAutorotate :(UIInterfaceOrientation)interfaceOrientation {

    [self.tableView reloadData];
    return(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
} /* shouldAutorotate */

- (void) tableView :(UITableView *)aTableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
} /* tableView */


- (void) insertFooter {
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
} /* insertFooter */


@end

