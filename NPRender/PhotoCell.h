//
//  PhotoCell.h
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoEntry;

@interface PhotoCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel* noteLabel;
@property(nonatomic, strong) IBOutlet UILabel* dateLabel;
@property(nonatomic, strong) IBOutlet UIImageView* imgLabel;
@property(nonatomic, strong)  IBOutlet UIImageView* typeIndLabel;

-(void) configureWithPhotoEntry: (PhotoEntry*) photo;
-(void) configure;
@end
