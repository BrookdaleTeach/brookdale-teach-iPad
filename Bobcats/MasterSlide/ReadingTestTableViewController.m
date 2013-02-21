//
//  ReadingTestTableViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/19/13.
//
//

#import "ReadingTestTableViewController.h"
#import "NewFormativeAssessment.h"
#import "NewStandardizedTest.h"
#import "ReadingAssessmentModel.h"

@implementation ReadingTestTableViewController

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Reading Standardized Tests/Formative Assessments", nil);
        student = st;
    }
    return self;
} /* initWithStyle */


- (void) viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    standardizedTests = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
    formativeAssessments = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"ReloadReadingTestTableView"
                                               object:nil];
} /* viewDidLoad */


- (void) reloadData :(NSNotification *)notif {

    [standardizedTests removeAllObjects];
    [formativeAssessments removeAllObjects];

    standardizedTests = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
    formativeAssessments = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];

    [self.tableView reloadData];
} /* reloadData */


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} /* didReceiveMemoryWarning */


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    // Return the number of sections.
    return 2;
} /* numberOfSectionsInTableView */


- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
        return standardizedTests.count + 1;
    else if (section == 1)
        return formativeAssessments.count + 1;

    return 0;
} /* tableView */


- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0 :
            sectionName = NSLocalizedString(@"Standardized Tests", nil);
            break;
        case 1 :
            sectionName = NSLocalizedString(@"Formative Assessments", nil);
            break;
        default :
            sectionName = @"";
            break;
    } /* switch */
    return sectionName;
} /* tableView */


- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    }

    UIImageView *greenAddView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 24, 24)];
    [greenAddView setImage:[UIImage imageNamed:@"greenAdd.png"]];

    if (indexPath.section == 0) {
        if (indexPath.row == standardizedTests.count) {
            cell.textLabel.text = @"New Standardized Assessment";
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.accessoryView = greenAddView;
        } else {
            NSMutableArray *parsedStandard = [[NSMutableArray alloc] initWithArray:[[[standardizedTests objectAtIndex:indexPath.row] componentsSeparatedByString:@"/"] mutableCopy] copyItems:YES];

            cell.textLabel.text = [parsedStandard objectAtIndex:0];
            cell.detailTextLabel.text = [parsedStandard objectAtIndex:2];

            UILabel *accessoryText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
            [accessoryText setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [accessoryText setTextAlignment:NSTextAlignmentRight];
            [accessoryText setBackgroundColor:[UIColor clearColor]];
            [accessoryText setText:[parsedStandard objectAtIndex:1]];
            cell.accessoryView = accessoryText;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == formativeAssessments.count) {
            cell.textLabel.text = @"New Formative Assessment";
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.accessoryView = greenAddView;
        } else {
            NSMutableArray *parsedFormative = [[NSMutableArray alloc] initWithArray:[[[formativeAssessments objectAtIndex:indexPath.row] componentsSeparatedByString:@"/"] mutableCopy] copyItems:YES];

            cell.textLabel.text = [parsedFormative objectAtIndex:0];
            cell.detailTextLabel.text = [parsedFormative objectAtIndex:2];

            UILabel *accessoryText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
            [accessoryText setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [accessoryText setTextAlignment:NSTextAlignmentRight];
            [accessoryText setBackgroundColor:[UIColor clearColor]];
            [accessoryText setText:[parsedFormative objectAtIndex:1]];
            cell.accessoryView = accessoryText;
        }
    }

    // Configure the cell...

    return cell;
} /* tableView */


/*
   // Override to support conditional editing of the table view.
   - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
   {
   // Return NO if you do not want the specified item to be editable.
   return YES;
   }
 */

/*
   // Override to support editing the table view.
   - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
   {
   if (editingStyle == UITableViewCellEditingStyleDelete) {
   // Delete the row from the data source
   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   }
   else if (editingStyle == UITableViewCellEditingStyleInsert) {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
 */

/*
   // Override to support rearranging the table view.
   - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
   {
   }
 */

/*
   // Override to support conditional rearranging of the table view.
   - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
   {
   // Return NO if you do not want the item to be re-orderable.
   return YES;
   }
 */

#pragma mark - Table view delegate

- (void) tableView :(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
       <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
       // ...
       // Pass the selected object to the new view controller.
       [self.navigationController pushViewController:detailViewController animated:YES];
       [detailViewController release];
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ((indexPath.row == standardizedTests.count) && (indexPath.section == 0)) {
        NewStandardizedTest *nst = [[NewStandardizedTest alloc] initWithStyle:UITableViewStyleGrouped :student :2];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nst];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:navController animated:YES];
    } else if ((indexPath.row == formativeAssessments.count) && (indexPath.section == 1)) {
        NewFormativeAssessment *nfa = [[NewFormativeAssessment alloc] initWithStyle:UITableViewStyleGrouped :student :2];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nfa];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:navController animated:YES];
    }

} /* tableView */


@end

