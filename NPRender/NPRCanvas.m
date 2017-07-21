//
//  NPRCanvas.m
//  NPRender
//
//  Created by Chen Xianshun on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPRCanvas.h"
#import "NPRCursor.h"

#define RGBA        4
#define RGBA_8_BIT  8

@interface NPRCanvas()

- (CGRect)rectFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2;

@end


@implementation NPRCanvas
@synthesize srcImage=_srcImage;
@synthesize cursor = _cursor;
@synthesize currentDrawPoint = _currentDrawPoint;
@synthesize previousDrawPoint=_previousDrawPoint;
@synthesize brushType=_brushType;
@synthesize brushThickness=_brushThickness;
@synthesize brushWidth=_brushWidth;
@synthesize paintFrequency=_paintFrequency;
@synthesize paintInterval=_paintInterval;
@synthesize imgBuffer=_imgBuffer;
@synthesize paintCount=_paintCount;
@synthesize drawCount=_drawCount;
@synthesize srcImagePath=_srcImagePath;
@synthesize shouldErase=_shouldErase;
@synthesize maxAntSharpTurn=_maxAntSharpTurn;
@synthesize maxAntSteps=_maxAntSteps;
@synthesize minAntTrackLevel=_minAntTrackLevel;
@synthesize brushColorType=_brushColorType;
@synthesize maxAntJumps=_maxAntJumps;
@synthesize bcRed=_bcRed;
@synthesize bcGreen=_bcGreen;
@synthesize bcBlue=_bcBlue;
@synthesize bcAlpha=_bcAlpha;
@synthesize shouldShowFace=_shouldShowFace;
@synthesize brushDrawWidth=_brushDrawWidth;
@synthesize penDrawWidth=_penDrawWidth;
@synthesize drawColor=_drawColor;

-(id) init
{
    self=[super init];
    if(self)
    {
        self.paintFrequency=0.7f;
        self.brushWidth=3.0f;
        self.brushThickness=5.0f;
        self.brushType=Slanted;
        self.paintInterval=30;
        self.paintCount=0;
        self.imgBuffer=nil;
        self.srcImagePath=@"";
        self.drawCount=0;
        self.shouldErase=NO;
        self.maxAntSteps=200;
        self.maxAntSharpTurn=45.0f;
        self.minAntTrackLevel=20.0f;
        self.maxAntJumps=7;
        self.brushColorType=ColorCopyRGB;
        self.bcGreen=self.bcRed=self.bcBlue=0.0f;
        self.bcAlpha=0.5f;
        self.shouldShowFace=NO;
        self.drawColor=[UIColor orangeColor];
        self.brushDrawWidth=20;
        self.penDrawWidth=8;
        
        rawData=nil;
        
        //[self setupRecognizers];

    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.paintFrequency=0.7f;
        self.brushWidth=3.0f;
        self.brushThickness=5.0f;
        self.brushType=Slanted;
        self.paintInterval=30;
        self.paintCount=0;
        self.imgBuffer=nil;
        self.srcImagePath=@"";
        self.drawCount=0;
        self.shouldErase=NO;
        self.maxAntSteps=200;
        self.maxAntSharpTurn=45.0f;
        self.minAntTrackLevel=20.0f;
        self.maxAntJumps=7;
        self.brushColorType=ColorCopyRGB;
        self.bcGreen=self.bcRed=self.bcBlue=0.0f;
        self.bcAlpha=0.5f;
        self.shouldShowFace=NO;
        self.drawColor=[UIColor orangeColor];
        self.brushDrawWidth=20;
        self.penDrawWidth=8;
        
        rawData=nil;
        
        CGRect dotFrame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        _cursor = [[NPRCursor alloc] initWithFrame:dotFrame];
        
        [self addSubview:_cursor];
        
        [self setupRecognizers];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
        self.paintFrequency=0.7f;
        self.brushWidth=3.0f;
        self.brushThickness=5.0f;
        self.brushType=Slanted;
        self.paintInterval=30;
        self.paintCount=0;
        self.imgBuffer=nil;
        self.srcImagePath=@"";
        self.drawCount=0;
        self.shouldErase=NO;
        self.maxAntSteps=200;
        self.maxAntSharpTurn=45.0f;
        self.minAntTrackLevel=20.0f;
        self.maxAntJumps=7;
        self.brushColorType=ColorCopyRGB;
        self.bcGreen=self.bcRed=self.bcBlue=0.0f;
        self.bcAlpha=0.5f;
        self.shouldShowFace=NO;
        self.drawColor=[UIColor orangeColor];
        self.brushDrawWidth=20;
        self.penDrawWidth=8;
        
        rawData=nil;
        
        //[self setupRecognizers];
    }
    return self;
}

