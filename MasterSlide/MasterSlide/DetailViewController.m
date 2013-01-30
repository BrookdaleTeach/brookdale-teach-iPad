//
//  DetailViewController.m
//  DocSets
//
//  Created by Ole Zorn on 05.12.10.
//  Copyright 2010 omz:software. All rights reserved.
//

#import "DetailViewController.h"
#import "SwipeSplitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MathAssessmentTableViewController.h"

#define EXTERNAL_LINK_ALERT_TAG	1
#define LANDSCAPE_PADDING 55

@interface DetailViewController ()

- (void)updateBackForwardButtons;
- (void)dismissOutline:(id)sender;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nil bundle:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	outlineButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Outline.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showOutline:)];
	outlineButtonItem.width = 32.0;
	outlineButtonItem.enabled = NO;
	
	backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
	backButtonItem.enabled = NO;
	forwardButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
	forwardButtonItem.enabled = NO;
	bookmarksButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showBookmarks:)];
	bookmarksButtonItem.enabled = NO;
	actionButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
	actionButtonItem.enabled = NO;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		UIBarButtonItem *browseButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DocSets", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showLibrary:)];
		UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		spaceItem.width = 24.0;
		portraitToolbarItems = [NSArray arrayWithObjects:browseButtonItem, spaceItem, backButtonItem, spaceItem, forwardButtonItem, flexSpace, bookmarksButtonItem, spaceItem, actionButtonItem, spaceItem, outlineButtonItem, nil];
		landscapeToolbarItems = [NSArray arrayWithObjects:backButtonItem, spaceItem, forwardButtonItem, flexSpace, bookmarksButtonItem, spaceItem, actionButtonItem, spaceItem, outlineButtonItem, nil];
	}
    
    tableViewHeaders = [[NSArray alloc] initWithObjects:@"Phone", @"Address", @"Parent First", @"Parent Last", @"Parent Email", @"Parent Phone", @"Relationship", nil];

    studentContentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [studentContentTableView setDelegate:self];
    [studentContentTableView setDataSource:self];
    UIView *clearBackground = [[UIView alloc] initWithFrame:CGRectMake(200, 400, 800, 1200)];
    clearBackground.backgroundColor = [UIColor clearColor];
    [studentContentTableView setBackgroundView:clearBackground];
    [self.view addSubview:studentContentTableView];

	return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && self.navigationController.toolbarHidden) {
		[self.navigationController setToolbarHidden:NO animated:animated];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveTestNotification:)
     name:@"UpdateContent"
     object:nil];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"UpdateContent"])
    {
        NSDictionary* userInfo = [notification userInfo];
        NSIndexPath * indexPath = [userInfo objectForKey:@"messageTotal"];
        
        if ( indexPath.section >= 0 && indexPath.row >= 0 )
            [self loadContentDataView:indexPath.section :indexPath.row];
    }
}

- (void)loadView
{
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 34)];
	titleLabel.textColor = [UIColor colorWithRed:0.443 green:0.471 blue:0.502 alpha:1.0];
	titleLabel.shadowColor = [UIColor whiteColor];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	
    topToolbarHeight = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 44.0 : 0.0;
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.scalesPageToFit = YES;//([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	
	webView.delegate = self;
	[self.view addSubview:webView];
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, topToolbarHeight)];
		toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		toolbar.items = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? portraitToolbarItems : landscapeToolbarItems;
		[self.view addSubview:toolbar];
		titleLabel.center = CGPointMake(toolbar.bounds.size.width * 0.5, toolbar.bounds.size.height * 0.5);
		[toolbar addSubview:titleLabel];
	} else {
		UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		spaceItem.width = 24.0;
		self.toolbarItems = [NSArray arrayWithObjects:bookmarksButtonItem, flexSpace, backButtonItem, spaceItem, forwardButtonItem, flexSpace, actionButtonItem, nil];
		self.navigationItem.rightBarButtonItem = outlineButtonItem;
	}
	
	coverView = [[UIView alloc] initWithFrame:webView.frame];
	coverView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whitey.png"]];
	coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:coverView];
    
    [self allocContentDataView];
}


- (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}


- (void)allocContentDataView
{
    // Set Student Shelf
    shelfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width + LANDSCAPE_PADDING, self.view.bounds.size.height / 8)];
    shelfView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    shelfView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    shelfView.layer.masksToBounds = YES;
    shelfView.alpha = .9;
    CAGradientLayer *bgLayer = [self blueGradient];
    bgLayer.frame = shelfView.bounds;
    [shelfView.layer insertSublayer:bgLayer atIndex:0];
    shelfView.layer.cornerRadius = 1;
    shelfView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    shelfView.layer.shadowOpacity = 1.0f;
    shelfView.layer.shadowRadius = 4.0;
    shelfView.layer.shadowOffset = CGSizeMake(0, 4);
    shelfView.hidden = YES;
    [self.view addSubview:shelfView];
    
    // Set Student Tableview frame
    [studentContentTableView setFrame:CGRectMake(0, shelfView.bounds.size.height,
                                                 self.view.bounds.size.width - 45, 800)];

    studentContentTableView.hidden = YES;
    
    // Set Student Image
    studentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20,
                                                                     88, 88)];
    [self.view addSubview:studentImageView];
    
    // Set Student Name Label
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 300, 23)];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor lightTextColor]];
    [self.view addSubview:nameLabel];
    
    // Set Student Email Label
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 49, 300, 19)];
    [emailLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f]];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextColor:[UIColor lightTextColor]];
    [self.view addSubview:emailLabel];
    
    // Set Student UID Label
    uidLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 71, 300, 19)];
    [uidLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f]];
    [uidLabel setBackgroundColor:[UIColor clearColor]];
    [uidLabel setTextColor:[UIColor lightTextColor]];
    [self.view addSubview:uidLabel];
}

