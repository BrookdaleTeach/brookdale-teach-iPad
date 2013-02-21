//
//  MathAssessmentModel.m
//  Bobcats
//
//  Created by Burchfield, Neil on 2/11/13.
//
//

#import "MathAssessmentModel.h"
#import <sqlite3.h>

@implementation MathAssessmentModel
@synthesize databasePath;

+ (NSString *) getDatabasePath {
    return kMath_Database;
} /* getDatabasePath */


+ (NSInteger) getClassNumber {
    return kMath_Key;
} /* getClassNumber */


+ (int) getNumberOfSections {
    return 2;
} /* getNumberOfSections */


+ (NSMutableArray *) getAllInsertSchemas {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:kInsert_math_behaviors];
    [array addObject:kInsert_math_skills];

    return array;
} /* getAllInsertSchemas */


+ (NSMutableArray *) getAllNumberOfObjects {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSNumber numberWithInteger:kNOO_math_behaviors]];
    [array addObject:[NSNumber numberWithInteger:kNOO_math_skills]];

    return array;
} /* getAllNumberOfObjects */


+ (void) insertStudentDataIntoClassDatabase :(NSString *)uid {
    sqlite3 *database;
    NSString *table;
    NSString *insert;
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for ( int x = 0; x < [self getNumberOfSections]; x++ ) {

        if (x == 0) {
            table = kTable_math_behaviors;
            insert = kInsert_math_behaviors;
            array = [[kObjects_math_behaviors componentsSeparatedByString:@","] copy];
        } else {
            table = kTable_math_skills;
            insert = kInsert_math_skills;
            array = [[kObjects_math_skills componentsSeparatedByString:@","] copy];

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
        table = kTable_math_behaviors;
        parsedArray = [[kObjects_math_behaviors componentsSeparatedByString:@","] mutableCopy];
        NSLog(@"parsed array: %d, row: %d", parsedArray.count, r);
        object = [[parsedArray objectAtIndex:r] stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        table = kTable_math_skills;
        parsedArray = [[kObjects_math_skills componentsSeparatedByString:@","] mutableCopy];
        NSLog(@"parsed array: %d, row: %d", parsedArray.count, r);
        object = [[parsedArray objectAtIndex:r] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    NSString *updateStatement = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE uid='%@'", table, object, text, uid];
    NSLog(@"insert: %@", updateStatement);

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {

        const char *sql = [updateStatement UTF8String];

        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK) {

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error (Insert Student): %s", sqlite3_errmsg(database) );
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

    NSString *databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kMath_Database];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL success = [fileManager fileExistsAtPath:databasePath];

    if (true) {
        if (success) {
            return databasePath;
        } else {
            NSLog(@"Math SQL database not found. If this is a new installation, \
                  the database from the app bundle will be copied over.");
            [fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kMath_Database] toPath:databasePath error:nil];
        }
    } else {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kMath_Database];
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
            table = kTable_math_behaviors;
        else
            table = kTable_math_skills;

        NSString *retrieveStatement = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid='%@'", table, uid];

        if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {

            const char *sqlStatement = [retrieveStatement UTF8String];

            sqlite3_stmt *compiledStatement;

            if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
                NSLog(@"Problem with prepare statement: %@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(database)]);
            }

            if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {

                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

                    int x = 1;
                    while ( x < sqlite3_column_count(compiledStatement) - 1) {
                        NSLog(@"RETRIEVE: %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, x)]);
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

    NSString *insertData = [NSString stringWithFormat:@"INSERT INTO %@(uid,%@) VALUES(\"%@\",\"%@\")", kTable_math_formative, kColumn_formative, uid, data];
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

    NSString *insertData = [NSString stringWithFormat:@"INSERT INTO %@(uid,%@) VALUES(\"%@\",\"%@\")", kTable_math_standard, kColumn_standard, uid, data];
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

    NSString *selectStatement = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE uid='%@'", kColumn_formative, kTable_math_formative, uid];

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [selectStatement UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

                [formativeArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];

            }
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error (Select Formative Data): %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

    return formativeArray;
} /* selectFormativeDataIntoClassDatabase */


+ (NSMutableArray *) selectStandardizedDataIntoClassDatabase :(NSString *)uid {
    sqlite3 *database;
    NSMutableArray *standardizedArray = [[NSMutableArray alloc] init];

    NSString *selectStatement = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE uid='%@'", kColumn_standard, kTable_math_standard, uid];

    if (sqlite3_open([[self checkAndCreateDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [selectStatement UTF8String];
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {

            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {

                [standardizedArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];

            }

            sqlite3_reset(compiledStatement);
        }

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Save Error (Select Standardized Data): %s", sqlite3_errmsg(database) );
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

    return standardizedArray;
} /* selectStandardizedDataIntoClassDatabase */


@end