- (void)dealloc {
    if(rawData)
    {
        free(rawData);
        rawData=nil;
    }
    
    self.srcImage=nil;
}

-(void)showFaces
{
    self.shouldShowFace=YES;
    [self setNeedsDisplay];
}

-(void)setSrcImage:(UIImage *)srcImage
{
    _srcImage=srcImage;
    
    if(rawData)
    {
        free(rawData);
    }
    
    UIImage *fixedImage = [self scaleAndRotateImage:_srcImage];
    CGImageRef imageRef = [fixedImage CGImage];
    img_width = CGImageGetWidth(imageRef);
    img_height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    rawData = (unsigned char*) calloc(img_height * img_width * 4, sizeof(unsigned char));
    
    bytesPerPixel = 4;
    bytesPerRow = bytesPerPixel * img_width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, img_width, img_height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, img_width, img_height), imageRef);
    CGContextRelease(context);
}

+(CGFloat) nextFloat
{
    return (CGFloat)((rand() % 1000000) / 1000000.0f);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ccontext=UIGraphicsGetCurrentContext();
    if(ccontext==nil) return;
    
    if(self.shouldErase)
    {
        [[UIColor whiteColor] setFill];
        CGContextFillRect(ccontext, self.frame);
        self.imgBuffer=[self snapshotOfImage];
        self.shouldErase=NO;
        return;
    }
    
    if(self.imgBuffer)
    {
        // need to adjust the coordinates to draw the image.
        CGContextSaveGState(ccontext);
        
        
        CGContextTranslateCTM(ccontext, 0.0f, self.bounds.size.height);
        CGContextScaleCTM(ccontext, 1.0f, -1.0f);

        CGContextDrawImage(ccontext, self.bounds, [self.imgBuffer CGImage]);
        
        
        CGContextRestoreGState(ccontext);
    }
    
    if(self.shouldShowFace)
    {
        CIContext *cicontext = [CIContext contextWithOptions:nil];
        
        UIImage *fixedImage = [self scaleAndRotateImage:self.srcImage];
        CIImage *coreImage = [CIImage imageWithCGImage:fixedImage.CGImage];
        
        // Set up desired accuracy options dictionary
        NSDictionary *options = [NSDictionary 
                                 dictionaryWithObject:CIDetectorAccuracyHigh
                                 forKey:CIDetectorAccuracy];
        
        // Create new CIDetector
        CIDetector *faceDetector = [CIDetector 
                                    detectorOfType:CIDetectorTypeFace
                                    context:cicontext 
                                    options:options];
        
        NSArray *faces = [faceDetector featuresInImage:coreImage
                                               options:nil];
        
        
        CGFloat cwidth=self.frame.size.width;
        CGFloat cheight=self.frame.size.height;
        
        //NSLog(@"face counts: %d", [faces count]);
        
        for(CIFaceFeature *face in faces)
        {
            
            CGRect ff=face.bounds;
            int ff_left=(int)(floor(ff.origin.x));
            int ff_right=(int)(ceil(ff.origin.x+ff.size.width));
            int ff_bottom=(int)(floor(img_height-ff.origin.y));
            int ff_top=(int)(ceil(img_height - ff.origin.y - ff.size.height));
            
            int xx, yy;
            CGFloat x, y;
            CGFloat red, green, blue, alpha;
            int byteIndex;
            for(yy=ff_top; yy < ff_bottom; yy+=2)
            {
                for(xx=ff_left; xx < ff_right; xx+=2)
                {
                    if(xx < 0) xx=0;
                    if(xx > img_width-1) xx=img_width-1;
                    
                    if(yy < 0) yy=0;
                    if(yy > img_height-1) yy=img_height-1;
                    
                    x=xx * cwidth / img_width;
                    y=yy * cheight / img_height;
                    
                    UIColor* acolor=nil;
                    
                    byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
                    
                    red   = (rawData[byteIndex]     * 1.0) / 255.0;
                    green = (rawData[byteIndex + 1] * 1.0) / 255.0;
                    blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
                    
                    if(self.brushColorType==ColorCopyRGB)
                    {
                        // Now your rawData contains the image data in the RGBA8888 pixel format.
                        alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
                        acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
                    }
                    else 
                    {
                        CGFloat luminance=(0.299f * red + 0.587f * green + 0.114f * blue);
                        acolor = [UIColor colorWithRed:self.bcRed*luminance green:self.bcGreen*luminance blue:self.bcBlue*luminance alpha:self.bcAlpha];
                    }
                    

                    [acolor setFill];
                    CGContextFillRect(ccontext, CGRectMake(x-1, y-1, 2, 2));
                }
            }
            
        }
       
        self.imgBuffer=[self snapshotOfImage];
        self.shouldShowFace=NO;
        return;
    }
    
    if(self.paintCount==0 && self.drawCount==0) return;
    
    if(self.paintCount != 0)
    {
        if(self.brushType==AntSketch)
        {
            for(int ant=0; ant < 50; ant++)
            {
                [self doAntSketch:ccontext];
            }
        }
        else 
        {
            CGFloat pf=self.paintFrequency;
            int xx, yy;
            int jsize=self.paintInterval;
            int jsize2=jsize/2;
            
            for(yy=0; yy < img_height; ++yy)
            {
                for(xx=0; xx < img_width; ++xx)
                {
                    if(xx % jsize2==0 && yy % jsize2==0 && [NPRCanvas nextFloat] < pf)
                    {
                        [self drawBrushAtX:xx andY:yy inContext:ccontext byHand:NO];
                    }
                }
            }
        }
        
        self.paintCount--;
    }
    
    if(self.drawCount != 0)
    {
        NSUInteger cwidth=self.frame.size.width;
        NSUInteger cheight=self.frame.size.height;
        
        int xx1=(int)(self.previousDrawPoint.x * img_width / cwidth);
        int yy1=(int)(self.previousDrawPoint.y * img_height / cheight);
        
        int xx2=(int)(self.currentDrawPoint.x * img_width / cwidth);
        int yy2=(int)(self.currentDrawPoint.y * img_height / cheight);
       
        if(self.cursor.drawTool==Pen)
        {
            CGFloat cwidth=self.frame.size.width;
            CGFloat cheight=self.frame.size.height;
            
            CGFloat xt1=xx1 * cwidth / img_width;
            CGFloat yt1=yy1 * cheight / img_height;
            
            CGFloat xt2=xx2 * cwidth / img_width;
            CGFloat yt2=yy2 * cheight / img_height;
            
            CGContextSetLineWidth(ccontext, self.penDrawWidth);
            [self.drawColor setStroke];
            CGPoint segment[2];
            segment[0]=CGPointMake(xt1, yt1);
            segment[1]=CGPointMake(xt2, yt2);
            CGContextStrokeLineSegments(ccontext, segment, 2);
            //[self drawAtX:x1 andY:y1 inContext:ccontext byHand: YES withColor:self.drawColor andWidth:self.penDrawWidth];
        }
        else 
        {
            CGFloat dx=xx2-xx1;
            CGFloat dy=yy2-yy1;
            
            CGFloat len=sqrt(dx*dx+dy*dy);
            int len2=(int)len;
            
            int di=0;
            CGFloat sin1=dx / len;
            CGFloat cos1=dy / len;
            
            int x1=xx1;
            int y1=yy1;
            CGFloat dx1=sin1 * 3;
            CGFloat dy1=cos1 * 3;
            for(; di < len2; di+=3)
            {
                x1+=dx1;
                y1+=dy1;
                if(self.cursor.drawTool==Brush)
                {
                    [self drawAtX:x1 andY:y1 inContext:ccontext byHand: YES withColor:self.drawColor andWidth:self.brushDrawWidth];
                }
                else if(self.cursor.drawTool==Eraser)
                {
                    //[self drawAtX:x1 andY:y1 inContext:ccontext byHand: YES withColor:self.drawColor andWidth:self.erase];
                    [self drawBrushAtX:x1 andY:y1 inContext:ccontext byHand:YES];
                }
            }

        }
        self.drawCount--;
        //NSLog(@"I am drawing...(%d, %d)", xx, yy);
        //NSLog(@"I am touching...(%lf, %lf)", self.currentDrawPoint.x, self.currentDrawPoint.y);
    }
    
    self.imgBuffer=[self snapshotOfImage];
    
    //NPRAppDelegate *delegate = (NPRAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[delegate hideProgress];
}


