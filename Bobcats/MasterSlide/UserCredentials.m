//
//  UserCredentials.m
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/31/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

#import "UserCredentials.h"

#define USERNAME_PLIST     @"settings.plist"
#define CREDENTIALS_PLIST  @"creds.plist"
#define USERNAME_PLIST_KEY @"user"
#define PASSWORD_PLIST_KEY @"password"
#define REMEMBER_ME_PLIST_KEY @"reme"

@implementation UserCredentials

- (BOOL) initilize:(BOOL)create {
    BOOL success = NO;
    if ([self plistExists]) {
        if ([self fetchUsernameAndStateFromPlist]) {
            NSString *passForPlistUser = [Lockbox stringForKey:[self getUsernamePlist]];
            if ((passForPlistUser != nil) || [passForPlistUser isEqualToString:@""]) {
                [self setPasswordFromKeyChain:passForPlistUser];
                [self setUsernameFromKeyChain:[self getUsernamePlist]];
                success = YES;
            }
        } else {
            NSLog(@"PLIST DOESNT HAVE USERNAME");
            [self setPasswordFromKeyChain:@""];
            [self setUsernameFromKeyChain:@""];
        }
    }
    else
    {
        if (create)
            [self createEmptyPlist];
    }
    
    return [self plistExists];
} /* initilize */


- (BOOL) setUsernameIntoKeyChainWithPassword:(NSString *)user :(NSString *)pass {
    return [Lockbox setString:pass forKey:user];
} /* setUsernameIntoKeyChainWithPassword */


- (void) setUsernameFromKeyChain:(NSString *)user {
    login_username_keychain = [user copy];
} /* setUsernameFromKeyChain */


- (NSString *) getUsernameFromKeyChain {
    return login_username_keychain;
} /* getUsernameFromKeyChain */


- (void) setUsernameFromPlist:(NSString *)user {
    login_username_plist = [user copy];
} /* setUsernameFromPlist */


- (NSString *) getUsernamePlist {
    return login_username_plist;
} /* getUsernamePlist */


- (void) setRememberMeFromPlist:(BOOL)flag {
    rememberMeState = flag;
} /* setRememberMeFromPlist */


- (BOOL) getRememberMeFromPlist {
    return rememberMeState;
} /* getRememberMeFromPlist */


- (void) setPasswordFromKeyChain:(NSString *)pass {
    login_password_keychain = [pass copy];
} /* setPasswordFromKeyChain */


- (NSString *) getPasswordFromKeyChain {
    return login_password_keychain;
} /* getPasswordFromKeyChain */


- (BOOL) plistExists {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistLocation = [documentsDirectory stringByAppendingPathComponent:USERNAME_PLIST];
    NSLog(@"plistlocation: %@", plistLocation);
    return [[NSFileManager defaultManager] fileExistsAtPath:plistLocation];
} /* plistExists */

- (void) createEmptyPlist {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:USERNAME_PLIST];
    [[[NSDictionary alloc] init] writeToFile:filePath atomically:YES];
} /* writeUsernameToPlist */


- (void) writeDemoStateIntoPlist:(BOOL)state {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:USERNAME_PLIST];
    NSMutableDictionary *userkey = [[NSMutableDictionary alloc] init];
    
    [userkey setObject:[NSNumber numberWithBool:state] forKey:@"lastEntryWasDemo"];
    
    [userkey writeToFile:filePath atomically:YES];
} /* writeUsernameToPlist */

- (BOOL) fetchDemoStateFromPlist {
    
    if ([self plistExists]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:USERNAME_PLIST];
        NSMutableDictionary *userNameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        return [[userNameDict objectForKey:@"lastEntryWasDemo"] boolValue];
    }
    
    return NO;
} /* fetchUsernameFromPlist */

- (void) writeUsernamePasswordStateToPlist :(NSString *)user password:(NSString *)pass state:(BOOL)state {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CREDENTIALS_PLIST];
    
    NSMutableDictionary *userkey;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        userkey = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    else
        userkey = [[NSMutableDictionary alloc] init];
    
    [userkey setObject:user forKey:USERNAME_PLIST_KEY];
    [userkey setObject:pass forKey:PASSWORD_PLIST_KEY];
    [userkey setObject:[NSNumber numberWithBool:state] forKey:REMEMBER_ME_PLIST_KEY];


    [userkey writeToFile:filePath atomically:YES];
} /* writeUsernameToPlist */

- (NSArray *)fetchUsernamePasswordStateFromPlist {
    
    NSString *userName = @"";
    NSString *password = @"";
    BOOL remMeState = NO;

    if ([self plistExists]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:CREDENTIALS_PLIST];
        
        NSMutableDictionary *userNameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        if ([userNameDict valueForKey:USERNAME_PLIST_KEY] != nil)
            userName = [userNameDict valueForKey:USERNAME_PLIST_KEY];
        
        if ([userNameDict valueForKey:PASSWORD_PLIST_KEY] != nil)
            password = [userNameDict valueForKey:PASSWORD_PLIST_KEY];
        
        if ([userNameDict valueForKey:REMEMBER_ME_PLIST_KEY] != nil)
            remMeState = [[userNameDict valueForKey:REMEMBER_ME_PLIST_KEY] boolValue];
    }
    
    return [[NSArray alloc] initWithObjects:userName, password, [NSNumber numberWithBool:remMeState], nil];
} /* fetchUsernameFromPlist */

- (BOOL) writeUsernameAndStateToPlist :(NSString *)user :(BOOL)state {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:USERNAME_PLIST];
    NSMutableDictionary *userkey = [[NSMutableDictionary alloc] init];
    
    [userkey setObject:user forKey:USERNAME_PLIST_KEY];    
    [userkey setObject:[NSNumber numberWithBool:state] forKey:REMEMBER_ME_PLIST_KEY];
    [userkey writeToFile:filePath atomically:YES];

    return [self plistExists];
} /* writeUsernameToPlist */


- (BOOL) fetchUsernameAndStateFromPlist {

    if ([self plistExists]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:USERNAME_PLIST];

        NSMutableDictionary *userNameDict;
        NSString *userName;
        BOOL remMeState = NO;
            userNameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
            userName = [userNameDict objectForKey:USERNAME_PLIST_KEY];
            [self setUsernameFromPlist:userName];
            remMeState = [[userNameDict objectForKey:REMEMBER_ME_PLIST_KEY] boolValue];
            [self setRememberMeFromPlist:remMeState];
        return YES;
    }

    return NO;
} /* fetchUsernameFromPlist */


@end


















