//
//  ArtNoteViewController.m
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtNoteViewController.h"
#import "ArtManager.h"
#import "PhotoManager.h"
#import "ArtEntry.h"

@interface ArtNoteViewController ()

@end

@implementation ArtNoteViewController
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
    
    ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
    self.noteField.text=npr.note;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    ArtEntry* npr=[self.artManager.arts objectAtIndex:self.selectedIndex];
    npr.note=self.noteField.text;
    
    [self.artManager saveToDisk];
    [self.artManager notifyIndividualChange:self.selectedIndex];
}

- (IBAction)doDone:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
