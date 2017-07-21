//
//  ArtCell.m
//  NPRender
//
//  Created by Chen Xianshun on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtCell.h"
#import "ArtEntry.h"

@implementation ArtCell
@synthesize noteLabel = _noteLabel;
@synthesize dateLabel = _dateLabel;
@synthesize imgLabel=_imgLabel;
@synthesize imgOrig=_imgOrig;

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

-(void) configureWithArtEntry:(ArtEntry *)npr
{
    self.noteLabel.text=npr.note;
    
    self.imgLabel.image=[UIImage imageWithContentsOfFile:npr.fullPath];

    if([[NSFileManager defaultManager] fileExistsAtPath:npr.origFullPath])
    {
        self.imgOrig.image=[UIImage imageWithContentsOfFile:npr.origFullPath];
    }
    
    self.dateLabel.text=[NSDateFormatter localizedStringFromDate:npr.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    
    //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"book_row.png"]];
    self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_row.png"]];
}

-(void) configure
{
    self.noteLabel.text=nil;
    self.dateLabel.text=nil;
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"book_row.png"]];
}


@end
