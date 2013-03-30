//
//  AppDelegate
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */
#import "AppDelegate.h"
#import "ClassDefinitions.h"
#import "LoginViewController.h"
#import "UserCredentials.h"
#import "Crittercism.h"

/* Definitions */

#define DATABASE_NAME @"students.sql"
#define DEMO          TRUE

/* Static Definitions */

static BOOL isDemo = NO;
static BOOL remember_me;
static NSString *merchantEmail = nil;
static NSString *merchantPassword = nil;

/*
 * Main Implementation
 */

@implementation AppDelegate

/* Sythesizations */

@synthesize window;
@synthesize alphaIndex;
@synthesize studentArray = _studentArray;
@synthesize studentArraySectioned = _studentArraySectioned;
@synthesize databasePath = _databasePath;
@synthesize studentSectionHeaders = _studentSectionHeaders;
@synthesize mathStudentsArray = _mathStudentsArray;
@synthesize readingStudentsArray = _readingStudentsArray;
@synthesize writingStudentsArray = _writingStudentsArray;
@synthesize behavioralStudentsArray = _behavioralStudentsArray;

// ********************************************************************************/
// Function: supportedInterfaceOrientationsForWindow
// Arguments: UIApplication, UIWindow
// Returns: NSUInteger
// Description: Application Supported Interfaces
// ********************************************************************************/
- (NSUInteger) application :(UIApplication *)application supportedInterfaceOrientationsForWindow :(UIWindow *)window {
    /* iPad */
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    /* iPhone */
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
} /* application */


// ********************************************************************************/
// Function: didFinishLaunchingWithOptions
// Arguments: UIApplication, NSDictionary
// Returns: none
// Description: Application Launch
// ********************************************************************************/
- (BOOL) application :(UIApplication *)application didFinishLaunchingWithOptions :(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Initilize Crittercism
    [Crittercism enableWithAppID:@"5153aed25f72163850000002"];

    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    rootNavigationController = [[UINavigationController alloc] initWithRootViewController:lvc];
    self.window.rootViewController = rootNavigationController;

    [self.window makeKeyAndVisible];

    return YES;
} /* application */


// ********************************************************************************/
// Function: loadApplicationFromLogin
// Arguments: bool
// Returns: none
// Description: Load app from login perspective
// ********************************************************************************/
- (void) loadApplicationFromLogin :(BOOL)flag {

    UserCredentials *uc = [[UserCredentials alloc] init];

    if ([uc fetchDemoStateFromPlist]) {
        [self deleteAllSQL];
    }

    /*  Get the path to the documents directory and append the databaseName */
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentsDir stringByAppendingPathComponent:DATABASE_NAME];

    /*    Check and create employee database */
    [self checkAndCreateDatabase];

    /*    Read employees from DB and insert into main employeeArray */
    [self readEmployeesFromDatabase];

    [uc writeDemoStateIntoPlist:NO];
} /* loadApplicationFromLogin */


// ********************************************************************************/
// Function: deleteAllSQL
// Arguments: none
// Returns: none
// Description: Delete all previous data
// ********************************************************************************/
- (void) deleteAllSQL {
    /*  Get the path to the documents directory and append the databaseName */
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);

    [[NSFileManager defaultManager] removeItemAtPath:[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kStudents_Database] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kMath_Database] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kReading_Database] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kWriting_Database] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:kBehavioral_Database] error:nil];
} /* deleteAllSQL */


