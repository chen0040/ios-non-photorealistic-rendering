//
//  PhotoPlaceViewController.h
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPlaceViewController : UIViewController
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, assign) CGFloat lng;
@property(nonatomic, strong) NSString* note;
@property(nonatomic, strong) NSString* address;

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@end
