//
//  EnlargedArtViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

typedef enum
{
    AskFacebookShare,
    AskFacebookLogin,
    AskUpload,
    None
} ActionType;

@class PhotoManager;
@class ArtManager;

@interface EnlargedArtViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) PhotoManager* photoManager;
@property(nonatomic, strong) ArtManager* artManager;
@property(nonatomic, assign) ActionType currentActionType;

@property(strong, nonatomic) NSURLConnection* uploadConnection;

@property (strong, nonatomic) IBOutlet UIImageView *photoImgView;
@property(nonatomic, assign) NSUInteger selectedIndex;

- (void) askWithTitle: (NSString*)title andMessage: (NSString*)msg andAction: (ActionType)typ;

- (IBAction)doEmail:(id)sender;
- (IBAction)doTweet:(id)sender;
- (IBAction)doFacebook:(id)sender;
- (IBAction)doUpload:(id)sender;
@end
