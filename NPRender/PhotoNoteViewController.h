//
//  PhotoNoteViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArtManager;
@class PhotoManager;

@interface PhotoNoteViewController : UIViewController
@property(nonatomic, strong) ArtManager* artManager;
@property(nonatomic, strong) PhotoManager* photoManager;
@property (strong, nonatomic) IBOutlet UITextView *noteField;
@property(nonatomic, assign) NSUInteger selectedIndex;
@end
