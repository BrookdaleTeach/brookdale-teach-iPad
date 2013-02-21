//
//  MathTestTableViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface MathTestTableViewController : UITableViewController {

    Student *student;
    NSMutableArray *standardizedTests;
    NSMutableArray *formativeAssessments;
}

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st;
- (void) reloadData :(NSNotification *)notif;

@end
