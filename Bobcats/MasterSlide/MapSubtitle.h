//
//  DisplayMap.h
//  Bobcats
//

/* Imports */

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

/*
 * Class Main Interface
 */

@interface MapSubtitle : NSObject <MKAnnotation> {

    /* Local Declarations */

	CLLocationCoordinate2D coordinate;
	NSString *title; 
	NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;

@end
