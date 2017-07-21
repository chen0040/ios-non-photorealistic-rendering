//
//  TakePhotoViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ArtManager.h"
#import "PhotoManager.h"
#import "PhotoEntry.h"

static NSString* const NotificationNamePaintRequired=@"PaintRequiredNotification";

@interface TakePhotoViewController ()

@end

@implementation TakePhotoViewController
@synthesize camToggleButton = _camToggleButton;
@synthesize artManager = _artManager;
@synthesize photoManager = _photoManager;
@synthesize stillImageOutput = _stillImageOutput;
@synthesize videoPreview = _videoPreview;
@synthesize preview = _preview;
@synthesize currentLocation=_currentLocation;
@synthesize capSession=_capSession;
@synthesize videoInput=_videoInput;

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
	// Do any additional setup after loading the view.
    
    [self setupAVCapture];
    
    if(!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    // Set Location Manager delegate
    [locationManager setDelegate:self];
    
    // Set location accuracy levels
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Update again when a user moves distance in meters
    [locationManager setDistanceFilter:5];
    
    // Configure permission dialog
    [locationManager setPurpose:@"Geo Location Enable"];
    
    // Start updating location
    [locationManager startUpdatingLocation];
}

- (BOOL) hasMultipleCameras
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1 ? YES : NO;
}

- (IBAction)doCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)viewDidUnload
{
    self.artManager=nil;
    self.photoManager=nil;
    self.stillImageOutput=nil;
    self.preview=nil;
    
    [self setVideoPreview:nil];
    [self setCamToggleButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *c;
    c=[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];

    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:c completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(error)
        {
            NSLog(@"Take picture failed");
        }
        else {
            NSData* jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            PhotoEntry* photo = [[PhotoEntry alloc] initWithLocation:self.currentLocation];
                    
            [jpegData writeToFile:[photo fullPath] atomically:NO];
            
            [self.photoManager addPhoto:photo];
            
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:NotificationNamePaintRequired object:[NSNumber numberWithUnsignedInteger:0]];
            
        }
    }];

    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cameraToggle:(id)sender 
{
    BOOL success = NO;
    
    if ([self hasMultipleCameras]) {
        NSError *error;
        AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        } else {
            return;
        }
        
        if (newVideoInput != nil) {
            [self.capSession beginConfiguration];
            [self.capSession removeInput:videoInput];
            if ([self.capSession canAddInput:newVideoInput]) {
                [self.capSession addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.capSession addInput:videoInput];
            }
            [self.capSession commitConfiguration];
            success = YES;
        } else if (error) 
        {
            NSLog(@"error in camera toggle: %@", [error localizedDescription]);
        }
    }

}

-(void) setupAVCapture
{
    self.capSession=[AVCaptureSession new];
    [self.capSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    AVCaptureDevice* capDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError* error=nil;
    self.videoInput=[AVCaptureDeviceInput deviceInputWithDevice:capDevice error:&error];
    
    if(error != nil)
    {
        NSLog(@"Bad Device Input:%@", [error localizedDescription]);
    }
    else {
        if([self.capSession canAddInput:self.videoInput])
        {
            [self.capSession addInput:self.videoInput];
        }
        else {
            NSLog(@"could not add input");
        }
    }
    
    self.stillImageOutput=[AVCaptureStillImageOutput new];
    
    if([self.capSession canAddOutput:self.stillImageOutput])
    {
        [self.capSession addOutput:self.stillImageOutput];
    }
    
        
    CGFloat pwidth=self.videoPreview.frame.size.width;
    CGFloat pheight=self.videoPreview.frame.size.height;
    self.preview=[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.capSession];
    self.preview.frame=CGRectMake(0.0f, 0.0f, pwidth, pheight);
    self.preview.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    [self.videoPreview.layer addSublayer:self.preview];
    
    [self.capSession startRunning];
}


#pragma mark - CoreLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    NSLog(@"%@",[newHeading description]);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    // The user moved, update the map and print info to the on view textview
    //[mapView setCenterCoordinate:newLocation.coordinate animated:YES];
    //[textView setText:[NSString stringWithFormat:@"%@\n%@",[newLocation description],textView.text]];

    self.currentLocation=newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Entered Region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"Exited Region");
}



@end
