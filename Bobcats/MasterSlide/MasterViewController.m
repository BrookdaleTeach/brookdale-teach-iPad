//
//  RootViewController.m
//  DocSets
//
//  Created by Ole Zorn on 05.12.10.
//  Copyright 2010 omz:software. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AboutViewController.h"
#import "StudentTableViewController.h"
#import "CustomTableView.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
#define LANDSCAPE_PADDING 44
#define FIRST_USE_ALERT_TAG		1

@implementation MasterViewController

@synthesize detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nil bundle:nil];
	self.title = NSLocalizedString(@"Home",nil);
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(docSetsChanged:) name:DocSetDownloadManagerUpdatedDocSetsNotification object:nil];
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
	self.clearsSelectionOnViewWillAppear = YES;
	self.contentSizeForViewInPopover = CGSizeMake(400.0, 1024.0);
	self.tableView.rowHeight = 64.0;
    
    headers = [[NSArray alloc] initWithObjects:@"Math", @"Reading", @"Science", @"Behavior", nil];
    images = [[NSArray alloc] initWithObjects:@"bar-chart.png", @"book.png", @"beaker.png", @"scales.png", nil];

	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
	UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[aboutButton setTitle:NSLocalizedString(@"About Bobcats", nil) forState:UIControlStateNormal];
	[aboutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	aboutButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
	aboutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	aboutButton.showsTouchWhenHighlighted = YES;
	[aboutButton setFrame:CGRectInset(footerView.bounds, 50, 20)];
	[aboutButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
	[footerView addSubview:aboutButton];
	self.tableView.tableFooterView = footerView;
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == FIRST_USE_ALERT_TAG) {
		if (buttonIndex == alertView.cancelButtonIndex) return;
//		[self addDocSet:nil];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return YES;
	}
	return UIInterfaceOrientationIsLandscape(interfaceOrientation) || (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showInfo:(id)sender
{
	//TODO: Show info dialog with libxar license
	AboutViewController *vc = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		navController.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	[self.view.window.rootViewController presentModalViewController:navController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"View All";
    else
        return @"Subjects";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return [headers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if (indexPath.section == 0)
            cell = [self getCellContentViewForPassword:CellIdentifier :indexPath.row :10 + indexPath.row :50 + indexPath.row];
        else if (indexPath.section == 1)
            cell = [self getCellContentViewForPassword:CellIdentifier :100 + indexPath.row :105 + indexPath.row :150 + indexPath.row];
    }
       
    if (indexPath.section == 0)
    {
        UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, 200, 30)];
        formTitleField.textColor = [UIColor blackColor];
        formTitleField.text = @"Class List";
        formTitleField.backgroundColor = [UIColor clearColor];
        formTitleField.textAlignment = NSTextAlignmentLeft;
        formTitleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
        [cell.contentView addSubview:formTitleField];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 1);
        imageView.layer.shadowRadius = 4.0f;
        imageView.layer.masksToBounds = NO;
        
        UIImage *im = [UIImage imageNamed:@"DocSet.png"];
        imageView.frame = CGRectMake(24, 11, im.size.width * 1.15, im.size.height * 1.15);
        imageView.image = im;
        [cell addSubview:imageView];//210	206	203
        
        UILabel *sideBuffer = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, 6, cell.bounds.size.height)];
        sideBuffer.layer.cornerRadius = 3.5f;
        CAGradientLayer *bgLayer = [self blueGradient];
        bgLayer.frame = sideBuffer.bounds;
        [sideBuffer.layer insertSublayer:bgLayer atIndex:0];

        [cell.contentView addSubview:sideBuffer];
    }
    else
    {
        UILabel *mainContentLabel = (UILabel *)[cell viewWithTag:100 + indexPath.row];
        mainContentLabel.text = [headers objectAtIndex:indexPath.row];
        
        UIImageView *mainContentValueImage = (UIImageView *)[cell viewWithTag:105 + indexPath.row];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
        mainContentValueImage.frame = CGRectMake(24, 15, image.size.width * 1.15, image.size.height * 1.15);
        mainContentValueImage.image = image;
        
        UILabel *sideBuffer = (UILabel *)[cell viewWithTag:150 + indexPath.row];
        
        CAGradientLayer *bgLayer = nil;
        if (indexPath.row == 0)
            bgLayer = [self customGradient:[UIColor colorWithRed:(237/255.0) green:(90/255.0) blue:(75/255.0) alpha:1.0]
                                          :[UIColor colorWithRed:(233/255.0)  green:(65/255.0)  blue:(58/255.0)  alpha:1.0]];	
        else if (indexPath.row == 1)
            bgLayer = [self customGradient:[UIColor colorWithRed:(7/255.0) green:(175/255.0) blue:(228/228) alpha:1.0] //7	175	228
                                          :[UIColor colorWithRed:(0/255.0)  green:(163/255.0)  blue:(223/255.0)  alpha:1.0]]; //0	163	223
        else if (indexPath.row == 2)
            bgLayer = [self customGradient:[UIColor colorWithRed:(80/255.0) green:(185/255.0) blue:(65/255.0) alpha:1.0]
                                          :[UIColor colorWithRed:(65/255.0)  green:(162/255.0)  blue:(52/255.0)  alpha:1.0]];
        else if (indexPath.row == 3)
            bgLayer = [self customGradient:[UIColor colorWithRed:(249/255.0) green:(121/255.0) blue:(55/255.0) alpha:1.0] //249	121	55	
                                          :[UIColor colorWithRed:(232/255.0)  green:(85/255.0)  blue:(19/255.0)  alpha:1.0]]; // 232	85	19	
        bgLayer.frame = sideBuffer.bounds;
        [sideBuffer.layer insertSublayer:bgLayer atIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (TableViewCell *) getCellContentViewForPassword:(NSString *)cellIdentifier :(int)headtag :(int)imageTag :(int)layerTag{
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    
    TableViewCell *cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.tableViewBackgroundColor = self.tableView.backgroundColor;
    cell.gradientStartColor = start_color;
    cell.gradientEndColor = end_color;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setFrame:CellFrame];
    
    UILabel *formTitleField = [[UILabel alloc] initWithFrame:CGRectMake(85, 15, 116, 30)];
    formTitleField.textColor = [UIColor blackColor];
    formTitleField.backgroundColor = [UIColor clearColor];
    formTitleField.textAlignment = NSTextAlignmentLeft;
    formTitleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    formTitleField.tag = headtag;
    [cell.contentView addSubview:formTitleField];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    imageView.tag = imageTag;
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    imageView.layer.shadowRadius = 4.0f;
    imageView.layer.masksToBounds = NO;
    [cell addSubview:imageView];
    
    
    UILabel *sideBuffer = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, 6, cell.bounds.size.height)];
    sideBuffer.layer.cornerRadius = 3.5f;
    sideBuffer.tag = layerTag;
    [cell.contentView addSubview:sideBuffer];
    
    
    return cell;
} /* getCellContentViewForPassword */

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


- (CAGradientLayer*) customGradient :(UIColor *)first :(UIColor *)second {
    
    NSArray *colors = [NSArray arrayWithObjects:(id)first.CGColor, second.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight - 2)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *bgLayer = [self blueGradient];
    bgLayer.frame = headerView.bounds;
    [headerView.layer insertSublayer:bgLayer atIndex:0];
    
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.5f, tableView.bounds.size.width - 10, 18)];
    headerText.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    headerText.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    headerText.textColor = [UIColor whiteColor];
    headerText.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerText];
    
    return headerView;
}

- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation {
    
    [self.tableView reloadData];
    return(interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) { }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    StudentTableViewController *stvc = [[StudentTableViewController alloc] init];
	[self.navigationController pushViewController:stvc animated:YES];
    stvc.title = [headers objectAtIndex:indexPath.row];
}

@end

