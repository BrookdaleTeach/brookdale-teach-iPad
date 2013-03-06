//
//  DetailViewHeaderImports.h
//  Bobcats
//
//  Created by Burchfield, Neil on 2/27/13.
//
//

// Too many imports/defs to display on main class

// Imports
#import "DetailViewController.h"
#import "SwipeSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "MathAssessmentTableViewController.h"
#import "ReadingAssesmentViewController.h"
#import "WritingAssesmentViewController.h"
#import "BehavioralAssesmentViewController.h"

#import "MathTestTableViewController.h"
#import "ReadingTestTableViewController.h"
#import "WritingTestTableViewController.h"
#import "BehavioralTestTableViewController.h"

#import "MGBox.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"

#import <AddressBook/AddressBook.h>

#import "MapKitDisplayViewController.h"

#import "EditUser.h"

#import "PDFRenderer.h"
#import "PrintingDefinitions.h"

#import "MathAssessmentModel.h"
#import "ReadingAssessmentModel.h"
#import "WritingAssessmentModel.h"
#import "BehavioralAssessmentModel.h"
// Imports//



// Definitions
#define HEADER_FONT               [UIFont fontWithName:@"HelveticaNeue" size:18]
#define ROW_SIZE                  (CGSize) {666, 44 }
#define BOX_LANDSCAPE             (CGRect) {12, 135, 768, 960 }
#define BOX_PORTRAIT              (CGRect) {40, 150, 704, 960 }
#define kEmailActionSheet         990
#define kContactActionSheet       991
#define kCalendarEventActionSheet 992
// Definitions //