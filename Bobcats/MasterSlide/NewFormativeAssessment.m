//
//  NewFormativeAssessment.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/18/13.
//
//

/* Imports */

#import "NewFormativeAssessment.h"
#import "MathAssessmentModel.h"
#import "ReadingAssessmentModel.h"
#import "WritingAssessmentModel.h"
#import "BehavioralAssessmentModel.h"
#import "MathTestTableViewController.h"
#import "ReadingTestTableViewController.h"
#import "WritingTestTableViewController.h"
#import "BehavioralTestTableViewController.h"

/* Definitions */

#define kTextfieldTagIterator 2041
#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 2

/*
 * Class Main Implementation
 */

@implementation NewFormativeAssessment

/*
   initWithStyle
   --------
   Purpose:        Initilizes Tableview
   Parameters:     UITableViewStyle, Student, int, int, NSIndexPath
   Returns:        self
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) initWithStyle :(UITableViewStyle)style :(Student *)st :(int)ck :(int)mode :(NSIndexPath *)index {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        classKey = ck;
        classes = [[NSMutableArray alloc] initWithObjects:@"Math", @"Reading", @"Writing", @"Behavioral", nil];
        self.title = [NSString stringWithFormat:@"New %@ Formative Assessment", [classes objectAtIndex:classKey - 1]];
        student = st;
        editingMode = mode;
        ip = index;
    }
    return self;
} /* initWithStyle */


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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    titles = [[NSMutableArray alloc] initWithObjects:@"Name", @"Test Score", @"Date", nil];
    titleKeys = [[NSMutableArray alloc] initWithObjects:@"name", @"score", @"date", nil];

    if (editingMode == kEditingMode_EntityExists) {
        existingColumnData = [[NSArray alloc] initWithArray:[self existingDataForColumn]];
        preExistingDict = [[NSMutableDictionary alloc] init];
    }
} /* viewDidLoad */


/*
   existingDataForColumn
   --------
   Purpose:        Retrieves Existing Content
   Parameters:     --
   Returns:        NSArray
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSArray *) existingDataForColumn {
    NSArray *contentData = nil;
    switch (classKey) {
        case kMath_Key :
            contentData = [[NSMutableArray alloc] initWithArray:[MathAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            break;
        case kReading_Key :
            contentData = [[NSMutableArray alloc] initWithArray:[ReadingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            break;
        case kWriting_Key :
            contentData = [[NSMutableArray alloc] initWithArray:[WritingAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            break;
        case kBehavioral_Key :
            contentData = [[NSMutableArray alloc] initWithArray:[BehavioralAssessmentModel selectFormativeDataIntoClassDatabase:[student uid]]];
            break;
        default :
            break;
    } /* switch */

    return contentData;
} /* existingDataForColumn */


/*
   cancel
   --------
   Purpose:        Dismiss Modal
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) cancel :(id)sender {
    [self dismissModalViewControllerAnimated:YES];
} /* cancel */


/*
   done
   --------
   Purpose:        Save Data
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) done :(id)sender {

    BOOL isTextFieldNull = NO;

    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];

    for (int x = 0; x < titles.count; x++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:kTextfieldTagIterator + x];
        if (textField.text != nil && ![textField.text isEqualToString:@""]) {
            [dataDictionary setObject:textField.text forKey:[titleKeys objectAtIndex:x]];
        }
        else {
            isTextFieldNull = YES;
        }
    }

    if (!isTextFieldNull) {
        switch (classKey) {
            case 1 :
                if (editingMode == kEditingMode_EntityExists)
                    [MathAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kFormative_Key];
                else
                    [MathAssessmentModel insertFormativeDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMathTestTableView" object:nil];
                break;
            case 2 :
                if (editingMode == kEditingMode_EntityExists)
                    [ReadingAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kFormative_Key];
                else
                    [ReadingAssessmentModel insertFormativeDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadReadingTestTableView" object:nil];
                break;
            case 3 :
                if (editingMode == kEditingMode_EntityExists)
                    [WritingAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kFormative_Key];
                else
                    [WritingAssessmentModel insertFormativeDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadWritingTestTableView" object:nil];
                break;
            case 4 :
                if (editingMode == kEditingMode_EntityExists)
                    [BehavioralAssessmentModel updateDataIntoClassDatabase:[student uid] :dataDictionary :preExistingDict :kFormative_Key];
                else
                    [BehavioralAssessmentModel insertFormativeDataIntoClassDatabase:[student uid] :dataDictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBehavioralTestTableView" object:nil];
                break;
            default :
                break;
        } /* switch */
        [self dismissModalViewControllerAnimated:YES];
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

