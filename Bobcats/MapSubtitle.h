//
//  DisplayMap.h
//  Bobcats
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface MapSubtitle : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;

@end