- (UIImage *)scaleAndRotateImage:(UIImage *)image 
{
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(void)doAntSketch: (CGContextRef)ccontext
{
    CGFloat cwidth=self.frame.size.width;
    CGFloat cheight=self.frame.size.height;
    
    CGFloat ant_move_distance=self.brushThickness;
    CGFloat ant_mark_length2=self.brushThickness;
    
    int min_jump_steps=-5;
    int max_jump_steps=5;
    
    if(max_jump_steps < self.brushThickness)
    {
        max_jump_steps=(int)self.brushThickness;
        min_jump_steps=-max_jump_steps;
    }
    
    int ant_steps=0;
    //CGFloat memories[3];
    //memories[0]=memories[1]=memories[2]=0;
    int x=(int)(rand() % img_width);
    int y=(int)(rand() % img_height);
    
    CGFloat dx=0;
    CGFloat dy=0;
    CGFloat sx, sy, ex, ey;
    CGFloat sx1, sy1, ex1, ey1;
    CGPoint orientation=CGPointMake(0, 0);
    CGPoint dir=[self getColorGradientNormalAtX:x andY:y];
    CGFloat norm=sqrtf(dir.x * dir.x + dir.y * dir.y);
    
    if(norm > 0)
    {
        orientation=CGPointMake(dir.x / norm, dir.y / norm);
    }
    else {
        orientation=CGPointMake(0, 0);
    }
    
    CGPoint segment[2];
    
    int jump_steps=0;
    
    //update: mark and move
    while(ant_steps < self.maxAntSteps && jump_steps < self.maxAntJumps)
    {
        BOOL should_continue=NO;
        BOOL withinBorder=NO;
        
        
        if(x >= 0 && x < img_width && y >= 0 && y < img_height)
        {
            withinBorder=YES;
        }
        if(norm >= self.minAntTrackLevel && withinBorder)
        {
            should_continue=YES;
        }
        
        if(should_continue)
        {
            //mark the drawing at the current location
            UIColor* acolor=nil;
            int byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            
            //NSLog(@"bi: %d", byteIndex);
            
            CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
            CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
            if(self.brushColorType==ColorCopyRGB)
            {
                
                CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
                
                acolor=[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            }
            else {
                CGFloat luminance=(0.299f * red + 0.587f * green + 0.114f * blue);
                acolor=[UIColor colorWithRed:self.bcRed*luminance green:self.bcGreen*luminance blue:self.bcBlue*luminance alpha:self.bcAlpha];
            }
            
            
            dx=orientation.x * ant_mark_length2;
            dy=orientation.y * ant_mark_length2;
            
            sx=x + dx;
            sy=y + dy;
            
            ex=x - dx;
            ey=y - dy;
            
            
            
            sy1=sy * cheight / img_height;
            sx1=sx * cwidth / img_width;
            
            ey1=ey * cheight / img_height;
            ex1=ex * cwidth / img_width;
            
            segment[0]=CGPointMake(sx1, sy1);
            segment[1]=CGPointMake(ex1, ey1);
            [acolor setStroke];
            
            CGContextSetLineWidth(ccontext, self.brushWidth);
            CGContextStrokeLineSegments(ccontext, segment, 2);
            
            dir=[self getColorGradientNormalAtX:x andY:y];
            norm=sqrtf(dir.x * dir.x + dir.y * dir.y);
            
            if(norm > 0)
            {
                orientation=CGPointMake(dir.x / norm, dir.y / norm);
            }
            else {
                orientation=CGPointMake(0, 0);
            }
            
            int dsx=(int)(orientation.x * ant_move_distance);
            int dsy=(int)(orientation.y * ant_move_distance);
            
            x=x + dsx;
            y=y + dsy;
            
            ant_steps++;
        }
        else
        {
            BOOL local_peak_found=NO;
            int max_i, max_j;
            CGFloat max_norm=norm;
            int xx, yy;
            for(int i=min_jump_steps; i <= max_jump_steps; i++)
            {
                xx=x+i;
                if(xx < 0) continue;
                if(xx >= img_width) break;
                for(int j=min_jump_steps; j <=max_jump_steps; j++)
                {
                    yy=y+j;
                    if(yy<0) continue;
                    if(yy >= img_height) break;
                    
                    CGFloat norm1=[self getColorGradientNormAtX:xx andY:yy];
                    if(norm1 > max_norm)
                    {
                        local_peak_found=YES;
                        max_norm=norm1;
                        max_i=i;
                        max_j=j;
                    }
                }
            }
            
            if(local_peak_found)
            {
                xx=x+max_i;
                yy=y+max_j;
                
                dir=[self getColorGradientNormalAtX:xx andY:yy];
                norm=sqrtf(dir.x * dir.x + dir.y * dir.y);
                
                if(norm > 0)
                {
                    orientation=CGPointMake(dir.x / norm, dir.y / norm);
                }
                else {
                    orientation=CGPointMake(0, 0);
                }
                
            }
            else 
            {
                x=(int)(rand() % img_width);
                y=(int)(rand() % img_height);
                
                dir=[self getColorGradientNormalAtX:x andY:y];
                norm=sqrtf(dir.x * dir.x + dir.y * dir.y);
                
                if(norm > 0)
                {
                    orientation=CGPointMake(dir.x / norm, dir.y / norm);
                }
                else {
                    orientation=CGPointMake(0, 0);
                }
            }
            jump_steps++;
        }
    }

}

-(CGFloat) getColorGradientNormAtX: (int)x andY: (int)y
{
    CGPoint dir=[self getColorGradientAtX:x andY:y];
    return sqrtf(dir.x*dir.x + dir.y*dir.y);
}

-(CGPoint) getColorGradientNormalAtX: (int)x andY: (int)y
{
    CGPoint grad=[self getColorGradientAtX:x andY:y];
    return CGPointMake(-grad.y, grad.x);
}

-(CGPoint) getColorGradientAtX: (int)x andY: (int)y
{
    CGFloat pixel[3][3];
    for(int i=0; i < 3; i++)
    {
        for(int j=0; j<3; j++)
        {
            pixel[i][j]=0;
        }
    }
    
    for(int i=0; i<3; i++)
    {
        int yy=y+i-1;
        if(yy < 0) continue;
        else if(yy >= img_height) break;
        
        for(int j=0; j < 3; j++)
        {
            int xx=x+j-1;
            if(xx < 0) continue;
            else if(xx >= img_width) break;
            
            // Now your rawData contains the image data in the RGBA8888 pixel format.
            int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
            
            CGFloat red   = (rawData[byteIndex]     * 1.0); // / 255.0;
            CGFloat green = (rawData[byteIndex + 1] * 1.0); // / 255.0;
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0); // / 255.0;
            //CGFloat alpha = (rawData[byteIndex + 3] * 1.0); // / 255.0;
            
            CGFloat luminance=(0.299f * red + 0.587f * green + 0.114f * blue);
            
            pixel[i][j]=luminance;
            
        }
    }
    
    CGFloat dx=-pixel[0][0]+pixel[0][2] - 2 * pixel[1][0] + 2 * pixel[1][2] - pixel[2][0] + pixel[2][2];
    CGFloat dy=-pixel[0][0]+pixel[2][0] - 2 * pixel[0][1] + 2 * pixel[2][1] - pixel[0][2] + pixel[2][2];
    
    return CGPointMake(dx, dy);
}

-(void)drawAtX: (int)xx andY: (int)yy inContext: (CGContextRef)ccontext byHand:(BOOL)flgByHand withColor:(UIColor *)c andWidth:(NSUInteger)w
{
    CGFloat cwidth=self.frame.size.width;
    CGFloat cheight=self.frame.size.height;
    
    CGFloat bt=w;
    CGFloat bt2=bt / 2.0f;
    
    CGFloat x=xx * cwidth / img_width;
    CGFloat y=yy * cheight / img_height;
    
    UIColor* acolor=c;
        
    
    UIBezierPath* brush=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x-bt2, y-bt2, bt, bt)];
    [acolor setFill];
    [brush fill];
}


