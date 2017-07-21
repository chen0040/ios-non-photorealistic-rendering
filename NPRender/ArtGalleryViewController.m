//
//  ArtGalleryViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtGalleryViewController.h"
#import "ArtManager.h"
#import "PhotoManager.h"
#import "ArtCell.h"
#import "TakePhotoViewController.h"
#import "WebGalleryViewController.h"
#import "PhotoGalleryViewController.h"
#import "CanvasViewController.h"
#import "NPRAppDelegate.h"
#import "EnlargedArtViewController.h"
#import "ArtEntry.h"
#import "PhotoEntry.h"
#import <MobileCoreServices/UTCoreTypes.h>

static NSString* const NotificationNamePaintRequired=@"PaintRequiredNotification";
static NSString* const NotificationNameViewRequired=@"ArtViewRequiredNotification";
static NSString* const NotificationNameArtChange=@"ArtChangeNotification";
static NSString* const DetailViewArtSegueIdentifier=@"Push Detail Art";
static NSString* const ModalViewTakePhotoSegueIdentifier=@"Modal View Take Photo";
static NSString* const ModalViewGetDownloadImageSegueIdentifier=@"Modal View Download";
static NSString* const ModalViewCachedPhotosSegueIdentifier=@"Modal View Cached Photos";
static NSString* const PushViewPaintSegueIdentifier=@"Push Photo Paint";

@interface ArtGalleryViewController ()
-(void) reloadTableData;
-(void) artManagerChanged:(NSDictionary*)change;
@end

@implementation ArtGalleryViewController
@synthesize artManager = _artManager;
@synthesize photoManager = _photoManager;
@synthesize bannerView=_bannerView;
@synthesize tableView=_tableView;
@synthesize contentView=_contentView;
//@synthesize progressView=_progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];

    self.artManager=[[ArtManager alloc] init];
    self.photoManager=[[PhotoManager alloc] init];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /*
    self.progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.progressView.hidesWhenStopped=YES;
    self.progressView.frame = self.view.frame; //CGRectMake(0.0, 0.0, 200.0, 200.0);
    self.progressView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    CGSize dim=self.view.frame.size;
    CGFloat dim_width=dim.width/2;
    CGFloat dim_height=dim.height/2;
    
	self.progressView.center = CGPointMake(dim_width, dim_height); //self.view.center; //
    [self.view addSubview:self.progressView];*/
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIImageView *tempImg = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [tempImg setImage:[UIImage imageNamed:@"wood2.jpg"]];
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"])
    {
        [tempImg setContentMode:UIViewContentModeTop];
    }
    else 
    {
        [tempImg setContentMode:UIViewContentModeScaleToFill];
    }
        
    [self.tableView setBackgroundView:tempImg];
    
    [self.artManager addObserver:self forKeyPath:KVOArtChangeKey options:NSKeyValueObservingOptionNew context:nil];
    
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleArtChange:) name:NotificationNameArtChange object:nil];
    [nc addObserver:self selector:@selector(handlePaintRequired:) name:NotificationNamePaintRequired object:nil];
    [nc addObserver:self selector:@selector(handleViewRequired:) name:NotificationNameViewRequired object:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

-(void)handleViewRequired: (NSNotification*)obj
{
    [self performSegueWithIdentifier:DetailViewArtSegueIdentifier sender:obj.object];
}

-(void)handleArtChange: (NSNotification*)obj
{
    [self reloadTableData];
}

-(void)handlePaintRequired: (NSNotification*)obj
{
    [self performSegueWithIdentifier:PushViewPaintSegueIdentifier sender:obj.object];
}

- (IBAction)doAdd:(id)sender 
{
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"Select a Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles: @"My album", @"Cache", @"Download", nil];
    [sheet showInView:self.view];
}

- (void)viewDidUnload
{    
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    [self.artManager removeObserver:self forKeyPath:KVOArtChangeKey];
    
    self.artManager=nil;
    self.photoManager=nil;
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
    NSInteger row_count = self.artManager.arts.count;
    return row_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier=@"Art Cell";
    ArtCell* cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    ArtEntry* entry=[self.artManager.arts objectAtIndex:indexPath.row];
    [cell configureWithArtEntry: entry];
   
    
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
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSInteger row_count = self.artManager.arts.count;
        if(indexPath.row < row_count)
        {
            [self.artManager removeArtAtIndex:indexPath.row];
        }
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
    /*
    if (self.popover) 
    {
		[self.popover dismissPopoverAnimated:YES];
		self.popover = nil;
		//[button setTitle:@"Show Popover" forState:UIControlStateNormal];
	} 
    else 
    {
		ArtDetailViewController *contentViewController = [[ArtDetailViewController alloc] init];
        
        contentViewController.artManager=self.artManager;
        contentViewController.photoManager=self.photoManager;
        contentViewController.selectedIndex=indexPath.row;
		
		self.popover = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        
        CGRect rect=[self.tableView cellForRowAtIndexPath:indexPath].frame;
        rect.size.width=100;
        rect.origin.y+=70;
        //rect.origin.x+=10;
        
		[self.popover presentPopoverFromRect:rect
                                      inView:self.tableView
                    permittedArrowDirections:UIPopoverArrowDirectionDown
                                    animated:YES];
	}*/
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ModalViewTakePhotoSegueIdentifier])
    {
        TakePhotoViewController* controller=segue.destinationViewController;
        controller.artManager=self.artManager;
        controller.photoManager=self.photoManager;
    }
    else if([segue.identifier isEqualToString:ModalViewCachedPhotosSegueIdentifier])
    {
        PhotoGalleryViewController* controller=segue.destinationViewController;
        controller.artManager=self.artManager;
        controller.photoManager=self.photoManager;
    }
    else if([segue.identifier isEqualToString:ModalViewGetDownloadImageSegueIdentifier])
    {
        WebGalleryViewController* controller=segue.destinationViewController;
        controller.artManager=self.artManager;
        controller.photoManager=self.photoManager;
    }
    else if([segue.identifier isEqualToString:PushViewPaintSegueIdentifier])
    {
        CanvasViewController* controller=segue.destinationViewController;
        controller.photoManager=self.photoManager;
        controller.artManager=self.artManager;
        controller.selectedIndex=[sender intValue];
    }
    else if([segue.identifier isEqualToString:DetailViewArtSegueIdentifier])
    {
        EnlargedArtViewController* controller=segue.destinationViewController;
        controller.artManager=self.artManager;
        controller.photoManager=self.photoManager;
        controller.selectedIndex=[self.tableView indexPathForSelectedRow].row;
    }
}

