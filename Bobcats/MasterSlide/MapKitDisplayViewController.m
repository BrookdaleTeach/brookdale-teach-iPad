//
//  MapKitDisplayViewController.m
//  Bobcats
//

/* Imports */

#import "MapKitDisplayViewController.h"
#import "MapSubtitle.h"

/*
 * Class Main Implementation
 */
@implementation MapKitDisplayViewController

/* Sythesizations */

@synthesize mapView;
@synthesize typeSheet = _typeSheet;

/*
   InitWithNibName
   --------
   Purpose:        Initilizes Class with Views
   Parameters:     nib, Student
   Returns:        self
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil student :(Student *)s {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        [mapView setDelegate:self];
        student = s;
    }
    return self;
} /* initWithNibName */


/*
   viewDidLoad
   --------
   Purpose:        Setup View
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewDidLoad {
    [super viewDidLoad];

    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];

    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Map Type"
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(typeActionSheetAction:)];

    self.navigationItem.rightBarButtonItem = typeButton;

    self.typeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                        cancelButtonTitle:nil destructiveButtonTitle:nil
                                        otherButtonTitles:@"Standard", @"Hybrid", @"Satellite", nil];

    [self forwardGeolocateAddress];
} /* viewDidLoad */


/*
   didDismissWithButtonIndex
   --------
   Purpose:        Action Sheet Delegate
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) actionSheet :(UIActionSheet *)actionSheet didDismissWithButtonIndex :(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0 :
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1 :
            mapView.mapType = MKMapTypeHybrid;
            break;
        case 2 :
            mapView.mapType = MKMapTypeSatellite;
            break;
        default :
            break;
    } /* switch */
} /* actionSheet */


/*
   typeActionSheetAction
   --------
   Purpose:        Show Actionsheet
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) typeActionSheetAction :(id)sender {
    [self.typeSheet showFromBarButtonItem:sender animated:YES];
} /* typeActionSheetAction */


/*
   forwardGeolocateAddress
   --------
   Purpose:        Forward Geolocation
   Parameters:     --
   Returns:        BOOL
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) forwardGeolocateAddress {
    __block BOOL didGeolocate = NO;

    // Create a new GLGeocoder object
    CLGeocoder *userLocation = [[CLGeocoder alloc] init];
    [userLocation geocodeAddressString:[student address]
                     completionHandler: ^(NSArray *placemarks, NSError *error){

         // Make sure the geocoder did not produce an error
         // before coninuing
         if (!error) {

             // Iterate through all of the placemarks returned
             // and output them to the console
             for (CLPlacemark * placemark in placemarks) {
                 MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };

                 region.center.latitude = placemark.region.center.latitude;
                 region.center.longitude = placemark.region.center.longitude;

                 region.span.longitudeDelta = 0.01f;
                 region.span.latitudeDelta = 0.01f;

                 [mapView setRegion:region animated:YES];

                 MapSubtitle *ann = [[MapSubtitle alloc] init];
                 ann.title = [NSString stringWithFormat:@"%@ %@", [student firstName], [student lastName]];
                 ann.subtitle = [student address];
                 ann.coordinate = region.center;
                 [mapView addAnnotation:ann];

                 [[mapView viewForAnnotation:ann] setHidden:NO];

                 didGeolocate = YES;
             }
         } else {
             // Our geocoder had an error, output a message
             // to the console
             NSLog(@"There was a forward geocoding error\n%@",
                   [error localizedDescription]);
         }
     }


    ];

    return didGeolocate;
} /* forwardGeolocateAddress */


/*
   viewForAnnotation
   --------
   Purpose:        Annotation view
   Parameters:     MKAnnotation, MKMapView
   Returns:        MKAnnotationView
   Notes:          --
   Author:         Neil Burchfield
 */
- (MKAnnotationView *) mapView :(MKMapView *)mV viewForAnnotation :(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    return pinView;
} /* mapView */


/*
   shouldAutorotateToInterfaceOrientation
   --------
   Purpose:        Portrait Orientation Support
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
} /* shouldAutorotateToInterfaceOrientation */


/*
   viewDidDisappear
   --------
   Purpose:        Remove from Parent
   Parameters:     --
   Returns:        --
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewDidDisappear :(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController removeFromParentViewController];
} /* viewDidDisappear */


@end
