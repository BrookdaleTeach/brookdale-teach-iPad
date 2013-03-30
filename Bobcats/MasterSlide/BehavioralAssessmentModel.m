//
//  BehavioralAssessmentModel.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/14/13.
//
//

#import "BehavioralAssessmentModel.h"

@implementation BehavioralAssessmentModel

+ (NSString *) getDatabasePath {
    return kBehavioral_Database;
} /* getDatabasePath */


+ (NSInteger) getClassNumber {
    return kBehavioral_Key;
} /* getClassNumber */


+ (int) getNumberOfSections {
    return [[self getAllInsertSchemas] count];
} /* getNumberOfSections */


+ (NSMutableArray *) getAllInsertSchemas {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:kInsert_behavioral_attendance];
    [array addObject:kInsert_behavioral_respect];
    [array addObject:kInsert_behavioral_responsibility];
    [array addObject:kInsert_behavioral_feelings];

    return array;
} /* getAllInsertSchemas */


+ (NSMutableArray *) getAllNumberOfObjects {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    return array;
} /* getAllNumberOfObjects */


+ (void) insertStudentDataIntoClassDatabase :(NSString *)uid {
    sqlite3 *database;
    NSString *table;
    NSString *insert;
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for ( int x = 0; x < [self getNumberOfSections]; x++ ) {

        if (x == 0) {
            table = kTable_behavioral_attendance;
            insert = kInsert_behavioral_attendance;
            array = [[kObjects_behavioral_attendance componentsSeparatedByString:@","] copy];
        } else if (x == 1) {
            table = kTable_behavioral_respect;
            insert = kInsert_behavioral_respect;
            array = [[kObjects_behavioral_respect componentsSeparatedByString:@","] copy];
        } else if (x == 2) {
            table = kTable_behavioral_responsibility;
            insert = kInsert_behavioral_responsibility;
            array = [[kObjects_behavioral_responsibility componentsSeparatedByString:@","] copy];
        } else {
            table = kTable_behavioral_feelings;
            insert = kInsert_behavioral_feelings;
            array = [[kObjects_behavioral_feelings componentsSeparatedByString:@","] copy];
        }

        if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
            const char *sqlChar = [insert UTF8String];
            sqlite3_stmt *compiledStatement;

            if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {
                for (int y = 1; y <= [array count] + 1; y++) {
                    if (y == 1)
                        sqlite3_bind_text(compiledStatement, y, [uid UTF8String], -1, SQLITE_TRANSIENT);
                    else
                        sqlite3_bind_text(compiledStatement, y, [[NSString stringWithFormat:@"z%@nil", kContent_Delimiter] UTF8String], -1, SQLITE_TRANSIENT);
                }

                sqlite3_reset(compiledStatement);
            }

            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"Save Error (Insert Student): %s", sqlite3_errmsg(database) );
            }

            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(database);
    }
} /* insertStudentDataIntoClassDatabase */


