#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UIAlertViewDelegate> {
	
	DetailViewController *detailViewController;
    NSArray *headers;
    NSArray *images;
}

@property (nonatomic, strong) DetailViewController *detailViewController;

@end