-(void) reloadTableData
{
    [self.tableView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:KVOArtChangeKey])
    {
        [self artManagerChanged:change];
    }
}

-(void) artManagerChanged:(NSDictionary *)change
{
    NSNumber* value=[change objectForKey:NSKeyValueChangeKindKey];
    NSIndexSet* indexes=[change objectForKey:NSKeyValueChangeIndexesKey];
    NSMutableArray* indexPaths=[[NSMutableArray alloc] initWithCapacity:[indexes count]];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger indexValue, BOOL *stop) {
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow: indexValue inSection: 0];
        [indexPaths addObject:indexPath];
    }];
    
    switch([value intValue])
    {
        case NSKeyValueChangeInsertion:
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSKeyValueChangeRemoval:
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSKeyValueChangeSetting:
            break;
        default:
            [NSException raise: NSInvalidArgumentException format:@"Change kind value %d not recognized", [value intValue]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker 
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) 
    {
        UIImage* img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        PhotoEntry* photo = [[PhotoEntry alloc] init];
    
        NSData* jpegData=UIImageJPEGRepresentation(img, 1.0);
        [jpegData writeToFile:photo.fullPath atomically:NO];
    
        //UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);    
    
        [jpegData writeToFile:[photo fullPath] atomically:NO];
    
        [self.photoManager addPhoto:photo];
        
        NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
        [nc postNotificationName:NotificationNamePaintRequired object:[NSNumber numberWithUnsignedInteger:0]];
    }
    
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentModalViewController: mediaUI animated: YES];
    return YES;
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self performSegueWithIdentifier:ModalViewTakePhotoSegueIdentifier sender:self];
    }
    else if(buttonIndex==1)
    {
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
    else if(buttonIndex==2)
    {
        [self performSegueWithIdentifier:ModalViewCachedPhotosSegueIdentifier sender:self];
    }
    else if(buttonIndex==3)
    {
        [self performSegueWithIdentifier:ModalViewGetDownloadImageSegueIdentifier sender:self];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)layoutAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.contentView.frame = contentFrame;
        [self.contentView layoutIfNeeded];
        _bannerView.frame = bannerFrame;
    }];
}


- (void)showBannerView:(ADBannerView *)bannerView animated:(BOOL)animated
{
    _bannerView = bannerView;
    //self.tableView.tableHeaderView=_bannerView;
    [self.view addSubview: _bannerView];
    
    [self layoutAnimated:animated];
}

- (void)hideBannerView:(ADBannerView *)bannerView animated:(BOOL)animated
{
    _bannerView = nil;
    self.tableView.tableHeaderView=nil;
    [self layoutAnimated:animated];
}

@end
