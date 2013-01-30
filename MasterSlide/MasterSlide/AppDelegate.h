//
//  DocPadAppDelegate.h
//  DocSets
//
//  Created by Ole Zorn on 05.12.10.
//  Copyright 2010 omz:software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeSplitViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import <sqlite3.h>
#import "Student.h"

@class MasterViewController, DetailViewController, SwipeSplitViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
	UIWindow *window;
	SwipeSplitViewController *splitViewController;
	MasterViewController *rootViewController;
	UINavigationController *rootNavigationController;
	DetailViewController *detailViewController;
    NSString *databaseName;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) SwipeSplitViewController *splitViewController;
@property (nonatomic, strong) MasterViewController *rootViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) NSMutableArray *studentArray;
@property (nonatomic, strong) NSMutableArray *studentArraySectioned;
@property (nonatomic, strong) NSMutableArray *alphaIndex;
@property (nonatomic, strong) NSMutableArray *studentSectionHeaders;
@property (nonatomic, strong) NSString *databasePath;

- (void) reloadData;

@end
