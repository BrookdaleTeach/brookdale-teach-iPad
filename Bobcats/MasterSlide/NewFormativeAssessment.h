//
//  NewFormativeAssessment.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface NewFormativeAssessment : UITableViewController <UITextFieldDelegate> {

    NSArray *classes;
    NSMutableArray *titles;
    NSMutableArray *titleKeys;
    Student *student;
    int classKey;

    UIDatePicker *datePicker;
    NSString *datePickerValue;
    
    NSArray *existingColumnData;
    
    NSIndexPath *ip;
    
    NSMutableDictionary *preExistingDict;
}

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st :(int)ck :(int)mode :(NSIndexPath *)index;

@end
