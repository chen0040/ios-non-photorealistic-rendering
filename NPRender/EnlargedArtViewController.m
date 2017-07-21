//
//  EnlargedArtViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnlargedArtViewController.h"
#import "ArtEntry.h"
#import "ArtManager.h"
#import "PhotoEntry.h"
#import "PhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Twitter/Twitter.h>
#import <ImageIO/ImageIO.h>
#import "NPRAppDelegate.h"
#import "ArtNoteViewController.h"
#import "ArtEditViewController.h"

static NSString* const DetailViewArtNoteSegueIdentifier=@"Push Art Note";
static NSString* const DetailViewArtEditSegueIdentifier=@"Push Edit Art";

@interface EnlargedArtViewController ()

@end

@implementation EnlargedArtViewController
@synthesize photoImgView = _photoImgView;
@synthesize artManager=_artManager;
@synthesize photoManager=_photoManager;
@synthesize selectedIndex=_selectedIndex;
@synthesize uploadConnection=_uploadConnection;
@synthesize currentActionType=_currentActionType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentActionType=None;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setPhotoImgView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
    //NSData* jpegData=[NSData dataWithContentsOfFile:self.imgPath];
    //UIImage* img=[UIImage imageWithData:jpegData];
    
    ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
    UIImage* img=[UIImage imageWithContentsOfFile:npr.fullPath];
    self.photoImgView.image=img;
}

- (IBAction)doEmail:(id)sender 
{
    if(![MFMailComposeViewController canSendMail])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Mail Account Required!" message:@"You have not setup email account with your device, please setup via your device settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
    //CLLocation* location=[[CLLocation alloc] initWithLatitude:photo.lat longitude:photo.lng];
    UIImage* img=[UIImage imageWithContentsOfFile:npr.fullPath];
    
    // Create our email composer view on a background thread
    dispatch_queue_t queue = 
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^(void) {
        
        // Create Image Data
        NSMutableData* imageData = [[NSMutableData alloc] init];
        
        
        CGImageDestinationRef destination = 
        CGImageDestinationCreateWithData(
                                         (__bridge CFMutableDataRef)imageData, 
                                         (CFStringRef)@"public.jpeg", 1, nil);
        
        //NSDictionary* metadata = [self generateMetadataForLocation:location];
        
        CGImageDestinationAddImage(destination, 
                                   img.CGImage,
                                   nil);
        
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        
        // open email compose window & set initial values
        MFMailComposeViewController* composer = [[MFMailComposeViewController alloc] init];
        
        [composer setSubject:[NSString stringWithFormat:@"My NPRender Art Work: %@", npr.identifier]];
        [composer setMessageBody:[NSString stringWithFormat:@"Here's a Non-PhotoRealistic drawing I created using NPRender (Captured Photo ID:%@)(%@)", npr.photoId, npr.note] isHTML:NO];
        
        [composer addAttachmentData:imageData 
                           mimeType:@"image/jpeg" 
                           fileName:@"npr_art.jpg"];
        
        composer.mailComposeDelegate = self;
        
        // Present the view on the main thread
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self presentModalViewController:composer animated:YES];
            //[self.tabBarController.navigationController presentModalViewController:composer animated:YES completion:nil];
            
        });
    });
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [controller dismissModalViewControllerAnimated:YES];
}

- (IBAction)doTweet:(id)sender {
    /*
     CIImage* image = 
     [CIImage imageWithCGImage:self.imageToExport.CGImage];
     
     CGFloat rotation;
     switch (self.deviceOrientation) {
     case UIDeviceOrientationLandscapeLeft:
     rotation = M_PI_2;
     break;
     
     case UIDeviceOrientationLandscapeRight:
     rotation = -M_PI_2;
     break;
     
     default:
     
     [NSException raise:@"Illegal Orientation" 
     format:@"Invalid best subview orientation: %d",
     self.deviceOrientation];
     
     break;
     }
     
     CGAffineTransform transform = 
     CGAffineTransformMakeRotation(rotation);
     
     image = [image imageByApplyingTransform:transform];
     CIContext* context = [CIContext contextWithOptions:nil];
     
     UIImage* rotatedImage = 
     [UIImage imageWithCGImage:[context createCGImage:image 
     fromRect:image.extent]];
     */
    
    ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
    UIImage* img=[UIImage imageWithContentsOfFile:npr.fullPath];
    
    TWTweetComposeViewController* controller = 
    [[TWTweetComposeViewController alloc] init];
    
    [controller setInitialText:[NSString stringWithFormat:@"%@ #NPR", npr.note]];
    
    // add the rotated image to our tweet sheet.
    [controller addImage:img];
    
    /*
     controller.completionHandler = 
     ^(TWTweetComposeViewControllerResult result) {
     
     [self.rootViewController.modalViewController 
     dismissViewControllerAnimated:YES
     completion:nil];
     };*/
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)doFacebook:(id)sender 
{
    [self askWithTitle:@"Facebook Share" andMessage:@"Do like to share this art on your Facebook?" andAction:AskFacebookShare];
}

