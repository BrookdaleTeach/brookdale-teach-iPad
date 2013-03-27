#import <UIKit/UIKit.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *gender;

@property (nonatomic) int dob_month;
@property (nonatomic) int dob_day;
@property (nonatomic) int dob_year;

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *parent_firstName;
@property (strong, nonatomic) NSString *parent_lastName;
@property (strong, nonatomic) NSString *parent_email;
@property (strong, nonatomic) NSString *parent_phone;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *classkey;
@property (nonatomic, readwrite) int key;
@property (nonatomic, readwrite) int primaryKey;


- (id) initWithName :(NSString *)n firstName :(NSString *)first lastName :(NSString *)last gender :(NSString *)gen dob_month :(int)month dob_day :(int)day dob_year :(int)year image :(NSString *)im uid :(NSString *)d email :(NSString *)em phone :(NSString *)ph address :(NSString *)addr parent_firstName :(NSString *)pf parent_lastName :(NSString *)pl parent_email :(NSString *)pe parent_phone :(NSString *)pp relationship :(NSString *)rel notes :(NSString *)note classkey :(NSString *)ck key :(int)k primaryKey :(int)pk;

@end


