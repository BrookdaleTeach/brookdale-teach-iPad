//
//  Util.m
//  Bobcats
//
//  Created by Burchfield, Neil on 3/31/13.
//
//

#import "Util.h"

void Alert(NSString *title, NSString *msg) {
    [[[UIAlertView alloc]
      initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
     show];
} /* Alert */

