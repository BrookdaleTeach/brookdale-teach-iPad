//
//  WritingAssesmentViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/29/13.
//
//

#import "WritingAssesmentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WritingAssessmentModel.h"
#import "UISegmentedControlExtension.h"

@implementation WritingAssesmentViewController
@synthesize studentObjectData = _studentObjectData;

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Writing Observation/Anecdotal Record Checklist", nil);
        student = st;
    }
    return self;
} /* initWithStyle */


- (void) viewDidLoad {
    [super viewDidLoad];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.studentObjectData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel retrieveStudentDataFromDatabase:[student uid]]];

    titles_writing_mechanics = [[NSMutableArray alloc] initWithObjects:
                                @"Student uses appropriate capitalization.",
                                @"Student uses appropriate punctuation.",
                                @"Student writes in complete sentences using appropriate subject-verb agreement.",
                                @"Student uses appropriate grammar.",
                                @"Student spells grade level frequency words correctly.", nil];

    titles_writing_organization = [[NSMutableArray alloc] initWithObjects:
                                   @"Student begins writing pieces and paragraphs with a hook sentence.",
                                   @"Student uses details to support ideas.",
                                   @"Student uses conclusion sentences to wrap up ideas.",
                                   @"Student organizes ideas in paragraphs.",
                                   @"Student uses details to enhance writing.",
                                   @"Student uses appropriate transitions in writing pieces.",
                                   @"Student uses grade level or above word choice.", nil];

    titles_writing_process = [[NSMutableArray alloc] initWithObjects:
                              @"Student uses a planning sheet/ organizer for prewriting.",
                              @"Student writes a rough draft independently.",
                              @"Student writes a final copy using revisions.",
                              @"Student knows and follows the writing process.", nil];

} /* viewDidLoad */


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} /* didReceiveMemoryWarning */


- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)sect {
    NSString *sectionName;
    switch (sect) {
        case 0 :
            sectionName = NSLocalizedString(@"Writing Mechanics", nil);
            break;
        case 1 :
            sectionName = NSLocalizedString(@"Writing Organization", nil);
            break;
        case 2 :
            sectionName = NSLocalizedString(@"Writing Process", nil);
            break;
        default :
            sectionName = @"";
            break;
    } /* switch */
    return sectionName;
} /* tableView */


- (CGFloat) tableView :(UITableView *)tableView heightForRowAtIndexPath :(NSIndexPath *)indexPath {
    return 60.0f;
} /* tableView */


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    return 3;
} /* numberOfSectionsInTableView */


- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)sect {
    if (sect == 0)
        return titles_writing_mechanics.count;
    else if (sect == 1)
        return titles_writing_organization.count;
    else
        return titles_writing_process.count;
} /* tableView */


- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat:@"_Cell_%d_%d", indexPath.row, indexPath.section];
    NSString *CellIdentifier3 = [NSString stringWithFormat:@"_Cell_%d_%d_%d", indexPath.row, indexPath.section, indexPath.section];

    UITableViewCell *cell = nil;

    // Configure the cell...
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [self getCellContentView:CellIdentifier :indexPath.row:indexPath];

        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:indexPath.row];
        mainContentLabel.text = [titles_writing_mechanics objectAtIndex:indexPath.row];

    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil)
            cell = [self getCellContentView:CellIdentifier2 :50 + indexPath.row:indexPath];

        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:50 + indexPath.row];
        mainContentLabel.text = [titles_writing_organization objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil)
            cell = [self getCellContentView:CellIdentifier2 :150 + indexPath.row:indexPath];

        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:150 + indexPath.row];
        mainContentLabel.text = [titles_writing_process objectAtIndex:indexPath.row];
    }

    if ((indexPath.row == 0) && (indexPath.section == 0)) {
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.5f];
        if (indexPath.section == 0)
            cell.textLabel.text = [NSString stringWithFormat:@"                               %@",
                                   [titles_writing_mechanics objectAtIndex:indexPath.row]];
        else
            cell.textLabel.text = [NSString stringWithFormat:@"                               %@",
                                   [titles_writing_organization objectAtIndex:indexPath.row]];
    }
    return cell;
} /* tableView */


- (BOOL) textFieldShouldReturn :(UITextField *)textField {
    return YES;
} /* textFieldShouldReturn */

