//
//  CreateEventViewController.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/25/13.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface CreateEventViewController : UITableViewController <UINavigationBarDelegate, UITableViewDelegate,
EKEventEditViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
	EKEventViewController *detailViewController;
	EKEventStore *eventStore;
	EKCalendar *defaultCalendar;
	NSMutableArray *eventsList;
}

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;

- (NSArray *) fetchEventsForToday;
- (IBAction) addEvent:(id)sender;

@end