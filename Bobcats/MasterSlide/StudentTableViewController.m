//
//  StudentTableViewController.m
//  Bobcats
//
//  Created by Burchfield, Neil on 1/27/13.
//
//

#import "StudentTableViewController.h"
#import "Student.h"
#import "AddStudentView.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomTableView.h"
#import "AboutViewController.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@implementation StudentTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nil bundle:nil];
	self.title = NSLocalizedString(@"Students",nil);
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    detailViewController = [[DetailViewController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableViewData:)
                                                 name:@"ReloadStudentTableView"
                                               object:nil];
    
    self.tableView.frame = CGRectMake(self.tableView.bounds.origin.x,
                                      self.tableView.bounds.origin.y,
                                      self.tableView.bounds.size.width,
                                      self.tableView.bounds.size.height);
    
    self.tableView.contentSize = CGSizeMake(self.tableView.bounds.size.width, self.tableView.bounds.size.height + 200);
	self.tableView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
	self.clearsSelectionOnViewWillAppear = YES;
	self.contentSizeForViewInPopover = CGSizeMake(400.0, 1024.0);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudent:)];
	
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)reloadTableViewData:(NSNotification *)notif 
{
    [self.tableView reloadData];
    NSLog(@"[StudentTVController]: TableView Reloaded");
}


- (void)addStudent:(id)sender
{
	AddStudentView *vc = [[AddStudentView alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:navController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [appDelegate.studentSectionHeaders objectAtIndex:section];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [appDelegate.studentArraySectioned count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[appDelegate.studentArraySectioned objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*   Instantiate the reversed array within the student class object */
    Student * student = (Student *)[[appDelegate.studentArraySectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
    }
    
    /*    Set Custom Background for favorites Employee Cell View */
    cell.textLabel.text = [student fullName];
    cell.imageView.image = [UIImage imageNamed:@"person.png"];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)deleteEmployee:(NSString *)uid
{
    sqlite3 * database;
    
    if (sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char * deleteSql = "DELETE FROM students WHERE lastName = ?";
        sqlite3_stmt * compiledStatement;
        
        if (sqlite3_prepare_v2(database, deleteSql, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement, 1, [uid UTF8String], -1, SQLITE_TRANSIENT);            
            sqlite3_reset(compiledStatement);
        }
        
        if (sqlite3_step(compiledStatement) != SQLITE_DONE)
        {
            NSLog(@"Save Error: %s", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(database);
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student * student = (Student *)[[appDelegate.studentArraySectioned objectAtIndex:indexPath.section]
                                                                            objectAtIndex:indexPath.row];

        [self deleteEmployee:[student lastName]];

        [appDelegate reloadData];
        
        [self.tableView reloadData];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/* Set section index titles */
- (NSArray *)sectionIndexTitlesForTableView: (UITableView *)tableView
{
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
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

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight - 2)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *bgLayer = [self blueGradient];
    bgLayer.frame = headerView.bounds;
    [headerView.layer insertSublayer:bgLayer atIndex:0];
    [headerView.layer setMasksToBounds:YES];
    
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.5f, tableView.bounds.size.width - 10, 18)];
    headerText.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    headerText.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    headerText.textColor = [UIColor whiteColor];
    headerText.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerText];
    
    return headerView;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:indexPath forKey:@"messageTotal"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateContent" object:self userInfo:userInfo];
}


@end
















