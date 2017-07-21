//
//  NPRCursor.m
//  NPRender
//
//  Created by Chen Xianshun on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPRCursor.h"
#import "NPRCanvas.h"

@implementation NPRCursor
@synthesize imgBrush=_imgBrush;
@synthesize imgPen=_imgPen;
@synthesize imgEraser=_imgEraser;
@synthesize xOffset=_xOffset;
@synthesize yOffset=_yOffset;
@synthesize drawTool=_drawTool;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.xOffset=frame.size.width/2;
        self.yOffset=frame.size.height/2;
        self.opaque = NO;
        self.imgBrush=[UIImage imageNamed:@"paint_app.png"];
        self.imgPen=[UIImage imageNamed:@"pencil2.png"];
        self.imgEraser=[UIImage imageNamed:@"pen_blue.png"];
        _drawTool=None;
    }
    return self;
}

- (void)setDrawTool:(NPRDrawTool)drawTool
{
    _drawTool=drawTool;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    // draw the dot
    //[[UIColor redColor] setFill];    
    
    //UIBezierPath* dot = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    //[dot fill];
    CGContextRef ccontext=UIGraphicsGetCurrentContext();

    if(self.drawTool==Brush)
    {
        if(self.imgBrush)
        {
            // need to adjust the coordinates to draw the image.
            CGContextSaveGState(ccontext);
            CGContextTranslateCTM(ccontext, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(ccontext, 1.0f, -1.0f);
        
            CGContextDrawImage(ccontext, self.bounds, [self.imgBrush CGImage]);
            CGContextRestoreGState(ccontext);
        }
    }
    else if(self.drawTool==Pen)
    {
        if(self.imgPen)
        {
            // need to adjust the coordinates to draw the image.
            CGContextSaveGState(ccontext);
            CGContextTranslateCTM(ccontext, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(ccontext, 1.0f, -1.0f);
            CGRect rect=self.bounds;
            CGContextDrawImage(ccontext, rect, [self.imgPen CGImage]);
            CGContextRestoreGState(ccontext);
        }
    }
    else if(self.drawTool==Eraser)
    {
        if(self.imgEraser)
        {
            // need to adjust the coordinates to draw the image.
            CGContextSaveGState(ccontext);
            CGContextTranslateCTM(ccontext, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(ccontext, 1.0f, -1.0f);
            
            CGRect rect=self.bounds;
            CGContextDrawImage(ccontext, rect, [self.imgEraser CGImage]);
            CGContextRestoreGState(ccontext);
        }
    }
}

@end

