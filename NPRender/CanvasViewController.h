//
//  CanvasViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HRColorPickerViewController.h"

@class PhotoManager;
@class ArtManager;
@class NPRCanvas;

@interface CanvasViewController : UIViewController<HRColorPickerViewControllerDelegate>
@property (nonatomic, strong) ArtManager* artManager;
@property (nonatomic, strong) PhotoManager* photoManager;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (strong, nonatomic) IBOutlet NPRCanvas *canvas;
@property (strong, nonatomic) IBOutlet UIToolbar *myTouchupToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *touchupButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnColor;
@property (strong, nonatomic) IBOutlet UISegmentedControl *drawTool;

- (IBAction)doDrawToolChange:(id)sender;
- (IBAction)eraseCanvas:(id)sender;
- (IBAction)doColor:(id)sender;
- (IBAction)doSave:(id)sender;
- (IBAction)showFace:(id)sender;
- (IBAction)doCirclePaint:(id)sender;
- (IBAction)doSlantPaint:(id)sender;
- (IBAction)doBSlantPaint:(id)sender;
- (IBAction)doTouchup:(id)sender;
- (IBAction)doSketch:(id)sender;
@end
