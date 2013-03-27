//
//  MapKitDisplayViewController.h
//  Bobcats
//

/* Imports */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Student.h"

/* Class Objects */

@class MapSubtitle;

/*
   Main Interface
 */
@interface MapKitDisplayViewController : UIViewController <UIActionSheetDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {

    /* Local Definitions */

    IBOutlet MKMapView *mapView;
    Student *student;
}

/* Global Definitions */

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) UIActionSheet *typeSheet;

/* Global Method Definitions */

- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil student :(Student *)s;

@end

