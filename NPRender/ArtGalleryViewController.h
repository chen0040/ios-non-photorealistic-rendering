//
//  ArtGalleryViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPRAppDelegate.h"

@class ArtManager;
@class PhotoManager;

@interface ArtGalleryViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ADBannerViewDelegate, BannerViewContainer,
    UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) ArtManager* artManager;
@property(nonatomic, strong) PhotoManager* photoManager;
@property (nonatomic, strong) ADBannerView *bannerView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UIView* contentView;
//@property (nonatomic, strong) UIActivityIndicatorView* progressView;

- (void)handleArtChange:(NSNotification*)obj;
- (void)handlePaintRequired: (NSNotification*)obj;
- (void)handleViewRequired: (NSNotification*)obj;
- (IBAction)doAdd:(id)sender;

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate;


- (void)layoutAnimated:(BOOL)animated;

@end
