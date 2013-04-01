//
//  TeacherSettings.h
//  Bobcats
//
//  Created by Burchfield, Neil on 3/26/13.
//
//

#define kSettingsShouldSaveNotification     @"kSettingsShouldSaveNotification"

#define kTeacherSettingsPlist       @"teacherSettings.plist"
#define kTeacherNoCustomImage       @"person.png"
#define kTeacherNil                 @""

#define kTeacherName    @"Name"
#define kTeacherEmail   @"Email"
#define kTeacherGrade   @"Grade"
#define kTeacherPhone   @"Phone"
#define kTeacherImage   @"Image"
#define kTeacherAssStat @"AssessmentStatus"

#define kTeacherNameDefault    @"Jane Doe"
#define kTeacherEmailDefault   @"Jane.Doe@gmail.com"
#define kTeacherGradeDefault   @"1st"
#define kTeacherPhoneDefault   @"(847)353-3554"
#define kTeacherImageDefault   @"teacher.image"
#define kTeacherAssStatDefault @"B"

// All Keys formatted.
#define kTeacherSettingsKeys [NSDictionary dictionaryWithObjectsAndKeys: kTeacherName, kTeacherEmail, kTeacherGrade, kTeacherPhone, kTeacherImage, nil]

// All Default Values formatted
#define kTeacherSettingsDefaultValues [NSDictionary dictionaryWithObjectsAndKeys: kTeacherNameDefault, kTeacherEmailDefault, kTeacherGradeDefault, kTeacherPhoneDefault, kTeacherImageDefault, nil]