-(void)drawBrushAtX: (int)xx andY: (int)yy inContext: (CGContextRef)ccontext byHand:(BOOL)flgByHand
{
    CGFloat cwidth=self.frame.size.width;
    CGFloat cheight=self.frame.size.height;
    
    int jsize=self.paintInterval;
    int jsize2=jsize/2;
    int maxSteps=5;
    
    CGFloat bt=self.brushThickness;
    CGFloat bt2=bt / 2.0f;
    CGPoint segment[2];
    
    CGFloat red, blue, green, alpha;
    
    int xx2, yy2, byteIndex;
    CGFloat x, y;
    CGFloat bw=self.brushWidth;
    
        for(int nstep=0; nstep < maxSteps; nstep++)
        {
            xx2=xx+(rand() % jsize - jsize2);
            if(xx2 < 0) xx2=0;
            if(xx2 > img_width-1) xx2=img_width-1;
            
            yy2=yy+(rand() % jsize - jsize2);
            if(yy2 < 0) yy2=0;
            if(yy2 > img_height-1) yy2=img_height-1;
                
            x=xx2 * cwidth / img_width;
            y=yy2 * cheight / img_height;
                
            UIColor* acolor=nil;
            byteIndex = (bytesPerRow * yy2) + xx2 * bytesPerPixel;
            
            red   = (rawData[byteIndex]     * 1.0) / 255.0;
            green = (rawData[byteIndex + 1] * 1.0) / 255.0;
            blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
            if(self.brushColorType==ColorCopyRGB)
            {
                // Now your rawData contains the image data in the RGBA8888 pixel format.
                
                alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
            
                acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            }
            else {
                CGFloat luminance=(0.299f * red + 0.587f * green + 0.114f * blue);
                acolor = [UIColor colorWithRed:self.bcRed*luminance green:self.bcGreen*luminance blue:self.bcBlue*luminance alpha:self.bcAlpha];
            }
            
            if(self.brushType==Circle)
            {
                UIBezierPath* brush=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x-bt2, y-bt2, bt, bt)];
                [acolor setFill];
                [brush fill];
            }
            else if(self.brushType==Slanted)
            {
                CGFloat x1=x-bt2;
                CGFloat y1=y-bt2;
                CGFloat x2=x+bt2;
                CGFloat y2=y+bt2;
                segment[0]=CGPointMake(x1, y1);
                segment[1]=CGPointMake(x2, y2);
                [acolor setStroke];
                CGContextSetLineWidth(ccontext, bw);
                CGContextStrokeLineSegments(ccontext, segment, 2);
            }
            else if(self.brushType==BSlanted)
            {
                CGFloat x1=x-bt2;
                CGFloat y1=y+bt2;
                CGFloat x2=x+bt2;
                CGFloat y2=y-bt2;
                segment[0]=CGPointMake(x1, y1);
                segment[1]=CGPointMake(x2, y2);
                [acolor setStroke];
                CGContextSetLineWidth(ccontext, bw);
                CGContextStrokeLineSegments(ccontext, segment, 2);
            }
            else if(flgByHand)
            {
                CGFloat x1=x-bt2;
                CGFloat y1=y+bt2;
                CGFloat x2=x+bt2;
                CGFloat y2=y-bt2;
                segment[0]=CGPointMake(x1, y1);
                segment[1]=CGPointMake(x2, y2);
                [acolor setStroke];
                CGContextSetLineWidth(ccontext, bw);
                CGContextStrokeLineSegments(ccontext, segment, 2);
            }
        }
    
}

