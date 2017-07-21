//
//  NPRCanvas.h
//  NPRender
//
//  Created by Chen Xianshun on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
    Circle,
    Slanted,
    BSlanted,
    AntSketch
} NPRBrushType;

typedef enum
{
    ColorCopyRGB,
    ColorCopyLuminance
} NPRBrushColorType;

@class NPRCursor;

@interface NPRCanvas : UIView<UIGestureRecognizerDelegate>{
    unsigned char* rawData;
    NSUInteger img_width;
    NSUInteger img_height;
    NSUInteger bytesPerPixel;
    NSUInteger bytesPerRow;
}

@property(nonatomic)NPRCursor* cursor;
@property(nonatomic, assign) CGPoint currentDrawPoint;
@property(nonatomic, assign) CGPoint previousDrawPoint;
@property(nonatomic, strong) UIImage* srcImage;
@property(nonatomic, strong) UIImage* imgBuffer;
@property(nonatomic, assign) CGFloat paintFrequency;
@property(nonatomic, assign) CGFloat brushThickness;
@property(nonatomic, assign) CGFloat brushWidth;
@property(nonatomic, assign) NSUInteger paintInterval;
@property(nonatomic, assign) NSUInteger paintCount;
@property(nonatomic, assign) NSUInteger drawCount;
@property(nonatomic, assign) NPRBrushType brushType;
@property(nonatomic, strong) NSString* srcImagePath;
@property(nonatomic, assign) BOOL shouldErase;
@property(nonatomic, assign) CGFloat bcRed;
@property(nonatomic, assign) CGFloat bcGreen;
@property(nonatomic, assign) CGFloat bcBlue;
@property(nonatomic, assign) CGFloat bcAlpha;
@property(nonatomic, strong) UIColor* drawColor;
@property(nonatomic, assign) NSUInteger brushDrawWidth;
@property(nonatomic, assign) NSUInteger penDrawWidth;

@property(nonatomic, assign) BOOL shouldShowFace;

@property(nonatomic, assign) NSUInteger maxAntSteps;
@property(nonatomic, assign) CGFloat maxAntSharpTurn;
@property(nonatomic, assign) CGFloat minAntTrackLevel;
@property(nonatomic, assign) NPRBrushColorType brushColorType;
@property(nonatomic, assign) NSUInteger maxAntJumps;

-(void)centerCursor;

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)setupRecognizers;

-(void)setNeedsErase;

-(void)doAntSketch: (CGContextRef)context;
-(CGPoint) getColorGradientAtX: (int)x andY: (int)y;
-(CGFloat) getColorGradientNormAtX: (int)x andY: (int)y;
-(CGPoint) getColorGradientNormalAtX: (int)x andY: (int)y;

-(void)showFaces;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;

-(void)drawBrushAtX: (int)xx andY: (int)yy inContext: (CGContextRef)ccontext byHand: (BOOL)flg;
-(void)drawAtX: (int)xx andY: (int)yy inContext: (CGContextRef)ccontext byHand:(BOOL)flgByHand withColor: (UIColor*)c andWidth: (NSUInteger)w;

- (UIImage*)snapshotOfImage;

+ (CGFloat) nextFloat;
@end