// ********************************************************************************/
// Function: loadApplicationFromDemo
// Arguments: none
// Returns: none
// Description: Set app data if demo
// ********************************************************************************/
- (void) loadApplicationFromDemo {

    NSError *err = nil;

    isDemo = YES;

    /*  Get the path to the documents directory and append the databaseName */
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentsDir stringByAppendingPathComponent:DATABASE_NAME];

    [self deleteAllSQL];

    NSString *studentSQLDemo = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDemoSQLStudents_Database];
    NSString *mathSQLDemo = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDemoSQLMath_Database];
    NSString *readingSQLDemo = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDemoSQLReading_Database];
    NSString *writingSQLDemo = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDemoSQLWriting_Database];
    NSString *behavioralSQLDemo = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDemoSQLBehavioral_Database];

    [[NSFileManager defaultManager] copyItemAtPath:studentSQLDemo toPath:[documentsDir stringByAppendingPathComponent:kStudents_Database] error:&err];
    [[NSFileManager defaultManager] copyItemAtPath:mathSQLDemo toPath:[documentsDir stringByAppendingPathComponent:kMath_Database] error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:readingSQLDemo toPath:[documentsDir stringByAppendingPathComponent:kReading_Database] error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:writingSQLDemo toPath:[documentsDir stringByAppendingPathComponent:kWriting_Database] error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:behavioralSQLDemo toPath:[documentsDir stringByAppendingPathComponent:kBehavioral_Database] error:nil];

    if (err != nil)
        NSLog(@"ERROR_COPYING: %@", err);
    /*    Read employees from DB and insert into main employeeArray */
    [self readEmployeesFromDatabase];
} /* loadApplicationFromDemo */


// ********************************************************************************/
// Function: isDemo
// Arguments: none
// Returns: none
// Description: External method if app is demo
// ********************************************************************************/
+ (BOOL) isDemo {
    return isDemo;
} /* isDemo */


// ********************************************************************************/
// Function: allocStudentArraysByClass
// Arguments: none
// Returns: none
// Description: Alloc class arrays
// ********************************************************************************/
- (void) allocStudentArraysByClass {
    self.mathStudentsArray = [[NSMutableArray alloc] init];
    self.readingStudentsArray = [[NSMutableArray alloc] init];
    self.writingStudentsArray = [[NSMutableArray alloc] init];
    self.behavioralStudentsArray = [[NSMutableArray alloc] init];
} /* allocStudentArraysByClass */


// ********************************************************************************/
// Function: returnValueOfSubstringDoesEqual
// Arguments: int, string
// Returns: int
// Description: Search for existing class keys
// ********************************************************************************/
- (int) returnValueOfSubstringDoesEqual :(int)i withStudentClassKey :(NSString *)string {

    // Range
    NSRange textRange;

    // Range of int
    textRange = [string rangeOfString:[NSString stringWithFormat:@"%d", i]];

    // Return yes if found
    if (textRange.location != NSNotFound)
        return i;

    return -1;
} /* returnValueOfSubstringDoesEqual */


// ********************************************************************************/
// Function: setMathStudentsArray
// Arguments: none
// Returns: none
// Description: Reload Array
// ********************************************************************************/
- (void) setMathStudentsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int x = 0; x < self.studentArraySectioned.count; x++) {
        for (int y = 0; y < [[self.studentArraySectioned objectAtIndex:x] count]; y++) {
            Student *student = [[self.studentArraySectioned objectAtIndex:x] objectAtIndex:y];
            if ([self returnValueOfSubstringDoesEqual:kMath_Key withStudentClassKey:[student classkey]] == kMath_Key) {
                [tempArray addObject:student];
            }
        }
        if (tempArray.count > 0)
            [self.mathStudentsArray addObject:tempArray];
        tempArray = [[NSMutableArray alloc] init];
    }
} /* setMathStudentsArray */


// ********************************************************************************/
// Function: setReadingStudentsArray
// Arguments: none
// Returns: none
// Description: Reload Array
// ********************************************************************************/
- (void) setReadingStudentsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int x = 0; x < self.studentArraySectioned.count; x++) {
        for (int y = 0; y < [[self.studentArraySectioned objectAtIndex:x] count]; y++) {
            Student *student = [[self.studentArraySectioned objectAtIndex:x] objectAtIndex:y];
            if ([self returnValueOfSubstringDoesEqual:kReading_Key withStudentClassKey:[student classkey]] == kReading_Key) {
                [tempArray addObject:student];
            }
        }
        if (tempArray.count > 0)
            [self.readingStudentsArray addObject:tempArray];
        tempArray = [[NSMutableArray alloc] init];
    }
} /* setReadingStudentsArray */


