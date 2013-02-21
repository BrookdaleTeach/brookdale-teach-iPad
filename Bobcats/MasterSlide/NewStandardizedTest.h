//
//  NewStandardizedTest.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface NewStandardizedTest : UITableViewController <UITextFieldDelegate> {

    NSMutableArray *titles;
    NSMutableArray *titleKeys;
    Student *student;
    NSArray *classes;
    int classKey;

    UIDatePicker *datePicker;
    NSString *datePickerValue;
}

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st :(int)ck;

@end