- (void) askWithTitle: (NSString*)title andMessage: (NSString*)msg andAction: (ActionType)typ
{
    self.currentActionType=typ;
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:title];
    [alert setMessage:msg];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show]; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        if(self.currentActionType==AskFacebookShare)
        {
            NPRAppDelegate *delegate = (NPRAppDelegate *)[[UIApplication sharedApplication] delegate];
            if(![delegate isFacebookLogined])
            {
                [self askWithTitle:@"Facebook Not Login" andMessage:@"Login to your Facebook and press the button again" andAction:AskFacebookLogin];
            }
            else {
                ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
                UIImage* img=[UIImage imageWithContentsOfFile:npr.fullPath];
                [delegate doFacebookUploadImage:img withMessage:npr.note];
            }
        }
        else if(self.currentActionType==AskFacebookLogin)
        {
            NPRAppDelegate *delegate = (NPRAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate doFacebookLogin];
        }
        else if(self.currentActionType==AskUpload)
        {
            ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
            NSData* data=[NSData dataWithContentsOfFile:npr.fullPath];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
            NSString* img_filename_wo_ext=[dateFormatter stringFromDate:[NSDate date]];
            
            NSString* img_filename=[NSString stringWithFormat:@"%@.jpg", img_filename_wo_ext];
            
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.czcodezone.com/npr/handle_idata_upload.php?dst=%@&raw=no", img_filename]];
            
            [self uploadImage:data toUrl:url];
        }
	}
	else if (buttonIndex == 1)
	{
		// No
	}
}

- (IBAction)doUpload:(id)sender 
{
    [self askWithTitle:@"Upload to NPRender Online" andMessage:@"Would you like to publish your art at the online site?" andAction:AskUpload];
}

-(void)uploadImage: (NSData*)imageData toUrl: (NSURL*)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60]; 
    
    [request setHTTPMethod:@"POST"]; 
    
    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // end of what we've added to the header
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    // Now we need to append the different data 'segments'. We first start by adding the boundary.
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Now append the image
    // Note that the name of the form field is exactly the same as in the trace ('attachment[file]' in my case)!
    // You can choose whatever filename you want.
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"file\";filename=\"picture.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // We now need to tell the receiver what content type we have
    // In my case it's a png image. If you have a jpg, set it to 'image/jpg'
    [body appendData:[[NSString stringWithString:@"Content-Type: image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Now we append the actual image data
    [body appendData:[NSData dataWithData:imageData]];
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    
    self.uploadConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self
                                                    startImmediately:YES]; 
    
    //[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:DataDownloaderRunMode]; 
    
    //[connection start]; 
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Upload completed!" message:@"Your file has been uploaded!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NPRAppDelegate* delegate=(NPRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideProgress];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Upload failed!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:DetailViewArtNoteSegueIdentifier])
    {
        ArtNoteViewController* controller=segue.destinationViewController;
        controller.artManager=self.artManager;
        controller.photoManager=self.photoManager;
        controller.selectedIndex=self.selectedIndex;
    }
    else if([segue.identifier isEqualToString:DetailViewArtEditSegueIdentifier])
    {
        ArtEditViewController* controller=segue.destinationViewController;
        controller.photoManager=self.photoManager;
        controller.artManager=self.artManager;
        controller.selectedIndex=self.selectedIndex;
    }
}


@end