/*
   numberOfSectionsInTableView
   --------
   Purpose:        Section Count
   Parameters:     UITableView
   Returns:        NSInteger
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) numberOfSectionsInTableView :(UITableView *)tableView {
    // Return the number of sections.
    return titles.count;
} /* numberOfSectionsInTableView */


/*
   numberOfRowsInSection
   --------
   Purpose:        Rows Count
   Parameters:     UITableView
   Returns:        NSInteger
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) tableView :(UITableView *)tableView numberOfRowsInSection :(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
} /* tableView */


/*
   titleForHeaderInSection
   --------
   Purpose:        Section Title
   Parameters:     UITableView, NSInteger
   Returns:        NSString
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) tableView :(UITableView *)tableView titleForHeaderInSection :(NSInteger)section {
    return @"";
} /* tableView */

/*
 cellForRowAtIndexPath
 --------
 Purpose:        Cell Content View
 Parameters:     UITableView, NSIndexPath
 Returns:        UITableViewCell
 Notes:          --
 Author:         Neil Burchfield
 */
- (UITableViewCell *) tableView :(UITableView *)tableView cellForRowAtIndexPath :(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSString *value = @"";
        if (editingMode == kEditingMode_EntityExists) {
            NSMutableArray *parsedData = [[NSMutableArray alloc] initWithArray:[[[existingColumnData objectAtIndex:ip.row] componentsSeparatedByString:@"/"] mutableCopy] copyItems:YES];
            value = [parsedData objectAtIndex:indexPath.section];
            [preExistingDict setObject:value forKey:[titleKeys objectAtIndex:indexPath.section]];
        }

        cell = [self getCellContentViewWithTextfield:CellIdentifier
                                                    :[titles objectAtIndex:indexPath.section]
                                                    :kTextfieldTagIterator + indexPath.section
                                                    :value];
    }
    return cell;
} /* tableView */


/*
   getCellContentViewWithTextfield
   --------
   Purpose:        Cell Content View
   Parameters:     NSString, NSString, NSString
   Returns:        UITableViewCell
   Notes:          --
   Author:         Neil Burchfield
 */
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
    formEntryField.delegate = self;
    formEntryField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [formEntryField setEnabled:YES];

    if (tag == kTextfieldTagIterator + 1) {
        formEntryField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (tag == kTextfieldTagIterator + 2) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.tag = 123;
        formEntryField.inputView = datePicker;
        formEntryField.text = [self dateWithFormatFromString:[NSDate date]];
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

/*
 shouldChangeCharactersInRange
 --------
 Purpose:        Numbers Only
 Parameters:     UITextField, NSRange, NSString
 Returns:        BOOL
 Notes:          --
 Author:         Neil Burchfield
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if (textField.tag == kTextfieldTagIterator + 1) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    }
    else {
        return YES;
    }
}

/*
 dateWithFormatFromString
 --------
 Purpose:        Return Current Date formatted
 Parameters:     NSDate
 Returns:        NSString
 Notes:          --
 Author:         Neil Burchfield
 */
- (NSString *) dateWithFormatFromString:(NSDate *)date {
    // Use NSDateFormatter to write out the date in a friendly format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    return [df stringFromDate:date];
} /* dateWithFormatFromString */

/*
   datePickerValueChanged
   --------
   Purpose:        Date Picker Listener
   Parameters:     id
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) datePickerValueChanged :(id)sender {
    // Use NSDateFormatter to write out the date in a friendly format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    datePickerValue = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];

    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextfieldTagIterator + 2];
    textField.text = datePickerValue;
} /* datePickerValueChanged */


@end
