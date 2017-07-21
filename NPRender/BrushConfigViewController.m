//
//  BrushConfigViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrushConfigViewController.h"
#import "NPRCanvas.h"

@interface BrushConfigViewController ()

@end

@implementation BrushConfigViewController
@synthesize canvas=_canvas;
@synthesize thinknessSlider = _thinknessSlider;
@synthesize brushWidthSlider = _brushWidthSlider;
@synthesize redSlider = _redSlider;
@synthesize paintIntervalSlider = _paintIntervalSlider;
@synthesize greenSlider = _greenSlider;
@synthesize blueSlider = _blueSlider;
@synthesize alphaSlider = _alphaSlider;
@synthesize colorSegment = _colorSegment;
@synthesize paintFrequencySlider = _paintFrequencySlider;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setThinknessSlider:nil];
    [self setBrushWidthSlider:nil];
    
    [self setPaintFrequencySlider:nil];
    [self setPaintIntervalSlider:nil];
    [self setRedSlider:nil];
    [self setGreenSlider:nil];
    [self setBlueSlider:nil];
    [self setColorSegment:nil];
    [self setAlphaSlider:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.brushWidthSlider.value=self.canvas.brushWidth;
    self.thinknessSlider.value=self.canvas.brushThickness;
        
    self.paintIntervalSlider.value=self.canvas.paintInterval;
    self.paintFrequencySlider.value=self.canvas.paintFrequency;
    self.redSlider.value=self.canvas.bcRed;
    self.greenSlider.value=self.canvas.bcGreen;
    self.blueSlider.value=self.canvas.bcBlue;
    self.alphaSlider.value=self.canvas.bcAlpha;
    self.colorSegment.selectedSegmentIndex=self.canvas.brushColorType;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    self.canvas.brushWidth=self.brushWidthSlider.value;
    self.canvas.brushThickness=self.thinknessSlider.value;
    
    self.canvas.paintInterval=self.paintIntervalSlider.value;
    self.canvas.paintFrequency=self.paintFrequencySlider.value;
    self.canvas.bcBlue=self.blueSlider.value;
    self.canvas.bcGreen=self.greenSlider.value;
    self.canvas.bcRed=self.redSlider.value;
    self.canvas.bcAlpha=self.alphaSlider.value;
    self.canvas.brushColorType=self.colorSegment.selectedSegmentIndex;
}

@end
