//
//  StudentsDataLayer.m
//  Bobcats
//
//  Created by Burchfield, Neil on 3/27/13.
//
//

#import "StudentsDataLayer.h"

@implementation StudentsDataLayer

+ (void)insertStudentDataIntoClassDatabaseColumn:(NSString *)column withStudent:(NSString *)uid withText:(NSString *)text {
    sqlite3 *database;
    
    NSString *updateStatement = [NSString stringWithFormat:@"UPDATE students SET %@='%@' WHERE uid='%@'", column, text, uid];
    
    if (sqlite3_open([[self checkAndCreateStudentsDatabase] UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = [updateStatement UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_reset(compiledStatement);
        }
        
        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"[insertStudentDataIntoClassDatabaseColum] Save Error (Insert Student): %s", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
} /* insertStudentDataIntoClassDatabase */

+ (NSString *)retrieveStudentDataFromClassDatabaseColumn:(NSString *)column withStudent:(NSString *)uid  {
    sqlite3 *database;
    NSString * str;
    NSString *selectStatement = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE uid='%@'", @"notes", @"students", uid];
    
    if (sqlite3_open([[self checkAndCreateStudentsDatabase] UTF8String], &database) == SQLITE_OK) {
        const char *sqlChar = [selectStatement UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlChar, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return str;
    
} /* insertStudentDataIntoClassDatabase */

/*    Check and Create Employee database if not availiable */
+ (NSString *) checkAndCreateStudentsDatabase {
    
    /*  Get the path to the documents directory and append the databaseName */
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
    
    NSString *databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kStudents_Database];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:databasePath];
    
    if (true) {
        if (success) {
            return databasePath;
        } else {
            NSLog(@"Math SQL database not found. If this is a new installation, \
                  the database from the app bundle will be copied over.");
            [fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kStudents_Database] toPath:databasePath error:nil];
        }
    } else {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kStudents_Database];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    
    return databasePath;
} /* checkAndCreateDatabase */

@end