- (void)loadContentDataView:(int)section :(int)row
{
    student = (Student *)[[appDelegate.studentArraySectioned objectAtIndex:section] objectAtIndex:row];
    
    if (shelfView.hidden)
        shelfView.hidden = !shelfView.hidden;
    
    if (studentContentTableView.hidden)
        studentContentTableView.hidden = !studentContentTableView.hidden;
    
    shelfView.alpha = 0.09f;
    studentContentTableView.alpha = 0.0f;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = .5f;
    [shelfView.layer addAnimation:animation forKey:nil];
    shelfView.alpha = 1.0f;
    [studentContentTableView.layer addAnimation:animation forKey:nil];
    studentContentTableView.alpha = 1.0f;

    // Set Student Image
    if (![student image])
        studentImageView.image = [UIImage imageNamed:[student image]];
    else
        studentImageView.image = [UIImage imageNamed:@"person.png"];
    
    // Set Student Name Label
    [nameLabel setText:[student fullName]];

    // Set Student Email Label
    [emailLabel setText:[student email]];
    
    // Set Student UID Label
    [uidLabel setText:[student uid]];
    
    [tableViewContent removeAllObjects];
    tableViewContent = [[NSMutableArray alloc] initWithObjects:
                        [student phone],
                        [student address],
                        [student parent_firstName],
                        [student parent_lastName],
                        [student parent_email],
                        [student parent_phone],
                        [student relationship], nil];

    [studentContentTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return tableViewHeaders.count;
    else return 2;
}
// RootViewController.m
- (UITableViewCell *) getCellContentViewForPassword:(NSString *)cellIdentifier :(int)headtag :(int)contentTag {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setFrame:CellFrame];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(6, 12, 116, 20)];
    formTitleField.textColor = [UIColor darkGrayColor];
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentRight;
    formTitleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    formTitleField.tag = headtag;
    [cell.contentView addSubview:formTitleField];
    
    UILabel *formContentField = [[UILabel alloc] initWithFrame:CGRectMake(180, 9, 475, 30)];
    formContentField.textColor = [UIColor darkGrayColor];
    formContentField.backgroundColor = [UIColor clearColor];
    formContentField.textAlignment = NSTextAlignmentRight;
    formContentField.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    formContentField.tag = contentTag;
    [cell addSubview:formContentField];
    
    UILabel *vLine = [[UILabel alloc] initWithFrame:CGRectMake(132, 1, 1, cell.frame.size.height - 18)];
    vLine.backgroundColor = [UIColor colorWithRed:173.0f/255.0f green:175.0f/255.0f blue:179.0f/255.0f alpha:.7f];
    [cell.contentView addSubview:vLine];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
} /* getCellContentViewForPassword */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [studentContentTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if ( indexPath.section == 0 )
    {
        if (cell == nil)
            cell = [self getCellContentViewForPassword :cellIdentifier :indexPath.row :10 + indexPath.row];
        
        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:indexPath.row];
        mainContentLabel.text = [tableViewHeaders objectAtIndex:indexPath.row];
        UILabel *mainContentValueLabel = (UILabel *)[cell viewWithTag:10 + indexPath.row];
        mainContentValueLabel.text = [tableViewContent objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0)
        {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
            cell.textLabel.text = [NSString stringWithFormat:@"              %@", [tableViewHeaders objectAtIndex:indexPath.row]];
        }
    }
    else if (indexPath.section == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(6, 12, 600, 20)];
        formTitleField.textColor = [UIColor darkGrayColor];
        formTitleField.backgroundColor = [UIColor clearColor];
        formTitleField.textAlignment = NSTextAlignmentCenter;
        formTitleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
        
        if (indexPath.row)
            formTitleField.text = @"Modify Math Test Scores";
        else
            formTitleField.text = @"Modify Math Assessment Report";
        
        [cell.contentView addSubview:formTitleField];

    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1)
        return @"math";
    else
        return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ( indexPath.section == 1)
    {
        MathAssessmentTableViewController *asvc = [[MathAssessmentTableViewController alloc] init];
        [self.navigationController pushViewController:asvc animated:YES];

    }
}

- (void)docSetWillBeDeleted:(NSNotification *)notification
{

}

- (void)keyboardWillShow:(NSNotification *)notification
{

}

- (void)keyboardWillHide:(NSNotification *)notification
{

}

- (void)goBack:(id)sender
{

}

- (void)goForward:(id)sender
{

}

- (void)updateBackForwardButtons
{
}

- (void)showOutline:(id)sender
{
}

- (void)dismissOutline:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)showActions:(id)sender
{

}


- (void)showBookmarks:(id)sender
{

}

- (void)showLibrary:(id)sender
{
}



- (void)openURL:(NSURL *)URL withAnchor:(NSString *)anchor
{
	if (anchor) {
		NSURL *URLWithAnchor = [NSURL URLWithString:[[URL absoluteString] stringByAppendingFormat:@"#%@", anchor]];
		[webView loadRequest:[NSURLRequest requestWithURL:URLWithAnchor]];
	} else {
		[webView loadRequest:[NSURLRequest requestWithURL:URL]];
	}
	[self updateBackForwardButtons];

}

#pragma mark -

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
//		[toolbar setItems:portraitToolbarItems animated:YES];
//	} else {
//		[toolbar setItems:landscapeToolbarItems animated:YES];
//	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return YES;
	}
	return UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
