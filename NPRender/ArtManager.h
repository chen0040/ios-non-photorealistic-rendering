//
//  ArtManager.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArtEntry;
static NSString* const KVOArtChangeKey=@"artArchive";

@interface ArtManager : NSObject{
    
}

@property(weak, nonatomic, readonly) NSArray* arts;

-(void)addArt:(ArtEntry*) entry;
-(void)removeArtAtIndex:(NSUInteger) artIndex;

-(NSString*) filePath;

-(void) saveToDisk;
-(void) notifyIndividualChange: (NSUInteger) objIndex;
@end
