//
//  PhotoGalleryViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "ArtManager.h"
#import "PhotoManager.h"
#import "PhotoCell.h"

static NSString* NotificationNamePhotoChange=@"PhotoChangeNotification";
static NSString* const NotificationNamePaintRequired=@"PaintRequiredNotification";

@interface PhotoGalleryViewController ()
-(void) reloadTableData;
@end

@implementation PhotoGalleryViewController
@synthesize artManager = _artManager;
@synthesize photoManager = _photoManager;
@synthesize editButton = _editButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationController.navigationBar.tintColor = [UIColor orangeColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handlePhotoChange:) name:NotificationNamePhotoChange object:nil];
    
}

-(void)handlePhotoChange:(NSNotification*)obj
{
    [self reloadTableData];
}

- (void)viewDidUnload
{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    [self.photoManager removeObserver:self forKeyPath:KVOPhotoChangeKey];
    
    self.artManager=nil;
    self.photoManager=nil;
    
    [self setEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger row_count = self.photoManager.photos.count;
    return row_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier=@"Photo Cell";
    PhotoCell* cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PhotoEntry* entry=[self.photoManager.photos objectAtIndex:indexPath.row];
    [cell configureWithPhotoEntry: entry];
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.photoManager removePhotoAtIndex:indexPath.row];
        [self reloadTableData];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationNamePaintRequired object:[NSNumber numberWithUnsignedInteger:indexPath.row]];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) reloadTableData
{
    [self.tableView reloadData];
}

- (IBAction)doCancel:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doEdit:(id)sender 
{
    if([self.tableView isEditing])
    {
        self.editButton.title=@"Edit";
        [self.tableView setEditing:NO];
    }
    else {
        self.editButton.title=@"Done";
        [self.tableView setEditing:YES];
    }
    
}

@end
