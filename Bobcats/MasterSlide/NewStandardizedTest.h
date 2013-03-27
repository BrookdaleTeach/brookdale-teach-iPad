//
//  NewStandardizedTest.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/18/13.
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import "Student.h"

/*
 * Class Main Interface
 */

@interface NewStandardizedTest : UITableViewController <UITextFieldDelegate> {

    /* Local Declarations */

    NSMutableArray *titles;
    NSMutableArray *titleKeys;
    Student *student;
    NSArray *classes;
    UIDatePicker *datePicker;
    NSString *datePickerValue;
    NSArray *existingColumnData;
    NSIndexPath *ip;
    NSMutableDictionary *preExistingDict;
    int classKey;
    int editingMode;
}

/* Global Method Declarations */

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st :(int)ck :(int)mode :(NSIndexPath *)index;

@end
