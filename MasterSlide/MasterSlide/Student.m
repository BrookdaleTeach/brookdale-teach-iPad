#import "Student.h"

@implementation Student
@synthesize firstName, lastName, fullName, gender, dob_month, dob_day, dob_year, image, uid, email, phone;
@synthesize address, parent_firstName, parent_lastName, parent_email, parent_phone, relationship, notes, key, primaryKey;

- (id)initWithName: (NSString *)n firstName: (NSString *)first lastName: (NSString *)last gender: (NSString *)gen dob_month: (int)month dob_day: (int)day dob_year: (int)year image: (NSString *)im uid: (NSString *)d email: (NSString *)em phone: (NSString *)ph address: (NSString *)addr parent_firstName: (NSString *)pf parent_lastName: (NSString *)pl parent_email: (NSString *)pe parent_phone: (NSString *)pp relationship: (NSString *)rel notes: (NSString *)note key: (int)k primaryKey: (int)pk
{
    self.fullName = n;
    self.firstName = first;
    self.lastName = last;
    self.gender = gen;
    self.image = im;
    self.dob_month = month;
    self.dob_day = day;
    self.dob_year = year;
    self.uid = d;
    self.email = em;
    self.phone = ph;
    self.address = addr;
    self.parent_firstName = pf;
    self.parent_lastName = pl;
    self.parent_email = pe;
    self.parent_phone = pp;
    self.relationship = rel;
    self.notes = note;
    self.key = k;
    self.primaryKey = pk;
    
    return self;
}

@end
