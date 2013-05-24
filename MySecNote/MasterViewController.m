//
//  MasterViewController.m
//  MySecNote
//
//  Created by forrest on 13-4-21.
//  Copyright (c) 2013年 DFA. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "MasterViewController.h"

#import "DetailViewController.h"
#import "AppSetting.h"
#import "GCPINViewController.h"

@interface MasterViewController ()<UIGestureRecognizerDelegate , UISearchBarDelegate , UISearchDisplayDelegate >{
    UIImageView *lockImageView ;
}

@property (nonatomic,strong) NSMutableArray *searchResults;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController
@synthesize searchResults;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.view == lockImageView) {
        return YES;
    }
    return NO;
}

- (void)lockMe{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.frame = CGRectMake(0., self.view.frame.size.height, self.view.frame.size.width, 44.);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" < " style:UIBarButtonItemStylePlain target:nil action:nil];
//        
//    [[self navigationItem] setBackBarButtonItem:backButton];

    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];

    self.searchResults = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
    [self.tableView reloadData];
    

	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
        
    if ([AppSetting haveSetupPassword] == NO ) {
        GCPINViewController *PIN = [[GCPINViewController alloc]
                                    initWithNibName:nil
                                    bundle:nil
                                    mode:GCPINViewControllerModeCreate];
        PIN.messageText = @"Create Password";
        PIN.errorText = @"The passwords do not match";
        PIN.verifyBlock = ^(NSString *code) {
            DLog(@"setting code: %@", code);
            [AppSetting savePassword:code emailAddress:nil /*self.emailField.text*/ ];
            [AppSetting setupPassword];
            return YES;
        };
        //[PIN presentFromViewController:self animated:YES];
        [self presentViewController:PIN animated:NO
    completion:^{
        //
    }];
        
    }
//    self.navigationController.navigationBarHidden = YES;
//    UIView *splashView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    splashView.backgroundColor = [UIColor blueNoteColor];
//    [self.view addSubview:splashView];

    
}

- (void)clickInfo:(id)sender{
    DLog(@"click");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.

    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}

#pragma mark - Table View

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.searchResults count];
    }
	else
	{
//        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//        return [sectionInfo numberOfObjects];
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:26]];
        //cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    [self configureCell:cell atIndexPath:indexPath forSearchTableView:(tableView == self.searchDisplayController.searchResultsTableView)];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = nil;

    if (tableView == self.searchDisplayController.searchResultsTableView ) {
        object = [self.searchResults objectAtIndex:indexPath.row];
    }else{
        object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController =  [[DetailViewController alloc] init];//[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
        self.detailViewController.detailItem = object;
//        [self.navigationController pushViewController:self.detailViewController animated:YES];
//        self.detailViewController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        self.detailViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentModalViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}
#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	DLog(@"Previous Search Results were removed.");    
	[self.searchResults removeAllObjects];
    
	for ( id note in [self.fetchedResultsController fetchedObjects])
	{
        NSString * title = [((NSManagedObject*)note) valueForKey:@"title"];
		if ([scope isEqualToString:@"All"] || [title isEqualToString:scope])
		{
            if (title) {
                
                NSComparisonResult result = [title compare:searchText
                                                   options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                                     range:NSMakeRange(0, [searchText length])];
                if (result == NSOrderedSame)
                {
                    DLog(@"Adding role.name '%@' to searchResults as it begins with search text '%@'", title, searchText);
                    [self.searchResults addObject:note];
                }
            }
			
		}
	}
    
    DLog(@"searched [ %d ] %@", [self.searchResults count] ,self.searchResults);
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    [UIView animateWithDuration:.1 animations:^{
//        lockImageView.alpha = 0;
//    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [UIView animateWithDuration:.1 animations:^{
//        lockImageView.alpha = 1.;
//    }];
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    DLog(@"%s",__PRETTY_FUNCTION__);
    [self filterContentForSearchText:searchString scope:@"All"];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    DLog(@"%s",__PRETTY_FUNCTION__);
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    return YES;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forSearchTableView:(BOOL)isSearchedView
{
    NSManagedObject *object = nil ;
    if (isSearchedView) {
        object = (NSManagedObject*)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    cell.textLabel.text = [[object valueForKey:@"title"] description];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    [df setDateFormat:@"M/d/yyyy hh:mm a"];
    //cell.detailTextLabel.text =  [df stringFromDate:[object valueForKey:@"timeStamp"]];//[[object valueForKey:@"timeStamp"] description];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;

}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"title"] description];
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setTimeZone:[NSTimeZone localTimeZone]];
//    [df setDateFormat:@"M/d/yyyy hh:mm a"];
    //cell.detailTextLabel.text =  [df stringFromDate:[object valueForKey:@"timeStamp"]];//[[object valueForKey:@"timeStamp"] description];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self becomeFirstResponder];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [self resignFirstResponder];
//    [super viewWillDisappear:animated];
//}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.subtype == UIEventSubtypeMotionShake) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginView object:nil];
    }
}

@end
