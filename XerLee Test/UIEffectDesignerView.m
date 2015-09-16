//
//  UIEffectDesignerView.m
//
//  @version 0.1
//  @author Marin Todorov, http://www.touch-code-magazine.com
//

// Copyright (c) 2012 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// The MIT License in plain English: http://www.touch-code-magazine.com/JSONModel/MITLicense

#import "UIEffectDesignerView.h"
#import "NSData+Base64.h"

//the version this view is compatible with
static float kFileFormatVersionExpected = 0.1;

@implementation UIEffectDesignerView
{
    //the root layer for the NSView in OSX
    CALayer* rootLayer;

    //emitter and effect data
    NSDictionary* effect;
}

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
//on iOS this is how you customize the view layer
+ (Class) layerClass
{
    return [CAEmitterLayer class];
}
#endif

//class factory method
+(instancetype)effectWithFile:(NSString*)fileName
{
    return [[UIEffectDesignerView alloc] initWithFile:fileName];
}

//custom initializer
-(instancetype)initWithFile:(NSString*)fileName
{
    self = [super init];
    
    if (self) {

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        //flip the view on the iPhone
        self.transform = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height);
#endif
        
        //load the file
        effect = [self _loadFile:fileName];
        
        //check for file version compatibility
        float fileVersion = [effect[@"version"] floatValue];
        BOOL isValidFileFormat = fileVersion<=kFileFormatVersionExpected;
        NSAssert(isValidFileFormat, @"File version not compatible with effect view. Please update the view class UIEffectDesignerView source code");
        
        //set the effect view frame
        float width = [effect[@"width"] floatValue];
        float height = [effect[@"height"] floatValue];
        float x = [effect[@"x"] floatValue];
        float y = [effect[@"y"] floatValue];
        self.frame = CGRectMake(x-width/2,y-height/2,width,height);
        
        //initialize the emitter
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        self.emitter = (CAEmitterLayer*)self.layer;
#else
        self.emitter = [CAEmitterLayer layer];
#endif
        
        //setup the emitter metrics
        self.emitter.emitterPosition = CGPointMake(self.bounds.size.width /2, self.bounds.size.height/2 );
        self.emitter.emitterSize = self.bounds.size;
        
        //setup the emitter type and mode
        NSArray* kEmitterModes = @[kCAEmitterLayerUnordered, kCAEmitterLayerAdditive, kCAEmitterLayerOldestLast, kCAEmitterLayerOldestFirst];
        self.emitter.emitterMode = kEmitterModes[ [effect[@"emitterMode"] intValue] ];
        
        NSArray* kEmitterTypes = @[kCAEmitterLayerRectangle, kCAEmitterLayerLine, kCAEmitterLayerPoint];
        self.emitter.emitterShape = kEmitterTypes[ [effect[@"emitterType"] intValue] ];
        
        //create new emitter cell
        CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
        
        //load the texture image
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        CFDataRef imgData = (__bridge CFDataRef)[NSData dataFromBase64String: effect[@"texture"]];
        CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData (imgData);
        CGImageRef image = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
        CFRelease(imgDataProvider);
        emitterCell.contents = (__bridge_transfer id)image;
#else
        NSData* imageData = [NSData dataFromBase64String:effect[@"texture"]];
        NSImage* image = [[NSImage alloc] initWithData:imageData];
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)[image TIFFRepresentation], NULL);
        CGImageRef textureCGImage =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CFRelease(source);
        emitterCell.contents = (__bridge_transfer id)textureCGImage;
#endif
        
        emitterCell.name = @"cell";

        //get the particles start color
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        //source: http://stackoverflow.com/a/15242701/208205
        NSUInteger red, green, blue;
        sscanf([effect[@"color"] UTF8String], "#%02X%02X%02X", &red, &green, &blue);
        UIColor* color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:[effect[@"alpha"] floatValue]];
#else
        unsigned int red, green, blue;
        sscanf([effect[@"color"] UTF8String], "#%02X%02X%02X", &red, &green, &blue);
        NSColor* color = [NSColor colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:[effect[@"alpha"] floatValue]];
#endif
        emitterCell.color = color.CGColor;
        
        //copy all the settings to the emitter cell
        emitterCell.birthRate = [effect[@"birthRate"] floatValue];
        emitterCell.lifetime = [effect[@"lifetime"] floatValue];
        emitterCell.lifetimeRange = [effect[@"lifetimeRange"] floatValue];
        emitterCell.velocity = [effect[@"velocity"] floatValue];
        emitterCell.velocityRange = [effect[@"velocityRange"] floatValue];

        emitterCell.redRange = [effect[@"redRange"] floatValue];
        emitterCell.redSpeed = [effect[@"redSpeed"] floatValue];
        emitterCell.greenRange = [effect[@"greenRange"] floatValue];
        emitterCell.greenSpeed = [effect[@"greenSpeed"] floatValue];
        emitterCell.blueRange = [effect[@"blueRange"] floatValue];
        emitterCell.blueSpeed = [effect[@"blueSpeed"] floatValue];
        
        emitterCell.emissionLatitude = [effect[@"latitude"] floatValue];
        emitterCell.emissionLongitude = [effect[@"longitude"] floatValue];

        emitterCell.xAcceleration = [effect[@"xAcceleration"] floatValue];
        emitterCell.yAcceleration = [effect[@"yAcceleration"] floatValue];
        emitterCell.zAcceleration = [effect[@"zAcceleration"] floatValue];

        emitterCell.alphaRange = [effect[@"alphaRange"] floatValue];
        emitterCell.alphaSpeed = [effect[@"alphaSpeed"] floatValue];

        emitterCell.scale = [effect[@"scale"] floatValue];
        emitterCell.scaleRange = [effect[@"scaleRange"] floatValue];
        emitterCell.scaleSpeed = [effect[@"scaleSpeed"] floatValue];
        
        emitterCell.spin = [effect[@"spin"] floatValue];
        emitterCell.spinRange = [effect[@"spinRange"] floatValue];

        emitterCell.redSpeed = [effect[@"redSpeed"] floatValue];
        emitterCell.greenSpeed = [effect[@"greenSpeed"] floatValue];
        emitterCell.blueSpeed = [effect[@"blueSpeed"] floatValue];
        
        //add the cell to the emitter layer
        self.emitter.emitterCells = @[emitterCell];
        
#pragma mark - OSX layer setup
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#else
        //on OSX build the UI hierarchy to show particles
        
        rootLayer = [CALayer layer];
        [rootLayer addSublayer:self.emitter];
        rootLayer.backgroundColor = [NSColor clearColor].CGColor;
        
        [self setLayer:rootLayer];
        [self setWantsLayer:YES];

        rootLayer.masksToBounds = NO;
        self.emitter.masksToBounds = NO;

        //Force the view to update
        [self setNeedsDisplay:YES];
#endif

    }
    
    return self;
}

//just read json file and return a dictionary
-(NSDictionary*)_loadFile:(NSString*)fileName
{
    NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    NSMutableDictionary* dict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];

    NSAssert(dict, @"error loading the .ped file");
    
    return dict;
}

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#else
// on OSX - when the view is added to the UI hierarchy
// resize and position it accordind to the effect settings
// and also make sure the window accepts layer views
-(void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    ((NSView*)self.superview).wantsLayer = YES;
    [self setFrameOrigin:NSMakePoint(self.frame.origin.x, ((NSView*)self.superview).frame.size.height - self.frame.origin.y - self.frame.size.height)];
}
#endif

@end