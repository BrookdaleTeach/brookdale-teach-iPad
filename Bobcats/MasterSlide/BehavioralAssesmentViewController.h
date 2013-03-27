//
//  BehavioralAssesmentViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/13/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface BehavioralAssesmentViewController : UITableViewController {

    NSMutableArray *titles_behavioral_attendance;
    NSMutableArray *titles_behavioral_respect;
    NSMutableArray *titles_behavioral_responsibility;
    NSMutableArray *titles_behavioral_feelings;
    Student *student;
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
