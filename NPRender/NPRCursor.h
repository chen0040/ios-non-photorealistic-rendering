//
//  NPRCursor.h
//  NPRender
//
//  Created by Chen Xianshun on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
    Pen,
    Brush,
    Eraser,
    None
} NPRDrawTool;

@interface NPRCursor : UIView
@property(nonatomic, strong) UIImage* imgBrush;
@property(nonatomic, strong) UIImage* imgPen;
@property(nonatomic, strong) UIImage* imgEraser;
@property(nonatomic, assign) CGFloat xOffset;
@property(nonatomic, assign) CGFloat yOffset;
@property(nonatomic, assign) NPRDrawTool drawTool;
@end

