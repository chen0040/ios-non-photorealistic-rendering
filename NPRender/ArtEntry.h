//
//  ArtEntry.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtEntry : NSObject
@property(nonatomic, strong, readonly) NSString* identifier;
@property(nonatomic, strong, readonly) NSDate* date;
@property(nonatomic, strong, readonly) NSString* path;
@property(nonatomic, strong, readonly) NSString* photoId;
@property(nonatomic, strong, readwrite) NSString* note;

-(id) initWithId: (NSString*) identifier andPath: (NSString*)path atDate: (NSDate*) date fromPhoto: (NSString*)pId note: (NSString*)note;
-(id) initFromPhoto: (NSString*)pId;

-(NSString*) fullPath;
-(NSString*) origFullPath;

-(void) destroyData;
@end
