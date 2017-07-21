//
//  PhotoManager.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoEntry;

static NSString* const KVOPhotoChangeKey=@"photoArchive";

@interface PhotoManager : NSObject{
    
}
@property (weak, nonatomic, readonly) NSArray* photos;

-(void)addPhoto:(PhotoEntry*) entry;
-(void)removePhotoAtIndex:(NSUInteger)photoIndex;
-(NSString*) filePath;

-(void) saveToDisk;
-(void) notifyIndividualChange: (NSUInteger) objIndex;
@end
