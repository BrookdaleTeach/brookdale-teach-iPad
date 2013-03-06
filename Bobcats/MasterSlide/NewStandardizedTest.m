//
//  NewStandardizedTest.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/18/13.
//
//

#import "NewStandardizedTest.h"
#import "MathAssessmentModel.h"

#import "MathAssessmentModel.h"
#import "ReadingAssessmentModel.h"
#import "WritingAssessmentModel.h"
#import "BehavioralAssessmentModel.h"

#import "MathTestTableViewController.h"
#import "ReadingTestTableViewController.h"
#import "WritingTestTableViewController.h"
#import "BehavioralTestTableViewController.h"

@interface NewStandardizedTest ()

@end

@implementation NewStandardizedTest


- (id) initWithStyle :(UITableViewStyle)style :(Student *)st :(int)ck :(int)mode :(NSIndexPath *)index {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        classKey = ck;
        classes = [[NSMutableArray alloc] initWithObjects:@"Math", @"Reading", @"Writing", @"Behavioral", nil];
        self.title = [NSString stringWithFormat:@"New %@ Standardized Assessment", [classes objectAtIndex:classKey - 1]];
        student = st;
        editingMode = mode;
        ip = index;
    }
    return self;
} /* initWithStyle */


- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    titles = [[NSMutableArray alloc] initWithObjects:@"Name", @"Test Score", @"Date", nil];
    titleKeys = [[NSMutableArray alloc] initWithObjects:@"name", @"score", @"date", nil];
    
    if (editingMode == kEditingMode_EntityExists) {
        existingColumnData = [[NSArray alloc] initWithArray:[self existingDataForColumn]];
        preExistingDict = [[NSMutableDictionary alloc] init];
    }
} /* viewDidLoad */

- (NSArray *) existingDataForColumn
{
    NSArray *contentData = nil;
    switch (classKey) {
        case kMath_Key:
            contentData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        case kReading_Key:
            contentData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        case kWriting_Key:
            contentData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;
        case kBehavioral_Key:
            contentData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel selectStandardizedDataIntoClassDatabase:[student uid]]];
            break;   
        default:
            break;
    }
    
    return contentData;
}

- (void) cancel :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* cancel */

- (void) done :(id)sender {
    [self dismissModalViewControllerAnimated:YES];

    BOOL textfieldNull = NO;

    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];

    for (int x = 0; x < titles.count; x++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:100 + x];

        if (textField.text != nil) {
            [dataDictionary setObject:textField.text forKey:[titleKeys objectAtIndex:x]];
            NSLog(@"dataDictionary: %@", textField.text);
        } else {
            textfieldNull = YES;
            break;
        }
    }

    if (!textfieldNull) {
        switch (classKey) {
            case 1 :
                if (editingMode == kEditingMode_EntityExists)
                    [MathAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kStandardized_Key];
                else
                    [MathAssessmentModel insertStandardizedDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMathTestTableView" object:nil];
                break;
            case 2 :
                if (editingMode == kEditingMode_EntityExists)
                    [ReadingAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kStandardized_Key];
                else
                    [ReadingAssessmentModel insertStandardizedDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadReadingTestTableView" object:nil];
                break;
            case 3 :
                if (editingMode == kEditingMode_EntityExists)
                    [WritingAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kStandardized_Key];
                else
                    [WritingAssessmentModel insertStandardizedDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadWritingTestTableView" object:nil];
                break;
            case 4 :
                if (editingMode == kEditingMode_EntityExists)
                    [BehavioralAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kStandardized_Key];
                else
                    [BehavioralAssessmentModel insertStandardizedDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBehavioralTestTableView" object:nil];
                break;
            default :
                break;
        } /* switch */
    } else {
        UIAlertView *alertNullField = [[UIAlertView alloc] initWithTitle:@"Blank Field"
                                                                 message:@"All Fields Are Required"
                                                                delegate:self.view
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
        [alertNullField show];
    }
} /* done */

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    // Return the number of sections.
    return titles.count;
} /* numberOfSectionsInTableView */


- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
} /* tableView */


- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {
    return @"";
} /* tableView */


- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSString *value = @"";
        if (editingMode == kEditingMode_EntityExists)
        {
            NSMutableArray *parsedData = [[NSMutableArray alloc] initWithArray:[[[existingColumnData objectAtIndex:ip.row] componentsSeparatedByString:@"/"] mutableCopy] copyItems:YES];
            value = [parsedData objectAtIndex:indexPath.section];
            [preExistingDict setObject:value forKey:[titleKeys objectAtIndex:indexPath.section]];
            NSLog(@"value: %@ key: %@", value, [titleKeys objectAtIndex:indexPath.section]);
        }
            
        cell = [self getCellContentViewWithTextfield:CellIdentifier
                                                    :[titles objectAtIndex:indexPath.section]
                                                    :100 + indexPath.section
                                                    :value];
    }

    // Configure the cell...

    return cell;
} /* tableView */


// RootViewController.m
- (UITableViewCell *) getCellContentViewWithTextfield :(NSString *)cellIdentifier :(NSString *)text :(int)tag :(NSString *)value {

    CGRect CellFrame = CGRectMake(0, 0, 300, 60);

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];

    cell.accessoryType = UITableViewCellAccessoryNone;

    UITextField *formEntryField = [[UITextField alloc] initWithFrame:CGRectMake(200, 14, 230, 30)];
    formEntryField.adjustsFontSizeToFitWidth = YES;
    formEntryField.textColor = [UIColor blackColor];
    formEntryField.font = [UIFont systemFontOfSize:14.0f];
    formEntryField.keyboardType = UIKeyboardTypeDefault;
    formEntryField.returnKeyType = UIReturnKeyNext;
    formEntryField.backgroundColor = [UIColor clearColor];
    formEntryField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    formEntryField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    formEntryField.textAlignment = NSTextAlignmentLeft;
    formEntryField.tag = tag;
    formEntryField.text = value;
    formEntryField.delegate = self;
    formEntryField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [formEntryField setEnabled:YES];

    if (tag == 102) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.tag = 123;
        formEntryField.inputView = datePicker;
    }

    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(6, 12, 116, 20)];
    formTitleField.textColor = [UIColor darkGrayColor];
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentRight;
    formTitleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    formTitleField.text = text;
    [cell.contentView addSubview:formTitleField];

    [cell addSubview:formEntryField];

    UILabel *vLine = [[UILabel alloc] initWithFrame:CGRectMake(132, 1, 1, cell.frame.size.height - 18)];
    vLine.backgroundColor = [UIColor colorWithRed:173.0f / 255.0f green:175.0f / 255.0f blue:179.0f / 255.0f alpha:.7f];
    [cell.contentView addSubview:vLine];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
} /* getCellContentViewWithTextfield */


- (void) datePickerValueChanged :(id)sender {
    // Use NSDateFormatter to write out the date in a friendly format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    datePickerValue = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];

    UITextField *textField = (UITextField *)[self.view viewWithTag:102];
    textField.text = datePickerValue;
} /* datePickerValueChanged */


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
} /* tableView */


@end
