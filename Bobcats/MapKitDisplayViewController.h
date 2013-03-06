//
//  MapKitDisplayViewController.h
//  Bobcats
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Student.h"

@class MapSubtitle;

@interface MapKitDisplayViewController : UIViewController <UIActionSheetDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
	
	IBOutlet MKMapView *mapView;
    Student *student;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) UIActionSheet *typeSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil student:(Student *)s;

@end

