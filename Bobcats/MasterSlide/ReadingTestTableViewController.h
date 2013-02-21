//
//  ReadingTestTableViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/19/13.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface ReadingTestTableViewController : UITableViewController {

    Student *student;
    NSMutableArray *standardizedTests;
    NSMutableArray *formativeAssessments;

}

- (id) initWithStyle :(UITableViewStyle)style :(Student *)st;
- (void) reloadData :(NSNotification *)notif;

@end