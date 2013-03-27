//
//  UserCredentials.h
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/31/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */

#import <Foundation/Foundation.h>
#import "Lockbox.h"

/*
 * Class Main Interface
 */

@interface UserCredentials : NSObject {
    
    /* Local Declarations */

    NSString *login_username_plist;
    NSString *login_username_keychain;
    NSString *login_password_keychain;
    BOOL rememberMeState;
}
- (BOOL) writeUsernameAndStateToPlist :(NSString *)user :(BOOL)state;
- (BOOL) getRememberMeFromPlist;
- (void)setUsernameFromKeyChain :(NSString *)user;
- (NSString *)getUsernameFromKeyChain;
- (void)setPasswordFromKeyChain :(NSString *)pass;
- (NSString *)getPasswordFromKeyChain;
- (BOOL) setUsernameIntoKeyChainWithPassword:(NSString *)user :(NSString *)pass;
- (BOOL) initilize:(BOOL)create;
- (void) writeDemoStateIntoPlist:(BOOL)state;
- (BOOL) fetchDemoStateFromPlist;
- (NSArray *)fetchUsernamePasswordStateFromPlist;
- (void) writeUsernamePasswordStateToPlist :(NSString *)user password:(NSString *)pass state:(BOOL)state;

@end
