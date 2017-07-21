//
//  PhotoGalleryViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtManager;
@class PhotoManager;

@interface PhotoGalleryViewController : UITableViewController
@property(nonatomic, strong) ArtManager* artManager;
@property(nonatomic, strong) PhotoManager* photoManager;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)doCancel:(id)sender;
- (IBAction)doEdit:(id)sender;

-(void)handlePhotoChange:(NSNotification*)obj;

@end
