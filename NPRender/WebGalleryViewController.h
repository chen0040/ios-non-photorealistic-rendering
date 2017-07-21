//
//  WebGalleryViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtManager;
@class PhotoManager;

@interface WebGalleryViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) NSURL* currentRequestedURL;
@property(nonatomic, strong) ArtManager* artManager;
- (IBAction)doCancel:(id)sender;
@property(nonatomic, strong) PhotoManager* photoManager;
- (IBAction)refresh:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)goBack:(id)sender;

@end