///////////////////////////////////////////////////////////////////
// Method: compareViewsByOrigin
// Paramaters: 2 objects
// Notes: Compares two views and returns Ordering
///////////////////////////////////////////////////////////////////
NSInteger static compareViewsByOrigin(id sp1, id sp2, void *context)
{
    // UISegmentedControl segments use UISegment objects (private API).
    // But we can safely cast them to UIView objects.
    float v1 = ((UIView *)sp1).frame.origin.x;
    float v2 = ((UIView *)sp2).frame.origin.x;
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
///////////////////////////////////////////////////////////////////
// Method: segmentChanged
// Paramaters: --
// Notes: Changes Segment Color on Change
///////////////////////////////////////////////////////////////////
- (void) segmentChanged :(id)sender {
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    // Get number of segments
    int numSegments = [seg.subviews count];
    
    // Reset segment's color (non selected color)
    for( int i = 0; i < numSegments; i++ ) {
        // reset color
        [[seg.subviews objectAtIndex:i] setTintColor:nil];
        [[seg.subviews objectAtIndex:i] setTintColor:[UIColor colorWithRed:(120 / 255.0) green:(135 / 255.0) blue:(150 / 255.0) alpha:1.0]];
    }
    
    // Sort segments from left to right
    NSArray *sortedViews = [seg.subviews sortedArrayUsingFunction:compareViewsByOrigin context:NULL];
    
    UIColor *tint = [UIColor colorWithRed:(247.0f / 255.0f) green:(208.0f / 255.0f) blue:(44.0f / 255.0f) alpha:0.8f];
    
    if (seg.selectedSegmentIndex == 1)
        tint = [UIColor colorWithRed:(1.0f / 255.0f) green:(194.0f / 255.0f) blue:(223.0f / 255.0f) alpha:0.8f];
    else if (seg.selectedSegmentIndex == 2)
        tint = [UIColor colorWithRed:(93.0f / 255.0f) green:(194.0f / 255.0f) blue:(93.0f / 255.0f) alpha:0.8f];
    
    // Change color of selected segment
    [[sortedViews objectAtIndex:seg.selectedSegmentIndex] setTintColor:tint];
    
    // Remove all original segments from the control
    for (id view in seg.subviews) {
        [view removeFromSuperview];
    }
    
    // Append sorted and colored segments to the control
    for (id view in sortedViews) {
        [seg addSubview:view];
    }
    
} /* segmentChanged */

- (UITableViewCell *) getCellContentView :(NSString *)cellIdentifier :(int)headtag :(NSIndexPath *)ip {

    CGRect CellFrame = CGRectMake(0, 0, 300, 60);

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];

    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(135, 9, 350, 45)];
    formTitleField.textColor = [UIColor darkGrayColor];
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentLeft;
    formTitleField.numberOfLines = 0;
    formTitleField.font = [UIFont fontWithName:@"HelveticaNeue" size:14.5f];
    formTitleField.tag = headtag;
    [cell.contentView addSubview:formTitleField];

    NSString *currentSegment = [[[[[[self.studentObjectData objectAtIndex:ip.section] objectAtIndex:ip.row]
                                   componentsSeparatedByString:kContent_Delimiter] mutableCopy] objectAtIndex:0] uppercaseString];

    NSArray *itemArray = [NSArray arrayWithObjects:@"B", @"D", @"S", nil];
    cellSegmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    cellSegmentedControl.tintColor = [UIColor colorWithRed:(120 / 255.0) green:(135 / 255.0) blue:(150 / 255.0) alpha:1.0];

    if (ip.section == 0)
        cellSegmentedControl.tag = FIRST_INDEX_KEY + ip.row;
    else if (ip.section == 1)
        cellSegmentedControl.tag = SECOND_INDEX_KEY + ip.row;
    else if (ip.section == 2)
        cellSegmentedControl.tag = THIRD_INDEX_KEY + ip.row;

    [cellSegmentedControl addTarget:self action:@selector(cellSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [cellSegmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    cellSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    cellSegmentedControl.frame = CGRectMake(10, 16, 100, 30);
    [cell.contentView addSubview:cellSegmentedControl];

    int selected = -1;
    
    if ([currentSegment isEqualToString:@"D"])
        selected = 1;
    else if ([currentSegment isEqualToString:@"S"])
        selected = 2;
    else
        selected = 0;
    
    [cellSegmentedControl setTag:kSegmentControlTagFirst
               forSegmentAtIndex:selected
                   forSegmentTag:cellSegmentedControl.tag];
    
    switch (selected) {
        case 0 :
            [cellSegmentedControl setTintColor:[UIColor colorWithRed:(247.0f / 255.0f) green:(208.0f / 255.0f) blue:(44.0f / 255.0f) alpha:0.8f]
                                        forTag:kSegmentControlTagFirst
                                 forSegmentTag:cellSegmentedControl.tag];
            break;
        case 1 :
            [cellSegmentedControl setTintColor:[UIColor colorWithRed:(1.0f / 255.0f) green:(194.0f / 255.0f) blue:(223.0f / 255.0f) alpha:0.8f]
                                        forTag:kSegmentControlTagFirst
                                 forSegmentTag:cellSegmentedControl.tag];
            break;
        case 2 :
            [cellSegmentedControl setTintColor:[UIColor colorWithRed:(93.0f / 255.0f) green:(194.0f / 255.0f) blue:(93.0f / 255.0f) alpha:0.8f]
                                        forTag:kSegmentControlTagFirst
                                 forSegmentTag:cellSegmentedControl.tag];
            break;
        default :
            break;
    } /* switch */
    
    cellSegmentedControl.selectedSegmentIndex = selected;
    
    currentText = [[[[[self.studentObjectData objectAtIndex:ip.section] objectAtIndex:ip.row]
                     componentsSeparatedByString:kContent_Delimiter] mutableCopy] objectAtIndex:1];

    if (![currentText isEqualToString:@"nil"]) {
        UIImageView *contentStatus = [[UIImageView alloc] initWithFrame:CGRectMake(-30, 14, 18, 18)];
        contentStatus.image = [UIImage imageNamed:@"check"];
        [cell.contentView addSubview:contentStatus];
    }

    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    return cell;
} /* getCellContentView */


- (void) cellSegmentedControlAction :(id)sender {
    UISegmentedControl *control = sender;

    int s = 0, r = 0;

    if (control.tag < SECOND_INDEX_KEY) {
        s = FIRST_INDEX_KEY;
        r = control.tag;
    } else if ((control.tag >= SECOND_INDEX_KEY) && (control.tag < THIRD_INDEX_KEY)) {
        s = 1;
        r = control.tag - SECOND_INDEX_KEY;
    } else if (control.tag >= THIRD_INDEX_KEY ) {
        s = 2;
        r = control.tag - THIRD_INDEX_KEY;
    }

    NSString *cellContentText = [[[[[self.studentObjectData objectAtIndex:s] objectAtIndex:r]
                                   componentsSeparatedByString:kContent_Delimiter] mutableCopy] objectAtIndex:1];

    NSArray *itemArray = [NSArray arrayWithObjects:@"B", @"D", @"S", nil];

    NSString *formattedInsertStringData = [NSString stringWithFormat:@"%@%@%@", [itemArray objectAtIndex:[control selectedSegmentIndex]], kContent_Delimiter, cellContentText];
    [WritingAssessmentModel insertDataIntoClassDatabase:[student uid] section:s row:r text:formattedInsertStringData];
    self.studentObjectData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel retrieveStudentDataFromDatabase:[student uid]] copyItems:YES];

    [self.tableView reloadData];
} /* cellSegmentedControlAction */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sect
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 500, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, view.bounds.size.width, view.bounds.size.height)];
    label.text = [self tableView:tableView titleForHeaderInSection:sect];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.textColor = [UIColor colorWithWhite:.95f alpha:1.0f];
    
    [view addSubview:label];
    
    return view;
}

