//
//  ArtNoteViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class ArtManager;
@class PhotoManager;

@interface ArtNoteViewController : UIViewController
@property(nonatomic, strong) ArtManager* artManager;
@property(nonatomic, strong) PhotoManager* photoManager;
@property (strong, nonatomic) IBOutlet UITextView *noteField;
- (IBAction)doDone:(id)sender;
@property(nonatomic, assign) NSUInteger selectedIndex;
@end