// ********************************************************************************/
// Function: setWritingStudentsArray
// Arguments: none
// Returns: none
// Description: Reload Array
// ********************************************************************************/
- (void) setWritingStudentsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int x = 0; x < self.studentArraySectioned.count; x++) {
        for (int y = 0; y < [[self.studentArraySectioned objectAtIndex:x] count]; y++) {
            Student *student = [[self.studentArraySectioned objectAtIndex:x] objectAtIndex:y];
            if ([self returnValueOfSubstringDoesEqual:kWriting_Key withStudentClassKey:[student classkey]] == kWriting_Key) {
                [tempArray addObject:student];
            }
        }
        if (tempArray.count > 0)
            [self.writingStudentsArray addObject:tempArray];
        tempArray = [[NSMutableArray alloc] init];
    }
} /* setWritingStudentsArray */


// ********************************************************************************/
// Function: setBehavioralStudentsArray
// Arguments: none
// Returns: none
// Description: Reload Array
// ********************************************************************************/
- (void) setBehavioralStudentsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int x = 0; x < self.studentArraySectioned.count; x++) {
        for (int y = 0; y < [[self.studentArraySectioned objectAtIndex:x] count]; y++) {
            Student *student = [[self.studentArraySectioned objectAtIndex:x] objectAtIndex:y];
            if ([self returnValueOfSubstringDoesEqual:kBehavioral_Key withStudentClassKey:[student classkey]] == kBehavioral_Key) {
                [tempArray addObject:student];
            }
        }
        if (tempArray.count > 0)
            [self.behavioralStudentsArray addObject:tempArray];
        tempArray = [[NSMutableArray alloc] init];
    }
} /* setBehavioralStudentsArray */


// ********************************************************************************/
// Function: reloadCoreData
// Arguments: none
// Returns: none
// Description: Reload Application's data
// ********************************************************************************/
- (void) reloadCoreData {
    /*  Get the path to the documents directory and append the databaseName */
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
    NSLog(@"%s Reread database path", __PRETTY_FUNCTION__);

    /*    Check and create employee database */
    [self checkAndCreateDatabase];
    NSLog(@"%s Checked Database", __PRETTY_FUNCTION__);

    /*    Read employees from DB and insert into main employeeArray */
    [self readEmployeesFromDatabase];
    NSLog(@"%s Read Database", __PRETTY_FUNCTION__);
} /* reloadCoreData */


// ********************************************************************************/
// Function: checkAndCreateDatabase
// Arguments: none
// Returns: none
// Description: Check and Create Student database if not availiable
// ********************************************************************************/
- (void) checkAndCreateDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    success = [fileManager fileExistsAtPath:self.databasePath];
    NSLog(@"Database Path: %@", self.databasePath);

    if (!DEMO) {
        if (success) {
            return;
        } else {
            NSLog(@"SQL database not found. If this is a new installation, \
                  the database from the app bundle will be copied over.");
            [self createNewDatabaseSchema];
        }
    } else {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
        [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    }

} /* checkAndCreateDatabase */


// ********************************************************************************/
// Function: createNewDatabaseSchema
// Arguments: none
// Returns: none
// Description: If database is new, create the sql schema
// ********************************************************************************/
- (void) createNewDatabaseSchema {
    sqlite3 *database;

    if (sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = "CREATE TABLE employees(firstName TEXT, lastName TEXT, fullName TEXT, image TEXT, onepass TEXT, id TEXT, description TEXT, email TEXT, ophone TEXT, cphone TEXT, division TEXT, location TEXT, reportTo TEXT, isManager TEXT, status TEXT, floor TEXT,  legalName TEXT, key INTEGER)";
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
            NSLog(@"Problem with prepare statement: %@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(database)]);
        }
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            sqlite3_exec(database, sqlStatement, NULL, NULL, nil);
        }

        /* Release the compiled statement from memory */
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

} /* createNewDatabaseSchema */


