//
//  MathAssessmentModel.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import "ClassDefinitions.h"

@interface MathAssessmentModel : NSObject

@property (nonatomic, retain) NSString *databasePath;

+ (void) insertStudentDataIntoClassDatabase :(NSString *)uid;
+ (void) insertDataIntoClassDatabase :(NSString *)uid section :(int)s row :(int)r text :(NSString *)text;
+ (NSMutableArray *) retrieveStudentDataFromDatabase :(NSString *)uid;
+ (void) insertFormativeDataIntoClassDatabase :(NSString *)uid :(NSMutableDictionary *)dictionary;
+ (void) insertStandardizedDataIntoClassDatabase :(NSString *)uid :(NSMutableDictionary *)dictionary;
+ (NSMutableArray *) selectFormativeDataIntoClassDatabase :(NSString *)uid;
+ (NSMutableArray *) selectStandardizedDataIntoClassDatabase :(NSString *)uid;

@end

