//
//  PDFRenderer.h
//  Bobcats
//
//

/* Imports */

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "Student.h"

/*
 * Class Main Interface
 */

@interface PDFRenderer : NSObject

+ (void) drawPDF :(NSString *)fileName frame :(CGRect)frame columnArray :(NSMutableArray *)columns contentArray :(NSMutableArray *)content titleString :(NSString *)title student :(Student *)student testType:(int)type;

@end
