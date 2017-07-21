//
//  ArtManager.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtManager.h"
#import "ArtEntry.h"
#import "DDXML.h"

static NSString* NotificationNameArtChange=@"ArtChangeNotification";

@interface ArtManager()
@property(nonatomic, strong) NSMutableArray* artArchive;
@end

@implementation ArtManager
@synthesize artArchive = _artArchive;

+(NSSet*)keyPathsForValuesAffectingArts{
    return [NSSet setWithObjects:@"artArchive", nil];
}

-(NSArray*)arts
{
    return self.artArchive;
}

-(id)init
{
    self=[super init];
    if(self)
    {
        _artArchive=[[NSMutableArray alloc] init];
        
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
                    NSString* p_photoId=[[level1 attributeForName:@"pId"] stringValue];
                    NSString* p_date =[[level1 attributeForName:@"date"] stringValue];
                    ArtEntry* npr=[[ArtEntry alloc] initWithId:p_id andPath:p_path atDate:[dateFormatter dateFromString:p_date] fromPhoto:p_photoId note:p_note];
                    [self.artArchive addObject:npr];
                }
            }
        }

    }
    return self;
}

-(void)addArt:(ArtEntry *)entry
{
    [self willChange: NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:KVOArtChangeKey];
    [self.artArchive insertObject:entry atIndex:0];
    [self didChange: NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey: KVOArtChangeKey];
    [self saveToDisk];
}

-(void)removeArtAtIndex:(NSUInteger)artIndex
{
    [self willChange: NSKeyValueChangeRemoval valuesAtIndexes: [NSIndexSet indexSetWithIndex: artIndex] forKey:KVOArtChangeKey];
    ArtEntry* npr = [self.artArchive objectAtIndex:artIndex];
    [npr destroyData];
    [self.artArchive removeObjectAtIndex:artIndex];
    [self didChange: NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:artIndex] forKey:KVOArtChangeKey];
    [self saveToDisk];
}

-(NSString*) filePath
{
    NSString* filepath=[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%@", @"artArchive.xml"]];
    return filepath;
    
}

-(void) saveToDisk
{
    NSString* fpath=[self filePath];
    
    NSError* error;
    
    DDXMLDocument* doc=[[DDXMLDocument alloc] initWithXMLString:@"<?xml version=\"1.0\"?><arts></arts>" options:0 error:&error];
    if(error)
    {
        return;
    }
    DDXMLElement* doc_root=[doc rootElement];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    
    
    
    int count=self.artArchive.count;
    for(int i=0; i < count; ++i)
    {
        ArtEntry* npr=[self.artArchive objectAtIndex:i];
        DDXMLElement* level1=[DDXMLElement elementWithName:@"p"];
        
        
        DDXMLNode* p_id=[DDXMLNode attributeWithName:@"id" stringValue:npr.identifier];
        [level1 addAttribute:p_id];
        
        DDXMLNode* p_path=[DDXMLNode attributeWithName:@"path" stringValue:npr.path];
        [level1 addAttribute:p_path];
        
        DDXMLNode* p_note=[DDXMLNode attributeWithName:@"note" stringValue:npr.note];
        [level1 addAttribute:p_note];
        
        NSString* pstr_date =[dateFormatter stringFromDate:npr.date];
        
        DDXMLNode* p_date=[DDXMLNode attributeWithName:@"date" stringValue:pstr_date];
        [level1 addAttribute:p_date];
        
        DDXMLNode* p_photoId=[DDXMLNode attributeWithName:@"pId" stringValue:npr.photoId];
        [level1 addAttribute:p_photoId];
        
        [doc_root addChild:level1];
    }
    
    NSData* data = [doc XMLData];
    [data writeToFile:fpath atomically:NO];
}

-(void) notifyIndividualChange: (NSUInteger) objIndex
{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationNameArtChange object:[NSNumber numberWithUnsignedInteger:objIndex]];
}
@end
