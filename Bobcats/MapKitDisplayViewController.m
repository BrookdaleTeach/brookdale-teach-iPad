//
//  MapKitDisplayViewController.m
//  Bobcats
//

#import "MapKitDisplayViewController.h"
#import "MapSubtitle.h"

@implementation MapKitDisplayViewController

@synthesize mapView;
@synthesize typeSheet = _typeSheet;

- (id) initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil student :(Student *)s {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

        [mapView setDelegate:self];
        student = s;
    }
    return self;
} /* initWithNibName */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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

    self.typeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Standard", @"Hybrid", @"Satellite", nil];

    [self forwardGeolocateAddress];
} /* viewDidLoad */


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


- (void) typeActionSheetAction :(id)sender {
    [self.typeSheet showFromBarButtonItem:sender animated:YES];
} /* typeActionSheetAction */


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
                 NSLog(@"%@", [placemark location]);

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


- (MKAnnotationView *) mapView :(MKMapView *)mV viewForAnnotation :(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    return pinView;
} /* mapView */


// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
} /* shouldAutorotateToInterfaceOrientation */


- (void) viewDidDisappear :(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.navigationController removeFromParentViewController];
} /* viewDidDisappear */


- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
} /* didReceiveMemoryWarning */


- (void) viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} /* viewDidUnload */


@end
