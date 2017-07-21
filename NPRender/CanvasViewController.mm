//
//  CanvasViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CanvasViewController.h"
#import "PhotoManager.h"
#import "ArtManager.h"
#import "PhotoEntry.h"
#import "NPRCanvas.h"
#import "BrushConfigViewController.h"
#import "ArtEntry.h"
#import "Image.h"
#import "NPRAppDelegate.h"
#import "NPRCursor.h"


static NSString* const DetailViewCanvasSettingsSegueIdentifier=@"Push Canvas Config";

@interface CanvasViewController ()

@end

@implementation CanvasViewController
@synthesize photoManager=_photoManager;
@synthesize artManager=_artManager;
@synthesize drawTool = _drawTool;
@synthesize selectedIndex=_selectedIndex;
@synthesize canvas = _canvas;
@synthesize myTouchupToolbar = _myTouchupToolbar;
@synthesize touchupButton = _touchupButton;
@synthesize btnColor = _btnColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doCirclePaint:(id)sender 
{
    self.canvas.brushType=Circle;
    self.canvas.paintCount=1;
    [self.canvas setNeedsDisplay];
}

- (IBAction)doSlantPaint:(id)sender 
{
    self.canvas.brushType=Slanted;
    self.canvas.paintCount=1;
    [self.canvas setNeedsDisplay];
}

- (IBAction)doBSlantPaint:(id)sender 
{
    self.canvas.brushType=BSlanted;
    self.canvas.paintCount=1;
    [self.canvas setNeedsDisplay];
}

- (IBAction)doTouchup:(id)sender 
{
    self.myTouchupToolbar.hidden=!self.myTouchupToolbar.hidden;
    if(self.myTouchupToolbar.hidden)
    {
        self.touchupButton.title=@"More";
    }
    else {
        self.touchupButton.title=@"Less";
    }
}

- (IBAction)doSketch:(id)sender 
{
    self.canvas.brushType=AntSketch;
    self.canvas.paintCount=1;
    [self.canvas setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTouchupToolbar.hidden=YES;
    self.drawTool.selectedSegmentIndex = self.canvas.cursor.drawTool;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCanvas:nil];
    
    [self setTouchupButton:nil];
    [self setMyTouchupToolbar:nil];
    [self setDrawTool:nil];
    [self setBtnColor:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PhotoEntry* photo=[self.photoManager.photos objectAtIndex:self.selectedIndex];
    UIImage* srcImage=[UIImage imageWithContentsOfFile:photo.fullPath];
    
    if(![photo.fullPath isEqualToString:self.canvas.srcImagePath])
    {
        /*
        ImageWrapper *greyScale=Image::createImage(srcImage, srcImage.size.width/4, srcImage.size.height/4, photo.pType==1);
        self.canvas.imgBuffer=greyScale.image->toUIImage();
         */
        self.canvas.srcImage=srcImage;
        self.canvas.srcImagePath=photo.fullPath;
        self.canvas.imgBuffer=[self.canvas scaleAndRotateImage:srcImage];
    }
    
    self.canvas.frame=self.view.frame; 
    self.canvas.backgroundColor=[UIColor lightGrayColor];
    
    self.btnColor.tintColor=self.canvas.drawColor;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.canvas centerCursor];
    [super viewDidAppear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:DetailViewCanvasSettingsSegueIdentifier])
    {
        BrushConfigViewController* controller=segue.destinationViewController;
        controller.canvas=self.canvas;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)doSave:(id)sender
{
    if(self.canvas.imgBuffer)
    {
        PhotoEntry* photo=[self.photoManager.photos objectAtIndex:self.selectedIndex];
        ArtEntry* npr=[[ArtEntry alloc] initFromPhoto:photo.identifier];
        NSData* jpegData=UIImageJPEGRepresentation(self.canvas.imgBuffer, 1.0);
        [jpegData writeToFile:npr.fullPath atomically:NO];
        
        UIImageWriteToSavedPhotosAlbum(self.canvas.imgBuffer, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [self.artManager addArt:npr];

        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (IBAction)doColor:(id)sender 
{
    HRColorPickerViewController* controller;
    controller = [HRColorPickerViewController cancelableColorPickerViewControllerWithColor:self.canvas.drawColor];
    
    /*
     switch ([sender tag]) {
     case 0:
     controller = [HRColorPickerViewController colorPickerViewControllerWithColor:self.canvas.drawColor];
     break;
     case 1:
     controller = [HRColorPickerViewController cancelableColorPickerViewControllerWithColor:self.canvas.drawColor];
     break;
     case 2:
     controller = [HRColorPickerViewController fullColorPickerViewControllerWithColor:self.canvas.drawColor];
     break;
     case 3:
     controller = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:self.canvas.drawColor];
     break;
     
     default:
     return;
     break;
     }*/
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)doDrawToolChange:(id)sender 
{
    self.canvas.cursor.drawTool=(NPRDrawTool)self.drawTool.selectedSegmentIndex;
}

- (IBAction)eraseCanvas:(id)sender 
{
    [self.canvas setNeedsErase];
}
- (IBAction)showFace:(id)sender 
{
    [self.canvas showFaces];
}

#pragma mark - Hayashi311ColorPickerDelegate

- (void)setSelectedColor:(UIColor*)color{
    self.canvas.drawColor=color;
    self.btnColor.tintColor=color;
    //[hexColorLabel setText:[NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)]];
}
@end
