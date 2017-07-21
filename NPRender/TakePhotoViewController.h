//
//  TakePhotoViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ArtManager;
@class PhotoManager;

@interface TakePhotoViewController : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@property(nonatomic, strong) CLLocation* currentLocation;
@property(nonatomic, strong) ArtManager* artManager;
@property(nonatomic, strong) PhotoManager* photoManager;
@property(nonatomic, strong) AVCaptureSession* capSession;
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property(nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
@property (strong, nonatomic) IBOutlet UIView *videoPreview;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer* preview;
- (IBAction)takePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *camToggleButton;
- (IBAction)cameraToggle:(id)sender;

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position;
- (AVCaptureDevice *) backFacingCamera;
- (AVCaptureDevice *) frontFacingCamera;
- (BOOL) hasMultipleCameras;
- (IBAction)doCancel:(id)sender;

-(void) setupAVCapture;
@end
