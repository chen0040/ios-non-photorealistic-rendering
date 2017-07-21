//
//  PhotoCell.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoEntry.h"

@implementation PhotoCell
@synthesize noteLabel = _noteLabel;
@synthesize dateLabel = _dateLabel;
@synthesize imgLabel=_imgLabel;
@synthesize typeIndLabel=_typeIndLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureWithPhotoEntry:(PhotoEntry *)photo
{
    self.noteLabel.text=photo.note;
    
    self.imgLabel.image=[UIImage imageWithContentsOfFile:photo.fullPath];
    
    if(photo.pType==1)
    {
        self.typeIndLabel.image=[UIImage imageNamed:@"Camera.png"];
    }
    else if(photo.pType==0)
    {
        self.typeIndLabel.image=[UIImage imageNamed:@"download.png"];
    }
    
    self.dateLabel.text=[NSDateFormatter localizedStringFromDate:photo.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"book_row.png"]];
}

-(void) configure
{
    self.noteLabel.text=nil;
    self.dateLabel.text=nil;
    //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"book_row.png"]];
}

@end
