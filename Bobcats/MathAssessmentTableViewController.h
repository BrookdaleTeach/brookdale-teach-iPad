//
//  MathAssessmentTableViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 1/29/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "AppDelegate.h"

@interface MathAssessmentTableViewController : UITableViewController <UITextFieldDelegate> {

    NSMutableArray *titles_math_behaviors;
    NSMutableArray *titles_math_skills;
    Student *student;
    BOOL editModeOn;
    AppDelegate *appDelegate;
    NSIndexPath *selectedIndexPath;
    UITextView *modalTextView;
    NSString *oldText;

    int section;
    int row;

    UISegmentedControl *cellSegmentedControl;
    NSString *currentText;
}

@property (nonatomic, retain) NSMutableArray *studentObjectData;

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st;


@end
