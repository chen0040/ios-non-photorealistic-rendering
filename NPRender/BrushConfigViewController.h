//
//  BrushConfigViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NPRCanvas;

@interface BrushConfigViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISlider *thinknessSlider;
@property (strong, nonatomic) IBOutlet UISlider *brushWidthSlider;
@property(nonatomic, strong) NPRCanvas* canvas;

@property (strong, nonatomic) IBOutlet UISlider *redSlider;
@property (strong, nonatomic) IBOutlet UISlider *paintIntervalSlider;
@property (strong, nonatomic) IBOutlet UISlider *greenSlider;
@property (strong, nonatomic) IBOutlet UISlider *blueSlider;
@property (strong, nonatomic) IBOutlet UISlider *alphaSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *colorSegment;
@property (strong, nonatomic) IBOutlet UISlider *paintFrequencySlider;
@end
