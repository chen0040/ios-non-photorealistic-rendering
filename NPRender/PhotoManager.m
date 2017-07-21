//
//  PhotoManager.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoManager.h"
#import "PhotoEntry.h"
#import "DDXML.h"

static NSString* NotificationNamePhotoChange=@"PhotoChangeNotification";

@interface PhotoManager()
@property (nonatomic, strong) NSMutableArray* photoArchive;
@end

@implementation PhotoManager
@synthesize photoArchive = _photoArchive;

+(NSSet*) keyPathsForValuesAffectingPhotos
{
    return [NSSet setWithObjects:@"photoArchive", nil];
}

-(NSArray*)photos
{
    return self.photoArchive;
}

-(void) notifyIndividualChange: (NSUInteger) objIndex
{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationNamePhotoChange object:[NSNumber numberWithUnsignedInteger:objIndex]];
}

-(id)init
{
    self=[super init];
    if(self)
    {
        _photoArchive=[[NSMutableArray alloc] init];
        
        NSString* fpath=[self filePath];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fpath];
        
        if(fileExists)
        {
            NSError* error;
            NSString* content=[NSString stringWithContentsOfFile:fpath encoding:NSUTF8StringEncoding error:&error];
            if(error)
            {
                NSLog(@"Error: %@", [error localizedDescription]);
                return self;
            }
            DDXMLDocument* doc=[[DDXMLDocument alloc] initWithXMLString:content options:0 error:&error];
            if(error)
            {
                NSLog(@"Error: %@", [error localizedDescription]);
                return self;
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];

            DDXMLElement* doc_root=[doc rootElement];
            NSArray* doc_root_children=[doc_root children];
            for(id level1 in doc_root_children)
            {
                if([[level1 name] isEqualToString:@"p"])
                {
                    NSString* p_id = [[level1 attributeForName:@"id"] stringValue];
                    NSString* p_note = [[level1 attributeForName:@"note"] stringValue];
                    NSString* p_path = [[level1 attributeForName:@"path"] stringValue];
                    CGFloat p_lat=[[[level1 attributeForName:@"lat"] stringValue] floatValue];
                    CGFloat p_lng=[[[level1 attributeForName:@"lng"] stringValue] floatValue];
                    NSUInteger p_type=[[[level1 attributeForName:@"typ"] stringValue] intValue];
                    NSString* p_date =[[level1 attributeForName:@"date"] stringValue];
                    PhotoEntry* photo=[[PhotoEntry alloc] initWithId:p_id andPath:p_path atDate:[dateFormatter dateFromString:p_date] atLat:p_lat andLng:p_lng note:p_note asType:p_type];
                    
                    [self.photoArchive addObject:photo];
                }
            }
        }
    }
    
    
    return self;
}

-(NSString*) filePath
{
    NSString* filepath=[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%@", @"photoArchive.xml"]];
    return filepath;
    
}

-(void) saveToDisk
{
    NSString* fpath=[self filePath];

    NSError* error;
    
    DDXMLDocument* doc=[[DDXMLDocument alloc] initWithXMLString:@"<?xml version=\"1.0\"?><photos></photos>" options:0 error:&error];
    if(error)
    {
        return;
    }
    DDXMLElement* doc_root=[doc rootElement];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    

    
    int count=self.photoArchive.count;
    for(int i=0; i < count; ++i)
    {
        PhotoEntry* photo=[self.photoArchive objectAtIndex:i];
        DDXMLElement* level1=[DDXMLElement elementWithName:@"p"];
        
        
        DDXMLNode* p_id=[DDXMLNode attributeWithName:@"id" stringValue:photo.identifier];
        [level1 addAttribute:p_id];
        
        DDXMLNode* p_path=[DDXMLNode attributeWithName:@"path" stringValue:photo.path];
        [level1 addAttribute:p_path];
        
        DDXMLNode* p_note=[DDXMLNode attributeWithName:@"note" stringValue:photo.note];
        [level1 addAttribute:p_note];
        
        NSString* pstr_date =[dateFormatter stringFromDate:photo.date];
        
        DDXMLNode* p_date=[DDXMLNode attributeWithName:@"date" stringValue:pstr_date];
        [level1 addAttribute:p_date];
        
        DDXMLNode* p_lat=[DDXMLNode attributeWithName:@"lat" stringValue:[NSString stringWithFormat:@"%lf", photo.lat]];
        [level1 addAttribute:p_lat];
        
        DDXMLNode* p_lng=[DDXMLNode attributeWithName:@"lng" stringValue:[NSString stringWithFormat:@"%lf", photo.lng]];
        [level1 addAttribute:p_lng];
        
        DDXMLNode* p_type=[DDXMLNode attributeWithName:@"typ" stringValue:[NSString stringWithFormat:@"%d", photo.pType]];
        [level1 addAttribute:p_type];
        
        [doc_root addChild:level1];
    }
    
    NSData* data = [doc XMLData];
    [data writeToFile:fpath atomically:NO];
}

-(void)addPhoto:(PhotoEntry *)entry
{
    [self willChange: NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey: KVOPhotoChangeKey];
    [self.photoArchive insertObject:entry atIndex:0];
    [self didChange: NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:KVOPhotoChangeKey];
    [self saveToDisk];
}

-(void)removePhotoAtIndex:(NSUInteger)photoIndex
{
    [self willChange: NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:photoIndex] forKey:KVOPhotoChangeKey];
    PhotoEntry* photo = [self.photoArchive objectAtIndex:photoIndex];
    [photo destroyData];
    [self.photoArchive removeObjectAtIndex:photoIndex];
    [self didChange: NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:photoIndex] forKey:KVOPhotoChangeKey];
    [self saveToDisk];
}
@end
