//
//  WebGalleryViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebGalleryViewController.h"
#import "NPRAppDelegate.h"
#import "ArtManager.h"
#import "PhotoManager.h"
#import "PhotoEntry.h"
#import "ArtEntry.h"

static NSString* const NotificationNamePaintRequired=@"PaintRequiredNotification";

@interface WebGalleryViewController ()

@end

@implementation WebGalleryViewController
@synthesize myWebView;
@synthesize currentRequestedURL=_currentRequestedURL;
@synthesize artManager = _artManager;
@synthesize photoManager = _photoManager;

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
    [self.myWebView setDelegate:self];
    NSURLRequest* request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.czcodezone.com/npr/gallery.php"]];
    [self.myWebView loadRequest:request];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCurrentRequestedURL:nil];
    [self setMyWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NPRAppDelegate* delegate=(NPRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideProgress];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NPRAppDelegate* delegate=(NPRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showProgress];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NPRAppDelegate* delegate=(NPRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideProgress];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Loading Failed!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType == UIWebViewNavigationTypeLinkClicked) 
    {
        NSURL *requestedURL = [request URL];
        NSString *fileExtension = [requestedURL pathExtension];
        
        if ([fileExtension isEqualToString:@"png"] || [fileExtension isEqualToString:@"jpg"]) 
        {
            self.currentRequestedURL=requestedURL;
            /*
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Download" message:@"Download" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];*/
            
            UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"Image Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Download" otherButtonTitles: nil];
            [sheet showInView:self.view];
            
            /*
            // ...Check if the URL points to a file you're looking for...
            // Then load the file
            
             */
            return NO;
        }
    } 
    return YES;
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        PhotoEntry* photo=[[PhotoEntry alloc] init];
        
        NSData *fileData = [[NSData alloc] initWithContentsOfURL:self.currentRequestedURL];
        [fileData writeToFile:photo.fullPath atomically:YES];
        
        [self.photoManager addPhoto:photo];
 
        NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
        [nc postNotificationName:NotificationNamePaintRequired object:[NSNumber numberWithUnsignedInteger:0]];
        
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (IBAction)refresh:(id)sender {
    [self.myWebView reload];
}

- (IBAction)goForward:(id)sender {
    [self.myWebView goForward];
}

- (IBAction)goBack:(id)sender {
    [self.myWebView goBack];
}
- (IBAction)doCancel:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