-(void)centerCursor {
    
    self.cursor.center = self.center;
    self.currentDrawPoint = self.center;
    
}



- (UIImage*)snapshotOfImage {
    CGContextRef context = UIGraphicsGetCurrentContext();    
    // now convert the final context into an image and return it.
    CGImageRef finalImage = CGBitmapContextCreateImage(context);
    UIImage* image = [UIImage imageWithCGImage:finalImage];
    CGImageRelease(finalImage);
    
    return image;
}


#pragma mark - Private Methods

- (CGRect)rectFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 {
    
    CGFloat xmin = MIN(p1.x, p2.x);
    CGFloat ymin = MIN(p1.y, p2.y);
    CGFloat xmax = MAX(p1.x, p2.x);
    CGFloat ymax = MAX(p1.y, p2.y);
    
    return CGRectMake(xmin, ymin, xmax - xmin, ymax - ymin);
}

- (void)setupRecognizers
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches=1;
    panRecognizer.delegate = self; // Very important
    [self addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired=1;
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

-(void)handleTap:(UITapGestureRecognizer*) recognizer
{
    if(self.cursor.drawTool != None)
    {
        self.currentDrawPoint=[recognizer locationInView:self];
        self.previousDrawPoint=self.currentDrawPoint;
        self.cursor.center=CGPointMake(self.currentDrawPoint.x-self.cursor.xOffset, self.currentDrawPoint.y-self.cursor.yOffset);
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    /*
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    */
    
        
    if(self.cursor.drawTool != None)
    {
        if(recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateEnded)
        {
            self.currentDrawPoint=[recognizer locationInView:self]; //CGPointMake(self.currentDrawPoint.x+translation.x, self.currentDrawPoint.y+translation.y);
            self.previousDrawPoint=self.currentDrawPoint;
        }
        else {
            self.previousDrawPoint=self.currentDrawPoint;
            self.currentDrawPoint=[recognizer locationInView:self]; //CGPointMake(self.currentDrawPoint.x+translation.x, self.currentDrawPoint.y+translation.y);
        }
        
        self.cursor.center=CGPointMake(self.currentDrawPoint.x-self.cursor.xOffset, self.currentDrawPoint.y-self.cursor.yOffset);
        
        self.drawCount++;

        [self setNeedsDisplay];
    }
}

-(void) setNeedsErase
{
    self.shouldErase=true;
    [self setNeedsDisplay];
}

@end

