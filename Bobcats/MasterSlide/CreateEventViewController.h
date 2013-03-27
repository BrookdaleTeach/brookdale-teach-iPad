//
//  CreateEventViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/25/13.
//
//

/* Imports */

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

/*
 * Class Main Interface
 */

@interface CreateEventViewController : UITableViewController <UINavigationBarDelegate, UITableViewDelegate, EKEventEditViewDelegate,
                                                              UINavigationControllerDelegate, UIActionSheetDelegate> {

    /* Local Declarations */

    EKEventViewController *detailViewController;
    EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    NSMutableArray *eventsList;
}

/* Global Declarations */

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;

/* Global Method Declarations */

- (NSArray *) fetchEventsForToday;
- (IBAction) addEvent :(id)sender;

@end