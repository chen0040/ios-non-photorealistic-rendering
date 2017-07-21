//
//  ArtEntry.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtEntry.h"

@implementation ArtEntry
@synthesize identifier = _identifier;
@synthesize date = _date;
@synthesize path = _path;
@synthesize photoId = _photoId;
@synthesize note = _note;

-(id) initWithId:(NSString *)identifier andPath:(NSString *)path atDate:(NSDate *)date fromPhoto:(NSString *)pId note: (NSString*) note
{
    self=[super init];
    if(self)
    {
        _identifier=identifier;
        _path=path;
        _date=date;
        _photoId=pId;
        _note=note;
    }
    return self;
}

-(id) init 
{
    NSDate* today=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSString* identifier=[dateFormatter stringFromDate:today];

    NSString* path=[NSString stringWithFormat:@"%@_npr.jpg", identifier];
    
    NSString* note1=@"";
    return [self initWithId:identifier andPath:path atDate:today fromPhoto:identifier note: note1];
}

-(id) initFromPhoto:(NSString *)pId
{
    NSDate* today=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSString* identifier=[dateFormatter stringFromDate:today];

    NSString* path=[NSString stringWithFormat:@"%@_npr.jpg", identifier];
    
    NSString* note1=[NSString stringWithFormat:@"NPR: %@", pId];
    return [self initWithId:identifier andPath:path atDate:today fromPhoto:pId note: note1];
    
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

-(NSString*) origFullPath
{
    NSString* filepath=[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%@.jpg", self.photoId]];
    return filepath;
}
@end
