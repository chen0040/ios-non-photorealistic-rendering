//
//  PhotoNoteViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoNoteViewController.h"
#import "ArtManager.h"
#import "PhotoManager.h"
#import "PhotoEntry.h"

@interface PhotoNoteViewController ()

@end

@implementation PhotoNoteViewController
@synthesize artManager = _artManager;
@synthesize photoManager = _photoManager;
@synthesize noteField = _noteField;
@synthesize selectedIndex=_selectedIndex;

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
}

- (void)viewDidUnload
{
    [self setNoteField:nil];
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
    PhotoEntry* photo=[self.photoManager.photos objectAtIndex:self.selectedIndex];
    self.noteField.text=photo.note;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    PhotoEntry* photo=[self.photoManager.photos objectAtIndex:self.selectedIndex];
    photo.note=self.noteField.text;
    
    [self.photoManager saveToDisk];
    [self.photoManager notifyIndividualChange:self.selectedIndex];
}

@end
