#import "AppDelegate.h"
#define DATABASE_NAME @"students.sql"

@interface AppDelegate ()

- (void)saveInterfaceState;
- (void)restoreInterfaceState;

@end


@implementation AppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;
@synthesize alphaIndex;
@synthesize studentArray = _studentArray;
@synthesize studentArraySectioned = _studentArraySectioned;
@synthesize databasePath = _databasePath;
@synthesize studentSectionHeaders = _studentSectionHeaders;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  /*  Get the path to the documents directory and append the databaseName */
                                                                  NSUserDomainMask, YES);
    NSString * documentsDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
    
    /*    Check and create employee database */
    [self checkAndCreateDatabase];
    
    /*    Read employees from DB and insert into main employeeArray */
    [self readEmployeesFromDatabase];
    
	self.rootViewController = [[MasterViewController alloc] initWithNibName:nil bundle:nil];
	rootNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		self.detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *asd = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];

//		rootViewController.detailViewController = asd;
		self.splitViewController = [[SwipeSplitViewController alloc] initWithMasterViewController:rootNavigationController
																			 detailViewController:asd];
		self.window.rootViewController = self.splitViewController;
	} else {
		self.window.rootViewController = rootNavigationController;
	}
	[self.window makeKeyAndVisible];
	
    return YES;
}

- (void)logArrayHeaderSections
{    
    for (int x = 0; x < self.studentSectionHeaders.count; x++)
    {
        NSLog(@"studentSectionHeaders: %@", [self.studentSectionHeaders objectAtIndex:x]);
    }

}

- (void) reloadData
{
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  /*  Get the path to the documents directory and append the databaseName */
                                                                  NSUserDomainMask, YES);
    NSString * documentsDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
    NSLog(@"Reread database path");
    
    /*    Check and create employee database */
    [self checkAndCreateDatabase];
    NSLog(@"Checked Database");

    /*    Read employees from DB and insert into main employeeArray */
    [self readEmployeesFromDatabase];
    NSLog(@"Read Database");
}

/*    Check and Create Employee database if not availiable */
- (void) checkAndCreateDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:self.databasePath];
    NSLog(@"Database Path: %@", self.databasePath);
    
//    if (success) {
//        return;
//    } else {
//        NSLog(@"SQL database not found. If this is a new installation, \
//              the database from the app bundle will be copied over.");
//        [self createNewDatabaseSchema];
//    }
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
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

// Read Employees From database and insert into student array
- (void) readEmployeesFromDatabase {
    sqlite3 *database;
    
    alphaIndex = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
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
                int aKey = (int)sqlite3_column_int(compiledStatement, 18);
                int aAutoKey = (int)sqlite3_column_int(compiledStatement, 19);
                
                /* Create new student object with data from the database */
                Student *student = [[Student alloc] initWithName:[NSString stringWithFormat:@"%@ %@", aFirstName, aLastName] firstName:aFirstName lastName:aLastName gender:aGender dob_month:aDOBmonth dob_day:aDOBday dob_year:aDOByear image:aImage uid:aUID email:aEmail phone:aPhone address:aAddress parent_firstName:aParentFirstName parent_lastName:aParentLastName parent_email:aParentEmail parent_phone:aParentPhone relationship:aParentRelationship notes:aNotes key:aKey primaryKey:aAutoKey];
                
                /* Add object to the student array */
                [self.studentArray addObject:student];
                
                if (inc == 0)
                {
                    [temparr addObject:student];
                    [self.studentSectionHeaders addObject:[[[student lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
                    inc++;
                }
                else
                {
                    if (inc <= alphaIndex.count)
                    {
                        Student *temp = (Student *)[temparr lastObject];
                        NSString *lastObjString = [NSString stringWithFormat:@"%@", [temp lastName]];
                        if ( [[[[student lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]
                                                     isEqualToString:
                             [[lastObjString substringWithRange:NSMakeRange(0, 1)] capitalizedString]] || temparr.count == 0)
                        {
                            [temparr addObject:student];
                        }
                        else
                        {
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
            [self.studentArraySectioned addObject:temparr];
            Student *temp = (Student *)[temparr lastObject];
            [self.studentSectionHeaders addObject:[[[temp lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]];

        }
        
        /* Release the compiled statement from memory */
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(database);
    
//    [self logSectionedArray];
//    [self logArrayHeaderSections];
} /* readEmployeesFromDatabase */

-(void)logSectionedArray
{
    Student * student;
    for (int x = 0; x < self.studentArraySectioned.count; x++)
    {
        for (int y = 0; y < [[self.studentArraySectioned objectAtIndex:x] count]; y++)
        {
            student = (Student *)[[self.studentArraySectioned objectAtIndex:x] objectAtIndex:y];

            NSLog(@"studentArraySectioned: %@", [student fullName]);
        }
        NSLog(@"=========> %@", [[[student lastName] substringWithRange:NSMakeRange(0, 1)] capitalizedString]);
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)saveInterfaceState
{
}

- (void)restoreInterfaceState
{
}

@end