- (void) insertStringIntoDatabase :(id)sender {

    NSString *currentSegment = [[[[[[self.studentObjectData objectAtIndex:section] objectAtIndex:row]
                                   componentsSeparatedByString:kContent_Delimiter] mutableCopy] objectAtIndex:0] uppercaseString];

    NSString *formattedInsertStringData = [NSString stringWithFormat:@"%@%@%@", currentSegment, kContent_Delimiter, modalTextView.text];

    [WritingAssessmentModel insertDataIntoClassDatabase:[student uid] section:section row:row text:formattedInsertStringData];
    self.studentObjectData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel retrieveStudentDataFromDatabase:[student uid]] copyItems:YES];

    if (![oldText isEqualToString:modalTextView.text]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
        
        UIImageView *contentStatus = [[UIImageView alloc] initWithFrame:CGRectMake(-30, 21, 18, 18)];
        contentStatus.image = [UIImage imageNamed:@"check"];
        [cell.contentView addSubview:contentStatus];
    }

    [self.tableView reloadData];

    [self dismissModalViewControllerAnimated:YES];
} /* insertStringIntoDatabase */


- (void) cancel :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* cancel */


- (void) pushModalView :(NSIndexPath *)indexPath {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(insertStringIntoDatabase:)];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    NSString *currentTextData = [[[[[self.studentObjectData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
                                   componentsSeparatedByString:kContent_Delimiter] mutableCopy] objectAtIndex:1];

    modalTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 495, 535)];

    if (![currentTextData isEqualToString:@"nil"])
        modalTextView.text = currentTextData;
    else
        modalTextView.text = @"";

    oldText = modalTextView.text;
    modalTextView.contentInset = UIEdgeInsetsMake(12, 10, 0, 0);
    modalTextView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    modalTextView.textColor = [UIColor darkGrayColor];
    modalTextView.layer.cornerRadius = 4.0f;
    [vc.view addSubview:modalTextView];

    if (indexPath.section == 0)
        vc.title = [titles_writing_mechanics objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        vc.title = [titles_writing_organization objectAtIndex:indexPath.row];
    else
        vc.title = [titles_writing_process objectAtIndex:indexPath.row];

    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
} /* pushModalView */


#pragma mark - Table view delegate

- (void) tableView :(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    section = indexPath.section;
    row = indexPath.row;

    [self pushModalView:indexPath];
} /* tableView */


@end
