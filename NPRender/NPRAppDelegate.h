//
//  NPRAppDelegate.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@protocol BannerViewContainer <NSObject>

- (void)showBannerView:(ADBannerView *)bannerView animated:(BOOL)animated;
- (void)hideBannerView:(ADBannerView *)bannerView animated:(BOOL)animated;

@end

extern NSString * const BannerViewActionWillBegin;
extern NSString * const BannerViewActionDidFinish;

#import "FBConnect.h"

@class NPRTabBarController;

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserPhotoList,
    kAPIGraphUserVideosPost
} apiCall;

@interface NPRAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate, UINavigationControllerDelegate, ADBannerViewDelegate>
@property (nonatomic, strong) Facebook *facebook;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) int currentAPICall;
@property (nonatomic, strong) ADBannerView *bannerView;
//@property (nonatomic, strong) UIActivityIndicatorView* progressView;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIViewController<BannerViewContainer> *currentController;

-(void) showProgress;
-(void) hideProgress;
-(void)doFacebookLogin;
-(void)doFacebookLogout;
-(BOOL)isFacebookLogined;
-(void)doFacebookUploadImage: (UIImage*) img withMessage: (NSString*)msg;
-(void)doFacebookListImage;
-(void) showMessage: (NSString*) msg;

@end