+ (void) insertDataIntoClassDatabase :(NSString *)uid section :(int)s row :(int)r text :(NSString *)text {
    sqlite3 *database;
    NSString *table;
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    NSString *object;

    if (s == 0) {
        table = kTable_behavioral_attendance;
        parsedArray = [[kObjects_behavioral_attendance componentsSeparatedByString:@","] mutableCopy];
        object = [[parsedArray objectAtIndex:r] stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else if (s == 1) {
        table = kTable_behavioral_respect;
        parsedArray = [[kObjects_behavioral_respect componentsSeparatedByString:@","] mutableCopy];
        object = [[parsedArray objectAtIndex:r] stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else if (s == 2) {
        table = kTable_behavioral_responsibility;
        parsedArray = [[kObjects_behavioral_responsibility componentsSeparatedByString:@","] mutableCopy];
        object = [[parsedArray objectAtIndex:r] stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        table = kTable_behavioral_feelings;
        parsedArray = [[kObjects_behavioral_feelings componentsSeparatedByString:@","] mutableCopy];
        object = [[parsedArray objectAtIndex:r] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    NSString *updateStatement = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE uid='%@'", table, object, text, uid];

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {

        const char *sql = [updateStatement UTF8String];

        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK) {

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error ([Behavioral]Insert Student): %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
} /* insertStudentDataIntoClassDatabase */


/*    Check and Create Employee database if not availiable */
+ (NSString *) checkAndCreateDatabase {

    /*  Get the path to the documents directory and append the databaseName */
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);

    NSString *databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:[self getDatabasePath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL success = [fileManager fileExistsAtPath:databasePath];

    if (true) {
        if (success) {
            return databasePath;
        } else {
            NSLog(@"Behavioral SQL database not found. If this is a new installation, \
                  the database from the app bundle will be copied over.");
            [fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self getDatabasePath]] toPath:databasePath error:nil];
        }
    } else {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self getDatabasePath]];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }

    return databasePath;
} /* checkAndCreateDatabase */


// Read Employees From database and insert into student array
+ (NSMutableArray *) retrieveStudentDataFromDatabase :(NSString *)uid {
    sqlite3 *database;
    NSString *table;
    NSMutableArray *studentObjectArray = [[NSMutableArray alloc] init];
    NSMutableArray *temporaryArray = [[NSMutableArray alloc] init];

    for ( int x = 0; x < [self getNumberOfSections]; x++ ) {

        if (x == 0)
            table = kTable_behavioral_attendance;
        else if (x == 1)
            table = kTable_behavioral_respect;
        else if (x == 2)
            table = kTable_behavioral_responsibility;
        else
            table = kTable_behavioral_feelings;

        NSString *retrieveStatement = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid='%@'", table, uid];

        if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {

            const char *sqlStatement = [retrieveStatement UTF8String];

            sqlite3_stmt *compiledStatement;

            if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
                NSLog(@"[Behavioral]Problem with prepare statement: %@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(database)]);
            }

            if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {

                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

                    int x = 1;
                    while ( x < sqlite3_column_count(compiledStatement) - 1) {
                        [temporaryArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, x)]];
                        x++;
                    }
                }
            }

            /* Release the compiled statement from memory */
            sqlite3_finalize(compiledStatement);
        }

        [studentObjectArray addObject:temporaryArray];
        temporaryArray = [[NSMutableArray alloc] init];
    }
    sqlite3_close(database);

    return studentObjectArray;
} /* readEmployeesFromDatabase */


+ (void) insertFormativeDataIntoClassDatabase :(NSString *)uid :(NSMutableDictionary *)dictionary {
    sqlite3 *database;

    NSString *data = [NSString stringWithFormat:@"%@/%@/%@", [dictionary valueForKey:@"name"],
                      [dictionary valueForKey:@"score"],
                      [dictionary valueForKey:@"date"]];

    NSString *insertData = [NSString stringWithFormat:@"INSERT INTO %@(uid,%@) VALUES(\"%@\",\"%@\")", kTable_behavioral_formative, kColumn_formative, uid, data];
    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [insertData UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error (Insert Student): %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
} /* insertFormativeDataIntoClassDatabase */


+ (void) insertStandardizedDataIntoClassDatabase :(NSString *)uid :(NSMutableDictionary *)dictionary {
    sqlite3 *database;

    NSString *data = [NSString stringWithFormat:@"%@/%@/%@", [dictionary valueForKey:@"name"],
                      [dictionary valueForKey:@"score"],
                      [dictionary valueForKey:@"date"]];

    NSString *insertData = [NSString stringWithFormat:@"INSERT INTO %@(uid,%@) VALUES(\"%@\",\"%@\")", kTable_behavioral_standard, kColumn_standard, uid, data];
    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [insertData UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error (Insert Student): %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
} /* insertStandardizedDataIntoClassDatabase */


+ (NSMutableArray *) selectFormativeDataIntoClassDatabase :(NSString *)uid {
    sqlite3 *database;
    NSMutableArray *formativeArray = [[NSMutableArray alloc] init];

    NSString *selectStatement = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE uid='%@'", kColumn_formative, kTable_behavioral_formative, uid];

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [selectStatement UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

                [formativeArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];

            }
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {}

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

    return formativeArray;
} /* selectFormativeDataIntoClassDatabase */


+ (void) updateDataIntoClassDatabase :(NSString *)uid :(NSMutableDictionary *)dictionary :(NSMutableDictionary *)oldDictionary :(int)key {
    sqlite3 *database;

    NSString *oldData = [NSString stringWithFormat:@"%@/%@/%@", [oldDictionary valueForKey:@"name"],
                         [oldDictionary valueForKey:@"score"],
                         [oldDictionary valueForKey:@"date"]];

    NSString *data = [NSString stringWithFormat:@"%@/%@/%@", [dictionary valueForKey:@"name"],
                      [dictionary valueForKey:@"score"],
                      [dictionary valueForKey:@"date"]];

    NSString *updateData = nil;
    if (key == kFormative_Key)
        updateData = [NSString stringWithFormat:@"UPDATE %@ set %@='%@' WHERE uid='%@' and %@='%@'", kTable_behavioral_formative, kColumn_formative, data, uid, kColumn_formative, oldData];
    else if (key == kStandardized_Key)
        updateData = [NSString stringWithFormat:@"UPDATE %@ set %@='%@' WHERE uid='%@' and %@='%@'", kTable_behavioral_standard, kColumn_standard, data, uid, kColumn_standard, oldData];

    NSLog(@"updateData: %@", updateData);
    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [updateData UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"[%s] Update Error (Update Student): %s", __PRETTY_FUNCTION__, sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
} /* updateDataIntoClassDatabase */


+ (NSMutableArray *) selectStandardizedDataIntoClassDatabase :(NSString *)uid {
    sqlite3 *database;
    NSMutableArray *standardizedArray = [[NSMutableArray alloc] init];

    NSString *selectStatement = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE uid='%@'", kColumn_standard, kTable_behavioral_standard, uid];

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [selectStatement UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

                [standardizedArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];

            }

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {}

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

    return standardizedArray;
} /* selectStandardizedDataIntoClassDatabase */


+ (void) deleteFromTestAssesments :(NSString *)uid :(NSString *)string :(int)key {
    sqlite3 *database;

    NSString *deleteRecord = nil;

    if (key == kFormative_Key)
        deleteRecord = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid='%@' and %@='%@'", kTable_behavioral_formative, uid, kColumn_formative, string];
    else if (key == kStandardized_Key)
        deleteRecord = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid='%@' and %@='%@'", kTable_behavioral_standard, uid, kColumn_standard, string];

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [deleteRecord UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Delete Error (Delete Student): %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
} /* insertStandardizedDataIntoClassDatabase */


@end
