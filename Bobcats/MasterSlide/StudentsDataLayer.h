//
//  StudentsDataLayer.h
//  Bobcats
//
//  Created by Burchfield, Neil on 3/27/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Student.h"
#import "ClassDefinitions.h"

@interface StudentsDataLayer : NSObject
+ (void)insertStudentDataIntoClassDatabaseColumn:(NSString *)column withStudent:(NSString *)uid withText:(NSString *)text;
+ (NSString *)retrieveStudentDataFromClassDatabaseColumn:(NSString *)column withStudent:(NSString *)uid;
@end
