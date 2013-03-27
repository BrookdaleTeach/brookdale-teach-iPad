//
//  AppDelegate
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

/* Imports */

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Student.h"

/* Class Definitions */

@class MasterViewController, DetailViewController, SwipeSplitViewController;

/*
 * Class Main Interface
 */

@interface AppDelegate : NSObject <UIApplicationDelegate> {

    /* Local Declarations */

    UIWindow *window;
    UINavigationController *rootNavigationController;
    NSString *databaseName;
}

/* Global Declarations */

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *studentArray;
@property (nonatomic, strong) NSMutableArray *studentArraySectioned;
@property (nonatomic, strong) NSMutableArray *alphaIndex;
@property (nonatomic, strong) NSMutableArray *studentSectionHeaders;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) NSMutableArray *mathStudentsArray;
@property (nonatomic, strong) NSMutableArray *readingStudentsArray;
@property (nonatomic, strong) NSMutableArray *writingStudentsArray;
@property (nonatomic, strong) NSMutableArray *behavioralStudentsArray;


/* Global Method Declarations */

- (void) reloadCoreData;
- (void) loadApplicationFromLogin :(BOOL)flag;
- (void) loadApplicationFromDemo;

/* Global Non-Instance Method Declarations */

+ (BOOL) isDemo;
+ (BOOL) getRememberMeState;
+ (void) setRememberMeState :(BOOL)flag;
+ (NSString *) getEmail;
+ (void) setEmail :(NSString *)email;
+ (NSString *) getPassword;
+ (void) setPassword :(NSString *)pass;

@end
