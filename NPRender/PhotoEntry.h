//
//  PhotoEntry.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoEntry : NSObject
@property(nonatomic, strong, readonly) NSString* identifier;
@property(nonatomic, strong, readonly) NSDate* date;
@property(nonatomic, strong, readonly) NSString* path;
@property(nonatomic, assign, readonly) CGFloat lat;
@property(nonatomic, assign, readonly) CGFloat lng;
@property(nonatomic, strong, readwrite) NSString* note;
@property(nonatomic, assign, readwrite) NSUInteger pType;

-(id) initWithId: (NSString*) identifier andPath: (NSString*)path atDate: (NSDate*) date atLat: (CGFloat) lat andLng: (CGFloat) lng note: (NSString*)note asType: (NSUInteger)typ;
-(id) initWithLocation: (CLLocation*) location;
-(NSString*) fullPath;

-(void) destroyData;
@end
