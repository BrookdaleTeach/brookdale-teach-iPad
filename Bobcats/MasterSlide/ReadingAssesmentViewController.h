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

@interface ReadingAssesmentViewController : UITableViewController <UITextFieldDelegate> {

    NSMutableArray *titles_reading_strategies;
    NSMutableArray *titles_reading_decoding;
    NSMutableArray *titles_reading_fluency;

    Student *student;
    AppDelegate *appDelegate;

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
