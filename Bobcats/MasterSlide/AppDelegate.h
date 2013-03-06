//
//  AppDelegate
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Student.h"

@class MasterViewController, DetailViewController, SwipeSplitViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *rootNavigationController;
    NSString *databaseName;
}

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


- (void) reloadCoreData;
- (void)loadApplicationFromLogin:(BOOL)flag;
- (void)loadApplicationFromDemo;

+ (BOOL)isDemo;
+ (BOOL) getRememberMeState;
+ (void) setRememberMeState:(BOOL)flag;
+ (NSString *) getEmail;
+ (void) setEmail:(NSString *)email;
+ (NSString *) getPassword ;
+ (void) setPassword:(NSString *)pass;

@end
