//
//  DetailViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"
#import "MGScrollView.h"

@class AppDelegate;

@interface DetailViewController : UIViewController {

    NSArray *tableViewHeaders;
    NSMutableArray *tableViewContent;
    AppDelegate *appDelegate;

    UIView *shelfView;
    Student *student;
    UIImageView *studentImageView;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *uidLabel;
    NSString *nextView;
    UIImageView *ribbon;
}

@property (nonatomic, strong) MGScrollView *scroller;

- (void) loadContentDataView :(int)section :(int)row;

@end
