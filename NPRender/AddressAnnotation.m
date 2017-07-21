//
//  AddressAnnotation.m
//  NPRender
//
//  Created by Chen Xianshun on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation
@synthesize name=_name;
@synthesize coordinate=_coordinate;
@synthesize address=_address;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate 
{
    self = [super init];
    if (self) 
    {
        _name = name;
        _address = address;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title 
{
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle 
{
    return _address;
}

@end


