//
//  ReadingAssesmentViewController
//  Bobcats
//
//  Created by Burchfield, Neil on 1/29/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "AppDelegate.h"

@interface WritingAssesmentViewController : UITableViewController <UITextFieldDelegate> {

    NSMutableArray *titles_writing_mechanics;
    NSMutableArray *titles_writing_organization;
    NSMutableArray *titles_writing_process;
    Student *student;
    AppDelegate *appDelegate;
    UITextView *modalTextView;
    NSString *oldText;
    UISegmentedControl *cellSegmentedControl;
    NSString *currentText;
    int section;
    int row;
}

@property (nonatomic, retain) NSMutableArray *studentObjectData;

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st;

@end