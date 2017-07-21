//
//  PhotoPlaceViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoPlaceViewController.h"
#import "AddressAnnotation.h"

@interface PhotoPlaceViewController ()

@end

@implementation PhotoPlaceViewController
@synthesize lat=_lat;
@synthesize lng=_lng;
@synthesize myMapView = _myMapView;
@synthesize note=_note;
@synthesize address=_address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _address=@"";
        _note=@"Photo Taken";
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
    [self setMyMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.lat, self.lng);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
    
    [self.myMapView setRegion:region];
    
    [self.myMapView removeAnnotations:[self.myMapView annotations]];
    
    AddressAnnotation* mapPin=[[AddressAnnotation alloc] initWithName:self.note address:self.address coordinate:coord];
    [self.myMapView addAnnotation:mapPin];
}

@end