// ********************************************************************************/
// Function: readEmployeesFromDatabase
// Arguments: none
// Returns: none
// Description: Read Employees From database and insert into student array
// ********************************************************************************/
- (void) readEmployeesFromDatabase {
    sqlite3 *database;

    alphaIndex = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
                  @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];

    BOOL empty = YES;

    self.studentArraySectioned = [[NSMutableArray alloc] init];
    self.studentArray = [[NSMutableArray alloc] init];
    self.studentSectionHeaders = [[NSMutableArray alloc] init];

    if (sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = "SELECT * FROM students ORDER BY lastName ASC, firstName ASC";
        sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
            NSLog(@"Problem with prepare statement: %@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(database)]);
        }

        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            int inc = 0;
            NSMutableArray *temparr = [[NSMutableArray alloc] init];
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                /* Read the data from the employee columns */
                NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *aLastName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] capitalizedString];
                NSString *aGender = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                int aDOBmonth = (int)sqlite3_column_int(compiledStatement, 4);
                int aDOBday = (int)sqlite3_column_int(compiledStatement, 5);
                int aDOByear = (int)sqlite3_column_int(compiledStatement, 6);
                NSString *aImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *aUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *aEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *aPhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString *aAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *aParentFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                NSString *aParentLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                NSString *aParentEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                NSString *aParentPhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                NSString *aParentRelationship = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                NSString *aNotes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                NSString *aClassKey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                int aKey = (int)sqlite3_column_int(compiledStatement, 19);
                int aAutoKey = (int)sqlite3_column_int(compiledStatement, 20);

                /* Create new student object with data from the database */
                Student *student = [[Student alloc] initWithName:[NSString stringWithFormat:@"%@ %@", aFirstName, aLastName] firstName:aFirstName lastName:aLastName gender:aGender dob_month:aDOBmonth dob_day:aDOBday dob_year:aDOByear image:aImage uid:aUID email:aEmail phone:aPhone address:aAddress parent_firstName:aParentFirstName parent_lastName:aParentLastName parent_email:aParentEmail parent_phone:aParentPhone relationship:aParentRelationship notes:aNotes classkey:aClassKey key:aKey primaryKey:aAutoKey];

                /* Add object to the student array */
                [self.studentArray addObject:student];

                if (student != nil ) {
                    empty = NO;
                }

                if ( !empty ) {
                    if (inc == 0) {
                        [temparr addObject:student];
                        [self.studentSectionHeaders addObject:[[[student lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
                        inc++;
                    } else {
                        if (inc <= alphaIndex.count) {
                            Student *temp = (Student *)[temparr lastObject];
                            NSString *lastObjString = [NSString stringWithFormat:@"%@", [temp lastName]];
                            if ( [[[[student lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]
                                  isEqualToString:
                                  [[lastObjString substringWithRange:NSMakeRange(0, 1)] capitalizedString]] || ( temparr.count == 0) ) {
                                [temparr addObject:student];
                            } else {
                                if (![[[[temp lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString] isEqualToString:[[self.studentSectionHeaders lastObject] capitalizedString]])
                                    [self.studentSectionHeaders addObject:[[[temp lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
                                [self.studentArraySectioned addObject:temparr];
                                temparr = [[NSMutableArray alloc] init];
                                [temparr addObject:student];
                                inc++;
                            }
                        }
                    }
                }

            }
            if (!empty) {
                [self.studentArraySectioned addObject:temparr];
                Student *temp = (Student *)[temparr lastObject];
                [self.studentSectionHeaders addObject:[[[temp lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
            }

        }

        /* Release the compiled statement from memory */
        sqlite3_finalize(compiledStatement);
    }

    sqlite3_close(database);

    [self allocStudentArraysByClass];
    [self setMathStudentsArray];
    [self setReadingStudentsArray];
    [self setWritingStudentsArray];
    [self setBehavioralStudentsArray];
} /* readEmployeesFromDatabase */


+ (BOOL) getRememberMeState {
    return remember_me;
} /* getRememberMeState */


+ (void) setRememberMeState :(BOOL)flag {
    remember_me = flag;
} /* setRememberMeState */


+ (NSString *) getEmail {
    return merchantEmail;
} /* getMerchantEmail */


+ (void) setEmail :(NSString *)email {
    if (merchantEmail != email) {
        merchantEmail = [email copy];
    }
} /* setMerchantEmail */


+ (NSString *) getPassword {
    return merchantPassword;
} /* getMerchantPassword */


+ (void) setPassword :(NSString *)pass {
    if (merchantPassword != pass) {
        merchantPassword = [pass copy];
    }
} /* setMerchantPassword */


- (void) applicationDidEnterBackground :(UIApplication *)application {
} /* applicationDidEnterBackground */


@end

