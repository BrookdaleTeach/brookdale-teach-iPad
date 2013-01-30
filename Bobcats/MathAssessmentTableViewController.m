//
//  MathAssessmentTableViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/29/13.
//
//

#import "MathAssessmentTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MathAssessmentTableViewController ()

@end

@implementation MathAssessmentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Math Observation/Anecdotal Record Checklist", nil);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titles_math_behaviors = [[NSMutableArray alloc] initWithObjects:@"Student is actively engaged during math instruction",
                             @"Student works collaboratively with other",
                             @"Students to solve problems",
                             @"Student works independently to solve problems",
                             @"Student makes conjectures and estimates",
                             @"Student uses a variety of problem solving strategies to solve open-ended problems",
                             @"Student is able to explain the steps taken to solve problems",
                             @"Student is able to present multiple solutions",
                             @"Student participates in classroom discussion",
                             @"Student completes math assignments in given time frame",
                             @"Student completes math homework in given time frame",
                             @"Student reflects on and understands his/her mathematical mistakes",nil];
    
    titles_math_skills = [[NSMutableArray alloc] initWithObjects:
                          @"Student is able to add numbers",
                          @"Student is able to subtract numbers",
                          @"Student is able to multiply numbers",
                          @"Student is able to divide numbers",
                          @"Student understands the relationship between whole numbers, fractions, decimals and percents",
                          @"Student is able to tell time",
                          @"Student is able to count money",
                          @"Student understands basic concepts of geometry (angle measurement, shapes, area, volume)",
                          @"Student understands basic concepts of measurement (standard, metric, conversions)",
                          @"Student understands basic concepts of algebra (variables, solving open number sentences)", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Mathematical Behaviors", nil);
            break;
        case 1:
            sectionName = NSLocalizedString(@"Mathematical Skills", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return titles_math_behaviors.count;
    else 
        return titles_math_skills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat:@"_Cell_%d_%d", indexPath.row, indexPath.section];
    UITableViewCell *cell;

    // Configure the cell...
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [self getCellContentViewForPassword :CellIdentifier :indexPath.row];
        
        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:indexPath.row];
        mainContentLabel.text = [titles_math_behaviors objectAtIndex:indexPath.row];

    }
    else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil)
            cell = [self getCellContentViewForPassword :CellIdentifier2 :50 + indexPath.row];
        
        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:50 + indexPath.row];
        mainContentLabel.text = [titles_math_skills objectAtIndex:indexPath.row];
    }
    
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.5f];
        if (indexPath.section == 0)
            cell.textLabel.text = [titles_math_behaviors objectAtIndex:indexPath.row];
        else
            cell.textLabel.text = [titles_math_skills objectAtIndex:indexPath.row];

    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    return YES;
}

- (UITableViewCell *) getCellContentViewForPassword:(NSString *)cellIdentifier :(int)headtag {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];
    
    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(6, 9, 350, 45)];
    formTitleField.textColor = [UIColor darkGrayColor];
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentLeft;
    formTitleField.numberOfLines = 0;
    formTitleField.font = [UIFont fontWithName:@"HelveticaNeue" size:14.5f];
    formTitleField.tag = headtag;
    [cell.contentView addSubview:formTitleField];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(365, 10, 232, 40)];
    [textView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [textView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    [textView.layer setShadowOpacity:.8f];
    [textView.layer setShadowRadius:2.1f];
//    [cell.contentView addSubview:textView];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
} /* getCellContentViewForPassword */

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)pushModalView:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancel:)];
	vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Uncompleted", @"Completed", @"Half-Completed", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.tintColor = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.frame = CGRectMake(20, 10, 495, 30);
    [vc.view addSubview:segmentedControl];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, segmentedControl.bounds.size.height + 20, segmentedControl.bounds.size.width , 515)];
    textView.layer.cornerRadius = 4.0f;
    [vc.view addSubview:textView];

    if (indexPath.section == 0)
        vc.title = [titles_math_behaviors objectAtIndex:indexPath.row];
    else
        vc.title = [titles_math_skills objectAtIndex:indexPath.row];
    
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:navController animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushModalView:indexPath];
}

@end
