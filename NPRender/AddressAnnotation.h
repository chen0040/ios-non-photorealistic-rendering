//
//  AddressAnnotation.h
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
