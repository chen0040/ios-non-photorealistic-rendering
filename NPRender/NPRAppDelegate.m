//
//  NPRAppDelegate.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPRAppDelegate.h"

NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";

@implementation NPRAppDelegate
@synthesize currentAPICall=_currentAPICall;
@synthesize window = _window;
@synthesize facebook=_facebook;
@synthesize bannerView=_bannerView;
@synthesize navigationController=_navigationController;
@synthesize currentController=_currentController;
//@synthesize progressView=_progressView;

-(void) doFacebookLogin
{
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                               @"read_stream", 
                                @"offline_access", 
                                @"publish_stream", 
                                @"manage_pages", 
                                @"user_photos", 
                                @"friends_photos",
                                nil];
        [self.facebook authorize:permissions];
}

-(BOOL) isFacebookLogined
{
    return [self.facebook isSessionValid];
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}
/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    //NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }   
}

-(void)doFacebookLogout
{
    [self.facebook logout];
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    
}

-(void) doFacebookUploadImage:(UIImage*) img withMessage: (NSString*) msg
{
    self.currentAPICall = kAPIGraphUserPhotosPost;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"source",
                                   msg, @"message",
                                   nil];
    
    /*
    [self.facebook requestWithMethodName:@"photos.upload"
                           andParams:params
                       andHttpMethod:@"POST"
                         andDelegate:self];*/
    
    
    [self.facebook requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
    
    
}

-(void)doFacebookListImage
{
    //self.currentAPICall=kAPIGraphUserPhotoList;
    //[self.facebook requestWithGraphPath:@"me/albums" andDelegate:self];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"fb://albums"]];
}




/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //[self.progressView startAnimating];
}

/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[self.progressView stopAnimating];
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[self.progressView stopAnimating];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Facebook request failed!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    switch (self.currentAPICall) {
        case kAPIGraphUserPhotosPost:
        {
            [self showMessage:@"Photo uploaded successfully."];
            break;
        }
        case kAPIGraphUserVideosPost:
        {
            [self showMessage:@"Video uploaded successfully."];
            break;
        }
        case kAPIGraphUserPhotoList:
        {
            //[self showMessage:[result description]];
            if([result isKindOfClass:[NSDictionary class]])
            {
                id result_data=[result objectForKey:@"data"];
                //[self showMessage:[result_data description]];
                if([result_data isKindOfClass:[NSArray class]])
                {
                    result_data=[result_data objectAtIndex:0];
                }
               
                id result_id=[result_data objectForKey:@"id"];
                if(result_id)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat: @"fb://album/%@", result_id]]];
                 }
                /*
                if([result_data isKindOfClass:[NSDictionary class]])
                {
                    id result_link=[result_data objectForKey:@"link"];
                    if([result_link isKindOfClass:[NSString class]])
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result_link]];
                    }
                }*/
            }
            break;
        }
        default:
            break;
    }
}

-(void) showMessage: (NSString*) msg
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Facebook request completed!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.facebook = [[Facebook alloc] initWithAppId:@"304319856310327" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) 
    {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0, bounds.size.height, 0.0, 0.0)];
    _bannerView.delegate = self;
    
    _currentController = nil; // top most controller is not a banner container, so this starts out nil.
    
    _navigationController=(UINavigationController*)self.window.rootViewController;
    _navigationController.delegate=self;
    
    return YES;
}

-(void) showProgress
{
    //[self.progressView startAnimating];
}

-(void) hideProgress
{
    //[self.progressView stopAnimating];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self.facebook extendAccessTokenIfNeeded];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [_currentController showBannerView:banner animated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [_currentController hideBannerView:_bannerView animated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _currentController = [viewController respondsToSelector:@selector(showBannerView:animated:)] ? (UIViewController<BannerViewContainer> *)viewController : nil;
    if (_bannerView.bannerLoaded && (_currentController != nil)) {
        [(UIViewController<BannerViewContainer> *)viewController showBannerView:_bannerView animated:NO];
    }
}

@end
