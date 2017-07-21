//
//  PhotoEntry.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoEntry.h"

@implementation PhotoEntry
@synthesize identifier = _identifier;
@synthesize date = _date;
@synthesize path = _path;
@synthesize lat = _lat;
@synthesize lng = _lng;
@synthesize note = _note;
@synthesize pType=_pType;

-(id) initWithId:(NSString *)identifier andPath:(NSString *)path atDate:(NSDate *)date atLat:(CGFloat)lat andLng:(CGFloat)lng note:(NSString *)note asType: (NSUInteger)typ
{
    self=[super init];
    if(self)
    {
        _identifier=identifier;
        _path=path;
        _date=date;
        _note=note;
        _lat=lat;
        _lng=lng;
        _pType=typ;
    }
    return self;
}

-(id) initWithLocation: (CLLocation*)location
{
    NSDate* today=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSString* identifier=[dateFormatter stringFromDate:today];
    
    
    NSString* path=[NSString stringWithFormat:@"%@.jpg", identifier];
    
    NSString* note1=[NSString stringWithFormat:@"Taken at (%.3lf, %.3lf)", location.coordinate.latitude, location.coordinate.longitude];
    
    return [self initWithId:identifier andPath:path atDate:today atLat:location.coordinate.latitude andLng:location.coordinate.longitude note:note1 asType:1];
}

-(void) destroyData
{
    NSString* fpath=[self fullPath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fpath])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fpath error:NULL];
    }
}

-(NSString*) fullPath
{
    NSString* filepath=[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%@", self.path]];
    return filepath;
}

-(id) init 
{
    NSDate* today=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSString* identifier=[dateFormatter stringFromDate:today];

    
    NSString* path=[NSString stringWithFormat:@"%@.jpg", identifier];
    
    return [self initWithId:identifier andPath:path atDate:today atLat:0.0f andLng:0.0f note:identifier asType:0];
}
@end
